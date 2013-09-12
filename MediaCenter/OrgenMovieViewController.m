//
//  OrgenMovieViewController.m
//  MediaCenter
//
//  Created by aJia on 12/11/28.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "OrgenMovieViewController.h"
#import "MediaSoapMessage.h"
#import "AlterMessage.h"
#import "SoapXmlParseHelper.h"
#import "CommonCell.h"
@interface OrgenMovieViewController ()

@end

@implementation OrgenMovieViewController
@synthesize ItemData,listData;
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

    self.listData=[[NSMutableArray alloc] init];
       
    helper=[[ServiceHelper alloc] initWithDelegate:self];
    
    if (!self.hasNetwork) {
        [self showNoNetworkNotice:nil];
    }else{
        [self showLoadingAnimated:YES];
       NSString *soapMsg=[MediaSoapMessage MetaDataByDeptSoap:[self.ItemData objectForKey:@"DEPT_CODE"] childDept:@""];
       [helper AsyServiceMethod:@"GetMetaDataByDept" SoapMessage:soapMsg];
    }
}

#pragma mark -
#pragma mark ServiceHelper delegate Methods
-(void)finishSuccessRequest:(NSString*)responseText responseData:(NSData*)requestData{
    
   self.listData=[SoapXmlParseHelper SearchNodeToArray:responseText NodeName:@"MetaDataByDept"];
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    cell.textLabel.text=@"";
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    CommonCell *commonCell=[[CommonCell alloc] initWithData:[self.listData objectAtIndex:indexPath.row] withFrame:CGRectMake(0, 0, self.view.frame.size.width-25, 60)];
    [cell.contentView addSubview:commonCell];
    [commonCell release];
    return cell;
}
//如果还要传值，可以再这处理
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    SEL sel=NSSelectorFromString(@"itemMetaData");
    if ([destination respondsToSelector:sel]) {
        [destination setTitle:[[self.listData objectAtIndex:selectRow] objectForKey:@"C_NAME"]];
        [destination setValue:[self.listData objectAtIndex:selectRow] forKey:@"itemMetaData"];
    }
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectRow=indexPath.row;
    [self performSegueWithIdentifier:@"organToDetail" sender:self];//页面跳转
}
-(void)dealloc{
    [super dealloc];
    [ItemData release];
    [listData release];
    [helper release];
}
@end
