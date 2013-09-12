//
//  NewsDetailViewController.m
//  MediaCenter
//
//  Created by aJia on 12/11/24.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController
@synthesize NewsItem;
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
    self.tView.text=[self.NewsItem objectForKey:@"Content"];
    CGRect frame=self.tView.frame;
    frame.size.height=self.view.bounds.size.height-44*2;
    self.tView.frame=frame;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tView release];
    [NewsItem release];
    [super dealloc];
}
@end
