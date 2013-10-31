//
//  CacheHelper.h
//  Eland
//
//  Created by aJia on 13/10/3.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushResult.h"
@interface CacheHelper : NSObject
//推播信息
+(void)cacheCasePushResult:(PushResult*)entity;
+(void)cacheCasePushArray:(NSArray*)results;
+(void)cacheCasePushFromArray:(NSArray*)results;
+(NSArray*)readCacheCasePush;
//保存已删除的推播信息
+(void)cacheDeletePushWithGuid:(NSString*)guid;
+(NSArray*)readDeleteCasePush;
@end
