//
//  UINavigationBar+CustomNavigatorBar.m
//  Bullet
//
//  Created by aJia on 12/11/13.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "UINavigationBar+CustomNavigatorBar.h"
@implementation UINavigationBar (CustomNavigatorBar)
 -(UIImage*)barBackground
{
     CGFloat h=self.frame.size.height;
      UIImage *logoImg=[[UIImage imageNamed:@"logo.png"] imageByScalingToSize:CGSizeMake((373*h)/85, h)];
     return logoImg;
}
-(UIImage*)defaultBackground{
    CGFloat h=self.frame.size.height;
    UIImage *bgImg=[[UIImage imageNamed:@"top_bar.jpg"] imageByScalingToSize:CGSizeMake(self.frame.size.width,h)];
    return bgImg;
}
/**
#pragma -
#pragma 第一种方法添加背景图
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
     UIImage *img=[self barBackground];
     CGRect imgRect=CGRectMake((rect.size.width-img.size.width)/2, 0, img.size.width,img.size.height);
   [[self barBackground] drawInRect:imgRect];
 }
***/
@end
