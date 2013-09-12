//
//  FileHttpRequest.h
//  MediaCenter
//
//  Created by aJia on 13/1/3.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@protocol  FileHttpRequestDelegate<NSObject>
@optional
-(void)startFileDownload:(NSString*)url withFileName:(NSString*)fileName;
@end

@interface FileHttpRequest : NSObject<UIAlertViewDelegate>

@property(nonatomic,retain) ASIHTTPRequest *httpRequest;
@property(nonatomic,copy)  NSString *customDownloadFileName;
@property(nonatomic,copy)  NSString *movieDownloadUrl;
@property(nonatomic,copy)  NSString *movieDownloadName;
@property(nonatomic,copy)  NSString *movieType;
@property(nonatomic,assign) id<FileHttpRequestDelegate> delegate;
-(id)initWithDelegate:(id<FileHttpRequestDelegate>)theDelegate;
-(void)startFileRequest:(NSString*)url;
-(NSString*)requestHeaderFileName:(NSString*)fileName;
//开始下载文件
-(void)startDownLoadHandler;
//文件直接开启预览
-(void)openFilePreviewUrl:(NSString*)url withFileName:(NSString*)fileName isLocationFile:(BOOL)boo;
@end
