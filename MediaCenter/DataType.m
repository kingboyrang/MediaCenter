//
//  DataType.m
//  MediaCenter
//
//  Created by aJia on 12/11/21.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "DataType.h"
//资料别
@implementation DataType
//資料別 1:圖片； 2：影音；3：聲音；4：檔案
+(NSString*)DataTypeName:(NSString*)type{
    NSString *result=@"圖片";
    switch ([type intValue]) {
        case 2:
            result=@"影音";
            break;
        case 3:
            result=@"聲音";
            break;
        case 4:
            result=@"檔案";
            break;
        default:
            break;
    }
    return result;
}
@end
