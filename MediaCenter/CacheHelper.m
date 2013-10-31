//
//  CacheHelper.m
//  Eland
//
//  Created by aJia on 13/10/3.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "CacheHelper.h"
#import "FileHelper.h"
#import "PushResult.h"

@interface CacheHelper ()
+(BOOL)existsPushGuid:(NSString*)guid;
@end

@implementation CacheHelper
//推播信息
+(void)cacheCasePushResult:(PushResult*)entity{
    
    if (entity) {
        if ([CacheHelper existsPushGuid:entity.GUID]) {
            return;
        }
        NSArray *arr=[self readCacheCasePush];
        NSMutableArray *source=[NSMutableArray array];
        if (arr&&[arr count]>0) {
            [source addObjectsFromArray:arr];
        }
        int index;
        BOOL boo=[PushResult existsPushResultWithGuid:entity.GUID index:&index];
        if (boo) {
            [source replaceObjectAtIndex:index withObject:entity];
        }else{
            [source addObject:entity];
        }
        [CacheHelper cacheCasePushFromArray:source];
    }
}
+(void)cacheCasePushArray:(NSArray*)results{
    if (results&&[results count]>0) {
        NSMutableArray *source=[NSMutableArray array];
        NSArray *arr=[self readCacheCasePush];
        if (arr&&[arr count]>0) {
            [source addObjectsFromArray:arr];
        }
        for (PushResult *item in results) {
            if ([CacheHelper existsPushGuid:item.GUID]) {
                continue;
            }
            int index;
            BOOL boo=[PushResult existsPushResultWithGuid:item.GUID index:&index];
            if (boo) {
                [source replaceObjectAtIndex:index withObject:item];
            }else{
                [source addObject:item];
            }
        }
        [CacheHelper cacheCasePushFromArray:source];
   }
}
+(void)cacheCasePushFromArray:(NSArray*)results{
    if (results&&[results count]>0) {
        NSString *path=[DocumentPath stringByAppendingPathComponent:@"CachePush"];
        [NSKeyedArchiver archiveRootObject:results toFile:path];
    }
}
+(NSArray*)readCacheCasePush{
    NSString *path=[DocumentPath stringByAppendingPathComponent:@"CachePush"];
    if(![FileHelper isExistsFile:path]){ //如果不存在
        return nil;
    }
    NSArray *arr=[NSKeyedUnarchiver unarchiveObjectWithFile: path];
    return arr;
}
+(BOOL)existsPushGuid:(NSString*)guid{
    NSArray *arr=[CacheHelper readDeleteCasePush];
    if (arr&&[arr count]>0) {
        NSString *match=[NSString stringWithFormat:@"SELF =='%@'",guid];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:match];
        NSArray *results = [arr filteredArrayUsingPredicate:predicate];
        if (results&&[results count]>0) {
            return YES;
        }
    }
    return NO;
}
#pragma mark 推播信息的删除
+(void)cacheDeletePushWithGuid:(NSString*)guid{
    NSArray *arr=[CacheHelper readDeleteCasePush];
    NSMutableArray *result=[NSMutableArray array];
    if (arr&&[arr count]>0) {
        [result addObjectsFromArray:arr];
    }
    [result addObject:guid];
     NSString *path=[DocumentPath stringByAppendingPathComponent:@"CacheDeletePush"];
    [result writeToFile:path atomically:YES];
}
+(NSArray*)readDeleteCasePush{
    NSString *path=[DocumentPath stringByAppendingPathComponent:@"CacheDeletePush"];
    if(![FileHelper isExistsFile:path]){ //如果不存在
        return nil;
    }
   return [NSArray arrayWithContentsOfFile:path];
}
@end
