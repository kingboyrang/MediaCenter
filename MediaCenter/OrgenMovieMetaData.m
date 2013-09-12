//
//  OrgenMovieMetaData.m
//  MediaCenter
//
//  Created by aJia on 12/12/17.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "OrgenMovieMetaData.h"

@implementation OrgenMovieMetaData
@synthesize ItemData;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadConfigure];
    }
    return self;
}
-(id)initWithData:(NSDictionary*)dic withFrame:(CGRect)frame{
    self.ItemData=dic;
    return [self initWithFrame:frame];
}
-(void)loadConfigure{
    CGFloat w=self.frame.size.width;
    CGFloat leftX=5;
    //发布时间
    NSString *newData=[self.ItemData objectForKey:@"REG_DATE"];
     newData=[self formatDateTime:newData];
    NSString *date=[NSString stringWithFormat:@"發佈時間:%@",newData];
   
    CGSize dateSize=[date CalculateStringSize:[UIFont systemFontOfSize:14] with:w];
    //点阅数
    NSString *clickMemo=[NSString stringWithFormat:@"點閱:%@",[self.ItemData objectForKey:@"Views"]];
    CGSize clickSize=[clickMemo CalculateStringSize:[UIFont systemFontOfSize:14] with:w];
    
    
    //标题
    CGFloat nameW=w-clickSize.width-2-leftX;
    NSString *cName=[self.ItemData objectForKey:@"C_NAME"];
    CGSize cNameSize=[cName CalculateStringSize:[UIFont boldSystemFontOfSize:17] with:w];
    cNameSize.height=21;
    [self addControl:[self.ItemData objectForKey:@"C_NAME"] withFont:[UIFont boldSystemFontOfSize:17] frame:CGRectMake(leftX, 0, nameW, cNameSize.height)];
    
    //类别
    NSString *cateName=[NSString stringWithFormat:@"類別:%@",[self.ItemData objectForKey:@"ClassCodeName"]];
    CGSize cateSize=[cateName CalculateStringSize:[UIFont systemFontOfSize:14] with:w];
    UILabel *labCagtegory=[[UILabel alloc] initWithFrame:CGRectMake(leftX, cNameSize.height+1, cateSize.width, cateSize.height)];
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
    CGSize unitSize=[strUnit CalculateStringSize:[UIFont systemFontOfSize:14] with:w];
    UILabel *labUnit=[[UILabel alloc] initWithFrame:CGRectMake(leftX,cNameSize.height+2+cateSize.height, unitSize.width,unitSize.height)];
    labUnit.font=[UIFont systemFontOfSize:14];
    labUnit.textColor=[UIColor grayColor];
    labUnit.text=strUnit;
    
    [self addSubview:labUnit];
    [labUnit release];
    
    //发布时间
    CGFloat topY=cNameSize.height+3+cateSize.height+unitSize.height;
    UILabel *labDate=[[UILabel alloc] initWithFrame:CGRectMake(leftX,topY, dateSize.width,dateSize.height)];
    labDate.text=date;
    labDate.font=[UIFont systemFontOfSize:14];
    labDate.textColor=[UIColor grayColor];
    //[UIColor colorWithRed:230/255 green:145/255 blue:56/255 alpha:1];
    [self addSubview:labDate];
    [labDate release];

    //点阅数
    UILabel *labRead=[[UILabel alloc] initWithFrame:CGRectMake(w-clickSize.width, (self.frame.size.height-clickSize.height)/2, clickSize.width, clickSize.height)];
    labRead.font=[UIFont systemFontOfSize:14];
    labRead.textColor=[UIColor blueColor];
    labRead.text=clickMemo;
    [self addSubview:labRead];
    [labRead release];
    
    //NSLog(@"len=%f\n",topY+dateSize.height);
    
}
-(void)addControl:(NSString*)txt withFont:(UIFont*)f frame:(CGRect)frame{
    UILabel *lab=[[UILabel alloc] initWithFrame:frame];
    //NSLog(@"frame=%@\n",NSStringFromCGRect(frame));
    lab.font=f;
    lab.text=txt;
    [self addSubview:lab];
    [lab release];
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

@end
