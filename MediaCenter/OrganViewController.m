//
//  OrganViewController.m
//  MediaCenter
//
//  Created by aJia on 12/11/26.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "OrganViewController.h"
#import "AlterMessage.h"
#import "MediaSoapMessage.h"
#import "SoapXmlParseHelper.h"
@interface OrganViewController ()

@end

@implementation OrganViewController
@synthesize listData;
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
    
    helper=[[ServiceHelper alloc] initWithDelegate:self];
    if (!self.hasNetwork) {
        [self showNoNetworkNotice:nil];
    }else{
        [self showLoadingAnimated:YES];
        NSString *soapMsg=[MediaSoapMessage OrgenTypeSoap];
        [helper AsyServiceMethod:@"GetFirstDeptList" SoapMessage:soapMsg];
    }
}
//如果还要传值，可以再这处理
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UIViewController *destination = segue.destinationViewController;
    SEL sel=NSSelectorFromString(@"ItemData");
    if ([destination respondsToSelector:sel]) {
        NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
        [destination setTitle:[[self.listData objectAtIndex:indexPath.row] objectForKey:@"DEPT_NAME"]];
        [destination setValue:[self.listData objectAtIndex:indexPath.row] forKey:@"ItemData"];
    }
}
#pragma mark -
#pragma mark ServiceHelper delegate Methods
-(void)finishSuccessRequest:(NSString*)xml responseData:(NSData*)requestData{
    self.listData=[SoapXmlParseHelper SearchNodeToArray:xml NodeName:@"Department"];
    [self.tableView reloadData];
    if ([self.listData count]>0) {
        [self hideLoadingViewAnimated:YES];
    }else{
        [self hideLoadingViewAnimated:YES completed:^(AnimateLoadView *hideView) {
            [hideView.activityIndicatorView stopAnimating];
           [self showErrorNoticeWithTitle:@"請求完成" message:@"沒有返回數據!" dismiss:nil];
        }];
    }

}
-(void)finishFailRequest:(NSError*)error{
    [self hideLoadingViewAnimated:YES completed:^(AnimateLoadView *hideView) {
        [hideView.activityIndicatorView stopAnimating];
        [self showErrorNoticeWithTitle:@"沒有返回數據" message:@"加載失敗!" dismiss:nil];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellDeptIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dic=[self.listData objectAtIndex:indexPath.row];
    cell.textLabel.text=[dic objectForKey:@"DEPT_NAME"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"影片數量:%@",[dic objectForKey:@"MetaCount"]];
    // Configure the cell...
    
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectRow=indexPath.row;
}
-(void)dealloc{
    [super dealloc];
    [listData release];
}
@end
