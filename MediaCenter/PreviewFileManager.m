//
//  DownLoadManager.m
//  DownloadFileCache
//
//  Created by rang on 13-1-24.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "PreviewFileManager.h"

@implementation PreviewFileManager
@synthesize httpRequest;

+ (PreviewFileManager *)sharedInstance
{
    static dispatch_once_t  onceToken;
    static PreviewFileManager * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[PreviewFileManager alloc] init];
    });
    return sSharedInstance;
}
-(NSString*)saveDownloadFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *cachePath=[NSString stringWithFormat:@"%@/MediaDownload",documentDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return cachePath;
}
-(void)startBlockDownLoadFile:(DownLoadArgs*)args progress:(progessDownLoadManager)completion finishDownload:(finishDownLoadManager)finishBlock failedDownload:(failedDownLoadManager)failedBlock{
    Block_release(_progessDownLoadManager);
    Block_release(_faileddownloadBlock);
    Block_release(_finishdownloadBlock);
    
    _progessDownLoadManager=Block_copy(completion);
    _faileddownloadBlock=Block_copy(failedBlock);
    _finishdownloadBlock=Block_copy(finishBlock);
    
    //文件下载设置
    [self.httpRequest clearDelegatesAndCancel];
    [self setHttpRequest:[ASIHTTPRequest requestWithURL:[NSURL URLWithString:args.downloadUrl]]];
    
    
    
    if (_progessDownLoadManager) {
        _progessDownLoadManager(self.httpRequest);
    }
    
    
    [self.httpRequest setShouldContinueWhenAppEntersBackground:YES];//iOS4中，当应用后台运行时仍然请求数据：
    //self.httpRequest.showNetworkActivityIndicator=NO;
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];//是否显示网络请求信息在status bar上：
    [self.httpRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    if (args.isFileCache) {//表示缓存下载
        ASIDownloadCache *myCache=[ASIDownloadCache sharedCache];
        [myCache setStoragePath:args.fileSavePath];//设置缓存路径
        /***
         **ASIOnlyLoadIfNotCachedCachePolicy:如果有缓存在本地，不管其过期与否，总会拿来使用
         **ASIFallbackToCacheIfLoadFailsCachePolicy:这个选项经常被用来与其它选项组合使用。请求失败时，如果有缓存当网络则返回本地缓存信息（这个在处理异常时非常有用）
         **ASIAskServerIfModifiedCachePolicy:与默认缓存大致一样，区别仅是每次请求都会 去服务器判断是否有更新
         ****/
        [myCache setDefaultCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
        
        [self.httpRequest setDownloadCache:myCache];//设置下载缓存
        /****
         ***ASICacheForSessionDurationCacheStoragePolicy:默认策略，基于session的缓存数据存储。当下次运行或[ASIHTTPRequest clearSession]时，缓存将失效
         ***ASICachePermanentlyCacheStoragePolicy，把缓存数据永久保存在本地
         ***/
        [self.httpRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [self.httpRequest setSecondsToCache:60*60*24*1 ]; // 缓存1天
        
        [self.httpRequest setDownloadDestinationPath:[myCache pathToStoreCachedResponseDataForRequest:self.httpRequest]];
    }else{
        [self.httpRequest setDownloadDestinationPath:args.fullSaveFilePath];//文件保存路径
    }
    
    [self.httpRequest setDelegate:self];
    [self.httpRequest startAsynchronous];
}

-(void)startDownLoadFile:(DownLoadArgs*)args{
    [self startBlockDownLoadFile:args progress:nil finishDownload:nil failedDownload:nil];
}
#pragma mark -
#pragma mark ASIHTTPRequest delegate Methods
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    //NSLog(@"X-Powered-By=%@\n",[responseHeaders objectForKey:@"X-Powered-By"]);
     //NSLog(@"Content-Type=%@\n",[responseHeaders objectForKey:@"Content-Type"]);
}
//下载成功
- (void)requestFinished:(ASIHTTPRequest *)request
{
    //NSLog(@"path=%@\n",[request downloadDestinationPath]);
    //判断返回的数据是否来自本地缓存
    if (request.didUseCachedResponse) {
        
        NSLog(@"使用缓存数据");
    } else {
        NSLog(@"请求网络数据");
    }

    
    if (request.responseStatusCode==200) {
        NSString *filePath=[request downloadDestinationPath];
        if (_finishdownloadBlock) {
            _finishdownloadBlock(filePath);
        }
        //NSLog(@"path=%@\n",[request downloadDestinationPath]);
    }else{
        NSError *error=[request error];
        if (_faileddownloadBlock) {
            _faileddownloadBlock(error);
        }
        //NSLog(@"error=%@\n",[error description]);
    }
    
}
//下载失败
- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    NSError *error=[request error];
    //NSLog(@"error=%@\n",[error description]);
    if (_faileddownloadBlock) {
        _faileddownloadBlock(error);
    }
    
}

-(void)dealloc{
    [httpRequest clearDelegatesAndCancel];
    [httpRequest release];
    Block_release(_progessDownLoadManager);
    Block_release(_faileddownloadBlock);
    Block_release(_finishdownloadBlock);
    [super dealloc];
}
@end
