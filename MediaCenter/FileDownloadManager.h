//
//  FileDownloadManager.h
//  MediaCenter
//
//  Created by aJia on 13/1/3.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FileDownloadManager : NSObject
@property(nonatomic,retain)  NSMutableDictionary *movieDictionary;
+(FileDownloadManager *)shareInitialization;

-(void)downloadFile:(NSString*)url withFileName:(NSString*)fileName withData:(NSMutableDictionary*)dic;
//发送下载完成的本地通知
-(void)sendLocationNotice:(NSString*)guid;
-(void)downloadManagerDataDownloadFinished:(NSString *)fileName;
@end
