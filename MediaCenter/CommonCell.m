//
//  CommonCell.m
//  MediaCenter
//
//  Created by aJia on 12/12/1.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "CommonCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation CommonCell
@synthesize ItemData;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        orginRect=frame;
        [self loadConfigure];
    }
    return self;
}
-(id)initWithData:(NSDictionary*)dic withFrame:(CGRect)frame{
    self.ItemData=dic;
    return [self initWithFrame:frame];
}
-(void)loadConfigure{
    NSString *date=[self.ItemData objectForKey:@"REG_DATE"];
    date=[self formatDateTime:date];
    CGSize dateSize=[date CalculateStringSize:[UIFont boldSystemFontOfSize:14] with:orginRect.size.width];
       //标题
    NSString *strTitle=[self.ItemData objectForKey:@"C_NAME"];
    UILabel *labTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, orginRect.size.width-dateSize.width-2,21)];
    labTitle.text=strTitle;
    labTitle.font=[UIFont boldSystemFontOfSize:17];
    [self addSubview:labTitle];
    [labTitle release];
    
    //类别
    NSString *cateName=[NSString stringWithFormat:@"類別:%@",[self.ItemData objectForKey:@"ClassCodeName"]];
    CGSize cateSize=[cateName CalculateStringSize:[UIFont systemFontOfSize:14] with:self.frame.size.width];
    UILabel *labCagtegory=[[UILabel alloc] initWithFrame:CGRectMake(5, 23, cateSize.width, cateSize.height)];
    labCagtegory.font=[UIFont systemFontOfSize:14];
    labCagtegory.textColor=[UIColor grayColor];
    labCagtegory.text=cateName;
    [self addSubview:labCagtegory];
    [labCagtegory release];
    
    //单位
    NSString *unit=@"";
    if ([self.ItemData objectForKey:@"DEPT_NAME"]!=nil) {
        unit=[self.ItemData objectForKey:@"DEPT_NAME"];
    }
    NSString *strUnit=[NSString stringWithFormat:@"單位:%@",unit];
    CGSize unitSize=[strUnit CalculateStringSize:[UIFont systemFontOfSize:14] with:orginRect.size.width];
    UILabel *labUnit=[[UILabel alloc] initWithFrame:CGRectMake(5,24+cateSize.height, unitSize.width,unitSize.height)];
    labUnit.font=[UIFont systemFontOfSize:14];
    labUnit.textColor=[UIColor grayColor];
    labUnit.text=strUnit;
    
    [self addSubview:labUnit];
    [labUnit release];
    
    //时间
    UILabel *labDate=[[UILabel alloc] initWithFrame:CGRectMake(orginRect.size.width-dateSize.width,(orginRect.size.height-dateSize.height)/2, dateSize.width,dateSize.height)];
    labDate.text=date;
    labDate.font=[UIFont boldSystemFontOfSize:14];
    labDate.textColor=[UIColor blueColor];
    //[UIColor colorWithRed:230/255 green:145/255 blue:56/255 alpha:1];
    [self addSubview:labDate];
    [labDate release];

    //NSLog(@"len=%f",unitSize.height+24+cateSize.height); 60
    
}
-(NSString*)formatDateTime:(NSString*)date{
    date=[date Trim];
    if ([date length]==0) {
        return @"";
    }
    if ([date length]>=10) {
        return [date substringWithRange:NSMakeRange(0, 10)];
    }
    return date;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc{
    [super dealloc];
    [ItemData release];
}
@end
