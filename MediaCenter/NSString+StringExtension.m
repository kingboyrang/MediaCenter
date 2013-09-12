//
//  NSString+StringExtension.m
//  CaseSearch
//
//  Created by aJia on 12/11/14.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "NSString+StringExtension.h"

@implementation NSString (StringExtension)
-(NSString*)Trim{
    if (self==nil||self==NULL||[self length]==0) {
		return @"";
	}
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
-(NSString*)DateToTw:(NSString*)date{
    /**
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy-MM-dd HH:mm:ss:SS"];//[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *oldDate=[df dateFromString:date];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate=[df stringFromDate:oldDate];
    [df release];
     **/
    NSRange range = [date  rangeOfString:@"." options:NSBackwardsSearch];
    if (range.location!=NSNotFound) {
        int pos=range.location;
        date=[date substringWithRange:NSMakeRange(0, pos)];
    }
    int y=[[date substringWithRange:NSMakeRange(0,4)] intValue];
    
    return [NSString stringWithFormat:@"%d%@",y-1911,[date stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""]];
}
+(NSString*)NewGuid{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}
-(CGSize)CalculateStringSize:(UIFont*)font with:(CGFloat)w{
   CGSize textSize = [self sizeWithFont:font
                       constrainedToSize:CGSizeMake(w, CGFLOAT_MAX)
                           lineBreakMode:NSLineBreakByWordWrapping];
    return textSize;
}
@end
