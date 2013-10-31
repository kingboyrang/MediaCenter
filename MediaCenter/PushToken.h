//
//  PushToken.h
//  Eland
//
//  Created by aJia on 13/10/3.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PushToken : NSObject
@property(nonatomic,copy) NSString *GUID;
@property(nonatomic,copy) NSString *UniqueCode;
@property(nonatomic,copy) NSString *AppCode;
@property(nonatomic,copy) NSString *AppName;
@property(nonatomic,copy) NSString *AppType;
@property(nonatomic,copy) NSString *Flatbed;
-(NSString*)XmlSerialize;
-(NSString*)getPropertyValue:(NSString*)field;
+(NSString*)registerTokenWithDeivceId:(NSString*)deviceId;
@end
