//
//  BaseMetaData.h
//  MediaCenter
//
//  Created by aJia on 12/11/22.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseMetaData : NSObject
@property(nonatomic,retain) NSString *META_PK;
@property(nonatomic,retain) NSString *C_NAME;
@property(nonatomic,retain) NSString *DESCRIPTION;
@property(nonatomic,retain) NSString *REG_DATE;
@property(nonatomic,retain) NSString *DTYPE;
@property(nonatomic,retain) NSString *CATEGORY_NAME;
@property(nonatomic,retain) NSString *DEPT_NAME;
@property(nonatomic,retain) NSString *FilePath;
//格式化图片路径
-(NSString*)formatFilePath;
//获取资料别名称
-(NSString*)dataTypeName;
//时间转换为民国时间
-(NSString*)DateToTw;
@end


