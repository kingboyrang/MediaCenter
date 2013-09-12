//
//  FileDownloadManager.m
//  MediaCenter
//
//  Created by aJia on 13/1/3.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "FileDownloadManager.h"
#import "FileHelper.h"
#import "PreviewFileManager.h"
@implementation FileDownloadManager
@synthesize movieDictionary;
+(FileDownloadManager *)shareInitialization{
    static dispatch_once_t  onceToken;
    static FileDownloadManager * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[FileDownloadManager alloc] init];
    });
    return sSharedInstance;
}
//fileName文件保存的完整路径
-(void)downloadFile:(NSString*)url withFileName:(NSString*)fileName withData:(NSMutableDictionary*)dic{
    
   
    
    NSFileManager *fileManger=[NSFileManager defaultManager];
    if ([fileManger fileExistsAtPath:fileName]) {
        //删除文件
        [FileHelper deleteFilePath:fileName];
    }
    
    self.movieDictionary=dic;
    DownLoadArgs *args=[[[DownLoadArgs alloc] init] autorelease];
    args.downloadUrl=url;
    args.downloadFileName=[fileName lastPathComponent];
    args.fileSavePath=DownFileFolderPath;

    [[PreviewFileManager sharedInstance] startBlockDownLoadFile:args progress:nil finishDownload:^(NSString *filePath){
        [self downloadManagerDataDownloadFinished:filePath];
    
    } failedDownload:^(NSError *error){
    
    }];

}
#pragma mark -
#pragma mark filedown delegate Methods
//文件下载完成
- (void) downloadManagerDataDownloadFinished: (NSString *) fileName
{
    [AppHelper addNoBackupAttribute:[NSURL fileURLWithPath:fileName]];
    
    NSString *name=[fileName lastPathComponent];
    
    if([self.movieDictionary count]>0){
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *currentTime=[dateFormatter stringFromDate:date];
        [dateFormatter release];
        
        [self.movieDictionary setObject:currentTime forKey:@"date"];
        [self.movieDictionary setObject:name forKey:@"name"];
        
        NSMutableArray *arr=[AppHelper fileNameToMovieCollection];
        BOOL boo=YES;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name==%@", name];
        for (NSDictionary *item in arr) {
            if([predicate evaluateWithObject:item]) {
                boo=NO;
                break;
            }
        }
        if (boo) {
            [arr addObject:self.movieDictionary];
            [FileHelper ContentToFile:arr withFileName:@"MediaMovieCollection.plist"];//写入文件中
        }
        //[self sendLocationNotice:fileName];
        [self.movieDictionary removeAllObjects];
    }
}
//发送下载完成的本地通知
-(void)sendLocationNotice:(NSString*)guid{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        NSDate *now=[NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:10];//10秒后通知
        notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber=1; //应用的红色数字
        notification.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
        //去掉下面2行就不会弹出提示框
        NSString *name=[[guid lastPathComponent] stringByDeletingPathExtension];
        notification.alertBody=[NSString stringWithFormat:@"%@下載完成",name];//提示信息 弹出提示框
        //notification.alertAction = @"是";  //提示框按钮
        //notification.hasAction=YES;
        //notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
        
         NSDictionary *infoDict = [NSDictionary dictionaryWithObject:guid forKey:@"path"];
        notification.userInfo = infoDict; //添加额外的信息
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    [notification release];
}
-(void)dealloc{
    [movieDictionary release];
    [super dealloc];
}
@end
