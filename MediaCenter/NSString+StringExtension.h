//
//  NSString+StringExtension.h
//  CaseSearch
//
//  Created by aJia on 12/11/14.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringExtension)
//去除前后空格
-(NSString*)Trim;
-(NSString*)DateToTw:(NSString*)date;
//生成一个guid
+(NSString*)NewGuid;
//获取字符串的宽度与高度
-(CGSize)CalculateStringSize:(UIFont*)font with:(CGFloat)w;
@end
