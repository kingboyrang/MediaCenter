//
//  PushInfo.h
//  CaseSearch
//
//  Created by aJia on 12/11/26.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushInfo : NSObject
// 群组
@property(nonatomic,retain) NSString *Groups;
 // 帐号
@property(nonatomic,retain) NSString *Accounts;
// App
@property(nonatomic,retain) NSString *Apps;
// 标题
@property(nonatomic,retain) NSString *Title;
// 内容
@property(nonatomic,retain) NSString *Content;
//将推播信息写入到本地文件中
+(void)writeToPushFile:(NSMutableDictionary*)dic;
//获取一项推播信息
+(NSMutableDictionary*)PushToDictionary:(NSString*)xml;

+(NSMutableDictionary*)PushStringToDictionary:(NSString*)str;

+(NSMutableDictionary*)PushCheckStringToDictionary:(NSString*)str;
//获取一项push消息
+(NSDictionary*)ItemPushDictionary:(NSString*)guid;
+(NSString*)formatCreateTime:(NSString*)date;
@end

/***
 // 群组
 public string Groups { get; set; }
 // 帐号
 public string Accounts { get; set; }
 // App
 public string Apps { get; set; }
 // 标题
 public string Title { get; set; }
 // 内容
 public string Content { get; set; }
 **/
