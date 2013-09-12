//
//  MenuViewController.m
//  MediaCenter
//
//  Created by aJia on 12/12/17.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "MenuViewController.h"
@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置logo图标
    [self.navigationItem titleViewBackground];
    //设置tabBarItem图片
    NSArray *barItemArr=self.tabBarController.tabBar.items;
    NSMutableArray *barImgs=[NSMutableArray array];
    [barImgs addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"movieArea_normal.png",@"normal",@"movieArea_select.png",@"select", nil]];
    [barImgs addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"movieDistrict_normal.png",@"normal",@"movieDistrict_select.png",@"select", nil]];
    [barImgs addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"moviefavorite_normal.png",@"normal",@"moviefavorite_select.png",@"select", nil]];
    [barImgs addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"box_normal.png",@"normal",@"box_select.png",@"select", nil]];
    [barImgs addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"about_normal.png",@"normal",@"about_select.png",@"select", nil]];
    for (int a=0; a<[barItemArr count]; a++) {
        UITabBarItem *barItem=(UITabBarItem*)[barItemArr objectAtIndex:a];
        [barItem setFinishedSelectedImage:[[UIImage imageNamed:[[barImgs objectAtIndex:a] objectForKey:@"select"]] imageByScalingProportionallyToSize:CGSizeMake(30, 30)] withFinishedUnselectedImage:[[UIImage imageNamed:[[barImgs objectAtIndex:a] objectForKey:@"normal"]] imageByScalingProportionallyToSize:CGSizeMake(30, 30)]];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
