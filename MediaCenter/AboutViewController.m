//
//  AboutViewController.m
//  MediaCenter
//
//  Created by aJia on 12/12/17.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置logo图标
    [self.navigationItem titleViewBackground];
}
-(UIImage*)autoImageSize:(NSString*)strName{
   UIImage *img=[UIImage imageNamed:strName];
   if (img.size.width>self.view.frame.size.width) {
       CGFloat h=(self.view.frame.size.width*img.size.height)/img.size.width;
       CGFloat w=self.view.frame.size.width;
       return [img imageByScalingToSize:CGSizeMake(w, h)];
   }
   return img;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
