//
//  Push.h
//  Eland
//
//  Created by aJia on 13/10/9.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PushResult : NSObject<NSCoding>
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *GUID;
@property(nonatomic,copy) NSString *Author;//作者
@property(nonatomic,copy) NSString *Created;//创建时间
@property(nonatomic,copy) NSString *Subject;//标题
@property(nonatomic,copy) NSString *Body;//内容
@property(nonatomic,copy) NSString *Source;//发送来源
@property(nonatomic,copy) NSString *Category;//接收類型
@property(nonatomic,copy) NSString *Receive;//接收內容"
@property(nonatomic,copy) NSString *Immediate;//是否立即發送
@property(nonatomic,copy) NSString *SendTime;//發送時間
@property(nonatomic,copy) NSString *StartTime;//希望發送時間
@property(nonatomic,copy) NSString *AuthToken;//客户Token

@property(nonatomic,readonly) NSString *HtmlBody;//客户Token
-(NSString*)formatDataTw;
+(PushResult*)PushResultWithGuid:(NSString*)guid;
//判断当前这笔资料是否已存在
+(BOOL)existsPushResultWithGuid:(NSString*)guid index:(int*)pos;
-(NSString*)getPropertyValue:(NSString*)field;

@end
