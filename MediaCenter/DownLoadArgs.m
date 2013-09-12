//
//  DownLoadArgs.m
//  DownloadFileCache
//
//  Created by rang on 13-1-25.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "DownLoadArgs.h"

@implementation DownLoadArgs
@synthesize downloadUrl,downloadFileName,fileSavePath;
@synthesize fullSaveFilePath,isFileCache,isExistsFileDownload;

//单例模式
+ (DownLoadArgs *)sharedInstance{
    static dispatch_once_t  onceToken;
    static DownLoadArgs * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[DownLoadArgs alloc] init];
    });
    return sSharedInstance;
}
#pragma mark -
#pragma mark 属性方法重写
-(NSString*)fileSavePath{
    if (fileSavePath) {
        return fileSavePath;
    }
    if (isFileCache) {//表示缓存
        return [self defaultCacheSavePath];
    }
    return [self defaultSavePath];
    
}
-(NSString*)fullSaveFilePath{
    NSString *cachePath=[self fileSavePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return [cachePath stringByAppendingPathComponent:self.downloadFileName];
}
-(BOOL)isExistsFileDownload{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self fullSaveFilePath]]) {
        return YES;
    }
    return NO;
}
#pragma mark -
#pragma mark 默认文件保存路径
//默认文件保存路径
-(NSString*)defaultSavePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *cachePath=[NSString stringWithFormat:@"%@/defaultDownload",documentDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return cachePath;
}
//默认缓存保存路径
-(NSString*)defaultCacheSavePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *cachePath=[NSString stringWithFormat:@"%@/defaultCacheDownload",documentDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return cachePath;
}
@end
