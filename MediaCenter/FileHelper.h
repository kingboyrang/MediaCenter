//
//  FileHelper.h
//  CaseSearch
//
//  Created by rang on 12-11-14.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject
//取得文件路径
+(NSString*)fileSavePath:(NSString*)fileName;
//判断文件是否存在
+(BOOL)isExistsFile:(NSString*)filepath;
//写内容到文件中
+(void)ContentToFile:(id)content withFileName:(NSString*)fileName;
/**
 *  @brief  获得指定目录下，指定后缀名的文件列表
 *
 *  @param  type    文件后缀名
 *  @param  dirPath     指定目录
 *
 *  @return 文件名列表
 */
+(NSArray *)FilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath;
//获取指定目录下的所有文件
+(NSMutableArray*)DirPathList:(NSString*)dirPath;
//删除文件
+(void)deleteFilePath:(NSString*)dirPath;
//创建文件目录
+(void)createFileDir:(NSString*)dirName;
@end
