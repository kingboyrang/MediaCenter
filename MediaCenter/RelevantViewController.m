//
//  RelevantViewController.m
//  MediaCenter
//
//  Created by aJia on 12/12/17.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "RelevantViewController.h"

@interface RelevantViewController ()

@end

@implementation RelevantViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//打开网页
- (IBAction)buttonOpenUrlClick:(id)sender {
    int index=[sender tag];
    NSString *url=@"http://www.e-land.gov.tw/";
    if(index==101){
        url=@"http://www.facebook.com/PlanEland?fref=ts&rf=143095005752739";
    }
    if(index==102){
        url=@"http://APPS.e-land.gov.tw";
    }
    [AppHelper openUrl:url];
}
@end
