//
//  mainRootViewController.m
//  MediaCenter
//
//  Created by aJia on 13/1/4.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "mainRootViewController.h"
#import "PushDetailViewController.h"
#import "PushResult.h"
@interface mainRootViewController ()

@end

@implementation mainRootViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotifice:) name:@"pushDetail" object:nil];
	// Do any additional setup after loading the view.
}
-(void)receiveNotifice:(NSNotification*)notice{
    NSDictionary *dic=[notice userInfo];
    
    int selectIndex=self.selectedIndex;
    NSArray *arr=self.viewControllers;
    UINavigationController *nav=(UINavigationController*)[arr objectAtIndex:selectIndex];
    if (nav) {
        UIStoryboard *storyboard=nav.storyboard;
        PushResult *entity=[PushResult PushResultWithGuid:[dic objectForKey:@"guid"]];
        PushDetailViewController *pushDetail=[storyboard instantiateViewControllerWithIdentifier:@"PushDetailViewController"];
        pushDetail.Entity=entity;
        [nav pushViewController:pushDetail animated:NO];
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSUInteger)supportedInterfaceOrientations{
   //return UIInterfaceOrientationMaskLandscape|UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate
{
      return YES;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
@end
