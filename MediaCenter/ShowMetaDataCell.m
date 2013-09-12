//
//  ShowMetaDataCell.m
//  MediaCenter
//
//  Created by aJia on 12/11/21.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "ShowMetaDataCell.h"
#import "CustomizeImageView.h"
#import <QuartzCore/QuartzCore.h>
@implementation ShowMetaDataCell
//@synthesize DEPT_NAME,REG_DATE,FilePath,C_NAME;
@synthesize listData,delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadConfigure:frame];
    }
    return self;
}
-(id)initWithData:(NSDictionary*)dic withFrame:(CGRect)frame{
    self.listData=dic;
    return [self initWithFrame:frame];
}
-(void)loadConfigure:(CGRect)frame{
    CGRect viewRect=frame;
    CGFloat w=frame.size.width;
    //部门
    UILabel *labDept=[[UILabel alloc] initWithFrame:CGRectMake(0,0, w-156, 21)];
    labDept.font=[UIFont systemFontOfSize:17];
    labDept.text=[self.listData objectForKey:@"DEPT_NAME"];
    [self addSubview:labDept];
    [labDept release];
    //发布时间
    UILabel *labTime=[[UILabel alloc] initWithFrame:CGRectMake(w-156, 0,156, 21)];
    labTime.font=[UIFont systemFontOfSize:17];
    labTime.text=[self.listData objectForKey:@"REG_DATE"];
    [self addSubview:labTime];
    [labTime release];
    //图片
    CustomizeImageView *imageView=[[CustomizeImageView alloc] initWithFrame:CGRectMake(0, 23, w, 150)];
    NSData *Imgdata= [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.listData objectForKey:@"FilePath"]]];
    UIImage *image=[[UIImage imageWithData:Imgdata] imageByScalingToSize:CGSizeMake(w, 150)];
    //imageView.tag=100+i;
    imageView.delegate=self;
    [imageView setImage:image];
    [self addSubview:imageView];
    [imageView release];
    //中文名称
    NSString *strCName=[self.listData objectForKey:@"C_NAME"];
    CGSize textSize = [strCName sizeWithFont:[UIFont boldSystemFontOfSize:20]
                           constrainedToSize:CGSizeMake(w, CGFLOAT_MAX)
                               lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect orginRect=CGRectMake(0,175,w, textSize.height);
    UILabel *labCName=[[UILabel alloc] initWithFrame:orginRect];
    labCName.font=[UIFont boldSystemFontOfSize:20];
    labCName.numberOfLines=0;
    labCName.lineBreakMode=NSLineBreakByWordWrapping;
    labCName.text=strCName;
    [self addSubview:labCName];
    [labCName release];
    
    //重设高度
    viewRect.size.height=175+orginRect.size.height;
    self.frame=viewRect;
    
    //设置圆角
    self.layer.borderWidth=1.0;
    self.layer.borderColor=[UIColor grayColor].CGColor;
    self.layer.cornerRadius=5.0;

}
#pragma -
#pragma customImageView delegate Methods
-(void)imageTouch:(NSSet *)touches withEvent:(UIEvent *)event whichView:(id)imageView{
    [self.delegate ShowMetaDataDetail:touches withEvent:event whichView:self];
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
    [listData release];
    /**
    [DEPT_NAME release];
    [REG_DATE release];
    [FilePath release];
    [C_NAME release];
     **/
}
@end
