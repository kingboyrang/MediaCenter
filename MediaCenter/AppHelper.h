//
//  AppHelper.h
//  MediaCenter
//
//  Created by aJia on 12/11/12.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/xattr.h>
@interface AppHelper : NSObject
//获取影音收藏信息
+(NSMutableArray*)fileNameToMovieCollection;
//影音收藏信息的删除
+(void)movieDeleteFile:(NSString*)guid;
//获取推播列表
+(NSMutableArray*)fileNameToPush;
//获取使用者信息
+(NSMutableDictionary*)fileNameToSystemUser;
+ (void)showHUD:(NSString *)msg;
+ (void)removeHUD;
+(void)openUrl:(NSString*)url;
//格式化时间
+(NSString*)formatShowDate:(NSString*)date;
//判断是否为ipad
+(BOOL)isIPad;
//表示下载的文件不同步到iCloud and iTunes里面 for 5.1 later
+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
//表示下载的文件不同步到iCloud and iTunes里面 for 5.0.1 以前
+(BOOL)addSkipBackupAttributeToItemAtURL5:(NSURL *)URL;

+(void)addNoBackupAttribute:(NSURL *)URL;
@end
