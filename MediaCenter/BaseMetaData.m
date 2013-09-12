//
//  BaseMetaData.m
//  MediaCenter
//
//  Created by aJia on 12/11/22.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "BaseMetaData.h"
#import "DataType.h"
@implementation BaseMetaData
@synthesize META_PK,C_NAME,DESCRIPTION,REG_DATE;
@synthesize DTYPE,CATEGORY_NAME,DEPT_NAME;
@synthesize FilePath;
-(NSString*)formatFilePath{
    if (self.FilePath==NULL||self.FilePath==nil) {
        return @"";
    }
    return [self.FilePath stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
}
-(NSString*)dataTypeName{
    if (self.DTYPE==NULL||self.DTYPE==nil) {
        return @"";
    }
    return [DataType DataTypeName:self.DTYPE];
}
-(NSString*)DateToTw{
    if (self.REG_DATE==NULL||self.REG_DATE==nil) {
        return @"";
    }
    int y=[[self.REG_DATE substringWithRange:NSMakeRange(0, 4)] intValue];
     return [NSString stringWithFormat:@"%d%@",y-1911,[self.REG_DATE stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""]];
}
@end
