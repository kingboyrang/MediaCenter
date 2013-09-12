//
//  DownLoadManager.h
//  DownloadFileCache
//
//  Created by rang on 13-1-24.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "DownLoadArgs.h"

typedef void (^progessDownLoadManager)(ASIHTTPRequest *request);
typedef void(^finishDownLoadManager)(NSString *filePath);
typedef void (^failedDownLoadManager)(NSError *error);

@interface PreviewFileManager : NSObject{
    progessDownLoadManager _progessDownLoadManager;
    finishDownLoadManager _finishdownloadBlock;
    failedDownLoadManager _faileddownloadBlock;
}
@property(nonatomic,retain) ASIHTTPRequest *httpRequest;
//单例模式
+ (PreviewFileManager *)sharedInstance;
//开始下载文件
-(void)startDownLoadFile:(DownLoadArgs*)args;
//开始下载文件
-(void)startBlockDownLoadFile:(DownLoadArgs*)args progress:(progessDownLoadManager)completion finishDownload:(finishDownLoadManager)finishBlock failedDownload:(failedDownLoadManager)failedBlock;
//文件保存路径
-(NSString*)saveDownloadFilePath;
@end
