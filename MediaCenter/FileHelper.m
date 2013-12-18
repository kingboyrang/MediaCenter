//
//  FileHelper.m
//  CaseSearch
//
//  Created by rang on 12-11-14.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper
//資料存放路徑
+(NSString*)fileSavePath:(NSString*)fileName{
	/*取得行動裝置的檔案存放位置*/
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *savePath=[documentsDirectory stringByAppendingPathComponent:fileName];
	return savePath;
}
+(BOOL)isExistsFile:(NSString*)fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL b=[fileManager fileExistsAtPath:fileName];
	return b;
    /**
    NSString *filepath=[self fileSavePath:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL b=[fileManager fileExistsAtPath:filepath];
	[fileManager release];
	return b;
     **/
}

+(void)ContentToFile:(id)content withFileName:(NSString*)fileName{
    //NSString *errStr;
	NSData *data=[NSPropertyListSerialization dataFromPropertyList:content format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
	//NSLog(@"error:%@",errStr);
	[data writeToFile:[self fileSavePath:fileName] atomically:YES];
}
+(NSArray *)FilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath
{
    NSMutableArray *filenamelist = [NSMutableArray arrayWithCapacity:10];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self isExistsFile:fullpath]) {
            if ([[filename pathExtension] isEqualToString:type]) {
                [filenamelist  addObject:filename];
            }
        }
    }
    
    return filenamelist;
}
+(NSMutableArray*)DirPathList:(NSString*)dirPath{
    NSMutableArray *arr=[NSMutableArray array];
    NSArray *newArr=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    [arr addObjectsFromArray:newArr];
    return arr;
}
+(void)deleteFilePath:(NSString*)dirPath{
    NSFileManager *defaultManager;
    defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:dirPath error:nil];
}
+(void)createFileDir:(NSString*)dirName{
    NSString *imageDir = [NSString stringWithFormat:@"%@/Caches/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"], dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
@end
