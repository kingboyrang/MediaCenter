//
//  HotMetaDataCell.m
//  MediaCenter
//
//  Created by aJia on 12/11/22.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "HotMetaDataCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation HotMetaDataCell
@synthesize metaData,delegate;
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
-(id)initWithData:(HotMetaData*)hot withFrame:(CGRect)frame{
    self.metaData=hot;
    return [self initWithFrame:frame];
}
-(void)loadConfigure{
    //发布时间
    UILabel *labTime=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,156, 21)];
    labTime.font=[UIFont systemFontOfSize:17];
    labTime.text=self.metaData.REG_DATE;
    labTime.textColor=[UIColor grayColor];
    [self addSubview:labTime];
    [labTime release];
    
    //访问次数
    CGFloat w=orginRect.size.width-158;
    UIView *viewVisist=[[UIView alloc] initWithFrame:CGRectMake(158, 0,w, 21)];
    UILabel *labVisist=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 73, 21)];
    labVisist.font=[UIFont systemFontOfSize:17];
    labVisist.text=@"訪問次數:";
    labVisist.textColor=[UIColor grayColor];
    [viewVisist addSubview:labVisist];
    CGSize v=[self.metaData.VisitCount CalculateStringSize:[UIFont systemFontOfSize:17] with:w-75];
    UILabel *labVisistCount=[[UILabel alloc] initWithFrame:CGRectMake(75,0,v.width, 21)];
    labVisistCount.font=[UIFont systemFontOfSize:17];
     labVisistCount.textColor=[UIColor grayColor];
    labVisistCount.text=self.metaData.VisitCount;
    [viewVisist addSubview:labVisistCount];
    [labVisistCount release];
    viewVisist.frame=CGRectMake(orginRect.size.width-75-v.width, 0, 75+v.width, 21);
    [self addSubview:viewVisist];
    [viewVisist release];
    //图片
    CustomizeImageView *imageView=[[CustomizeImageView alloc] initWithFrame:CGRectMake(0, 23, orginRect.size.width, 150)];
    NSData *Imgdata= [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.metaData formatFilePath]]];
    UIImage *image=[[UIImage imageWithData:Imgdata] imageByScalingToSize:CGSizeMake(w, 150)];
    //imageView.tag=100+i;
    imageView.delegate=self;
    [imageView setImage:image];
    [self addSubview:imageView];
    [imageView release];
    
    //中文名称
    CGSize textSize=[self.metaData.C_NAME CalculateStringSize:[UIFont boldSystemFontOfSize:20] with:orginRect.size.width];
    UILabel *labCName=[[UILabel alloc] initWithFrame:CGRectMake(0, 175,orginRect.size.width, textSize.height)];
    labCName.font=[UIFont boldSystemFontOfSize:20];
    labCName.numberOfLines=0;
    labCName.lineBreakMode=NSLineBreakByWordWrapping;
    labCName.text=self.metaData.C_NAME;
    [self addSubview:labCName];
    [labCName release];

    //重设高度
    CGRect viewRect=orginRect;
    viewRect.size.height=175+textSize.height;
    self.frame=viewRect;
    
    //设置圆角
    self.layer.borderWidth=1.0;
    self.layer.borderColor=[UIColor grayColor].CGColor;
    self.layer.cornerRadius=5.0;
    

}
#pragma -
#pragma customImageView delegate Methods
-(void)imageTouch:(NSSet *)touches withEvent:(UIEvent *)event whichView:(id)imageView{
    [self.delegate HotMetaDataDetail:touches withEvent:event whichView:self];
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
    [metaData release];
}
@end
