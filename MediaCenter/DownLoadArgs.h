//
//  DownLoadArgs.h
//  DownloadFileCache
//
//  Created by rang on 13-1-25.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadArgs : NSObject
@property(nonatomic,copy) NSString *downloadUrl;//文件下载的url
@property(nonatomic,copy) NSString *downloadFileName;//文件名
@property(nonatomic,copy) NSString *fileSavePath;//文件保存路径,如: /user/document/
@property(nonatomic,readonly) NSString *fullSaveFilePath;//文件完整路径  fileSavePath+downloadFileName
@property(nonatomic,assign) BOOL isFileCache;//设置下载的文件是否保存在缓存中
@property(nonatomic,readonly) BOOL isExistsFileDownload;//判断下载的文件是否已存在


//单例模式
+ (DownLoadArgs *)sharedInstance;
//默认文件保存路径
-(NSString*)defaultSavePath;
//默认缓存保存路径
-(NSString*)defaultCacheSavePath;
@end
