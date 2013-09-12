//
//  AppHelper.m
//  MediaCenter
//
//  Created by aJia on 12/11/12.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "AppHelper.h"
#import "MBProgressHUD.h"
#import "FileHelper.h"
#import "UIDevice+IdentifierAddition.h"
@implementation AppHelper
static MBProgressHUD *HUD;
//MBProgressHUD 的使用方式，只对外两个方法，可以随时使用(但会有警告！)，其中窗口的 alpha 值 可以在源程序里修改。
+ (void)showHUD:(NSString *)msg{
	
	HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
	[[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.dimBackground = YES;
	HUD.labelText = msg;
	[HUD show:YES];
}
+ (void)removeHUD{
	if (HUD) {
        [HUD hide:YES];
        [HUD removeFromSuperViewOnHide];
        [HUD release];
    }
	
}
//获取影音收藏信息
+(NSMutableArray*)fileNameToMovieCollection{
    NSMutableArray *data=[NSMutableArray array];
	NSString *documentsPath = [FileHelper fileSavePath:@"MediaMovieCollection.plist"];
	if(![FileHelper isExistsFile:documentsPath])return data;
	data= [[[NSMutableArray alloc] initWithContentsOfFile:documentsPath] autorelease];
	return data;
}
//影音收藏信息的删除
+(void)movieDeleteFile:(NSString*)guid{
    NSMutableArray *arr=[self fileNameToMovieCollection];
    for (int i=0;i<[arr count];i++) {
        NSDictionary *item=[arr objectAtIndex:i];
        NSString *name=[item objectForKey:@"guid"];
        if ([name isEqualToString:guid]) {
            //删除一项
            [arr removeObjectAtIndex:i];
            //重新写入文件中
            [FileHelper ContentToFile:arr withFileName:@"MediaMovieCollection.plist"];
            break;
        }
    }
}
+(NSMutableArray*)fileNameToPush{
    NSMutableArray *data=[NSMutableArray array];
	NSString *documentsPath = [FileHelper fileSavePath:@"MediaCenterPush.plist"];
	if(![FileHelper isExistsFile:documentsPath])return data;
	data= [[[NSMutableArray alloc] initWithContentsOfFile:documentsPath] autorelease];
	return data;
}
+(NSMutableDictionary*)fileNameToSystemUser{
    NSMutableDictionary *data=[NSMutableDictionary dictionary];
	NSString *documentsPath = [FileHelper fileSavePath:@"User.plist"];
	if(![FileHelper isExistsFile:documentsPath])return data;
	data= [[NSMutableDictionary alloc] initWithContentsOfFile:documentsPath];
	return data;
}
/***页面跳转****/
+(void)openUrl:(NSString*)skipUrl{
    NSURL *url=[NSURL URLWithString:skipUrl];
    [[UIApplication sharedApplication] openURL:url];
}
//格式化时间
+(NSString*)formatShowDate:(NSString*)date{
    date=[date stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSRange r = [date  rangeOfString:@":" options:NSBackwardsSearch];
    if (r.location!=NSNotFound) {
        int pos=r.location;
        date=[date substringWithRange:NSMakeRange(0, pos)];
    }
    return date;
}
//判断是否为ipad
+(BOOL)isIPad{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
}
//表示下载的文件不同步到iCloud and iTunes里面
+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}
//表示下载的文件不同步到iCloud and iTunes里面 for 5.0.1 以前
+(BOOL)addSkipBackupAttributeToItemAtURL5:(NSURL *)URL{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}
+(void)addNoBackupAttribute:(NSURL *)URL{
    float fVersion=[UIDevice AppSystemVersion];
     if (fVersion < 5.1) {
        [self addSkipBackupAttributeToItemAtURL5:URL];
    }else{
        [self addSkipBackupAttributeToItemAtURL:URL];
    }
}
@end
