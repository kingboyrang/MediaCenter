//
//  BenefitViewController.m
//  MediaCenter
//
//  Created by aJia on 13/9/25.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "BenefitViewController.h"
#import "MediaSoapMessage.h"
#import "AlterMessage.h"
#import "SearchMetaData.h"
#import "CommonCell.h"
@interface BenefitViewController ()
-(void)loadData;
-(void)loadSourceData;
-(void)updateSourceData:(NSString*)xml;
@end

@implementation BenefitViewController

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
    //创建UITableView
   
    _tableView=[[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.bounds.size.height-44) pullingDelegate:self];
    //[[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 48, self.view.frame.size.width,h)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView setAutoresizesSubviews:YES];
    [_tableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view addSubview:_tableView];
    
    pageSize=10;
    if ([AppHelper isIPad]) {
        pageSize=20;
    }
    helper=[[ServiceHelper alloc] initWithDelegate:self];

    //初始化
    curPage=0;
    maxPage=1;
    isFirstLoad=YES;
    if (!self.hasNetwork) {
        [self showNoNetworkNotice:nil];
    }else{
        [_tableView launchRefreshing];//默认加载10笔数据
    }

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//查询
-(void)startSearch{
    NSString *soapMsg=[MediaSoapMessage BenfitMovieSoap:@"" withCurPage:curPage withCurSize:pageSize];
    [helper AsyServiceMethod:@"CategorySearchMetaData" SoapMessage:soapMsg];
}
#pragma mark -
#pragma mark ServiceHelper delegate Methods
-(void)finishSuccessRequest:(NSString*)xml responseData:(NSData*)requestData{
    [_tableView tableViewDidFinishedLoading];
    _tableView.reachedTheEnd  = NO;
    [self performSelectorOnMainThread:@selector(updateSourceData:) withObject:xml waitUntilDone:NO];
    
}
-(void)finishFailRequest:(NSError*)error{
    [_tableView tableViewDidFinishedLoadingWithMessage:@"沒有返回數據!"];
    _tableView.reachedTheEnd  = NO;
    curPage--;
}
#pragma mark -
#pragma mark TableView DataSource delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellNewsIdentifier = @"CellDistrictIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellNewsIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellNewsIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    cell.textLabel.text=@"";
    
    NSDictionary *dic=[self.listData objectAtIndex:indexPath.row];
    
    CommonCell *commonCell=[[CommonCell alloc] initWithData:dic withFrame:CGRectMake(0, 0, self.view.frame.size.width-25, 60)];
    [cell.contentView addSubview:commonCell];
    [commonCell release];
    
    
    return cell;
}
#pragma -
#pragma TableView delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectRow=indexPath.row;
    [self performSegueWithIdentifier:@"BenefitToDetail" sender:self];
    
    
    //
}
//如果还要传值，可以再这处理
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    SEL sel=NSSelectorFromString(@"itemMetaData");
    if ([destination respondsToSelector:sel]) {
        // NSIndexPath *indexPath=[self.tabView indexPathForSelectedRow];
        NSDictionary *dic=[self.listData objectAtIndex:selectRow];
        [destination setTitle:[dic objectForKey:@"C_NAME"]];
        [destination setValue:dic forKey:@"itemMetaData"];
    }
}
-(void)updateSourceData:(NSString*)xml{
    NSString *page;
    NSMutableArray *arr=[SearchMetaData XmlToArray:xml withMaxPage:&page];
    
    if (arr==nil||[arr count]==0) {
        [_tableView tableViewDidFinishedLoadingWithMessage:@"沒有返回數據!"];
        _tableView.reachedTheEnd  = NO;
        curPage--;
        return;
    }
    maxPage=[page intValue];
    if (isFirstLoad) {//表示第一次加载
        isFirstLoad=NO;
        self.listData=arr;
        [_tableView reloadData];
    }else{
        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:pageSize];
        for (int i=0; i<[arr count]; i++){
            [self.listData addObject:[arr objectAtIndex:i]];
            NSIndexPath *newPath=[NSIndexPath indexPathForRow:(curPage-1)*pageSize+i inSection:0];
            [insertIndexPaths addObject:newPath];
        }
        //重新呼叫UITableView的方法, 來生成行.
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
        
    }
}
-(void)loadSourceData{
    //开始查询
    [self startSearch];
}
-(void)loadData{
    if (self.refreshing) {
        self.refreshing=NO;
    }
    if (![[NetWorkConnection sharedInstance] hasConnection]) {
        _tableView.reachedTheEnd  = NO;
        [_tableView tableViewDidFinishedLoadingWithMessage:@"請檢查網絡連接.."];
        return;
    }
    if (curPage!=maxPage) {
        curPage++;
        if (curPage>=maxPage) {
            curPage=maxPage;
        }
        [self loadSourceData];//加载数据
    }else{
        [_tableView tableViewDidFinishedLoadingWithMessage:@"沒有了哦.."];
        _tableView.reachedTheEnd  = YES;
        
    }
}
#pragma mark - PullingRefreshTableViewDelegate
//下拉加载
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

//上拉加载
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

#pragma mark - Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_tableView tableViewDidEndDragging:scrollView];
}

@end
