//
//  CustomNavigationBar.m
//  MediaCenter
//
//  Created by aJia on 12/11/6.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "CustomNavigationBar.h"
@implementation UINavigationBar (UINavigationBarCategory)

/***
#pragma -
#pragma 第一种方法添加背景图
-(UIImage*)barBackground
{
    return [[UIImage imageNamed:@"SearchBg.png"] imageByScalingToSize:CGSizeMake(self.frame.size.height, self.frame.size.height)];
}

-(void)didMoveToSuperview
{
    //iOS5 only
    if([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self setBackgroundImage:[self barBackground] forBarMetrics:UIBarMetricsDefault];
        
    }
}
//this doesn't work on iOS5 but is needed for iOS4 and earlier
-(void)drawRect:(CGRect)rect
{
    //draw image
    [[self barBackground] drawInRect:rect];
}
***/
#pragma -
#pragma 第二种方法添加背景图
-(void)setBackgroudImage:(UIImage*)image
{
    CGSize imageSize =[image size];
    self.frame =CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width, imageSize.height);
    UIImageView*backgroundImage =[[UIImageView alloc] initWithImage:image];
    backgroundImage.frame =self.bounds;
    [self addSubview:backgroundImage];
    [backgroundImage release];
}
@end