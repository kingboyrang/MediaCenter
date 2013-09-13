//
//  DistrictViewController.m
//  MediaCenter
//
//  Created by aJia on 12/12/3.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "DistrictViewController.h"
#import "MediaSoapMessage.h"
#import "AlterMessage.h"
#import "SearchMetaData.h"
#import "CommonCell.h"
@interface DistrictViewController ()
-(void)loadData;
-(void)loadSourceData;
-(void)updateSourceData:(NSString*)xml;
@end

@implementation DistrictViewController
@synthesize keyWord,listData;
@synthesize refreshing;
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
    CGFloat h=self.view.frame.size.height-48;
    _tableView=[[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 48, self.view.frame.size.width,h) pullingDelegate:self];
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
    
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //初始化
    curPage=0;
    maxPage=1;
    isFirstLoad=YES;
    self.keyWord=@"";
    if (!self.hasNetwork) {
        [self showNoNetworkNotice:nil];
    }else{
        [_tableView launchRefreshing];//默认加载10笔数据
    }
}
//查询
-(void)startSearch{
    NSString *soapMsg=[MediaSoapMessage DistrictMovieSoap:self.keyWord withCurPage:curPage withCurSize:pageSize];
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
        [self performSegueWithIdentifier:@"DistrictToDetail" sender:self];
        
       
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [super dealloc];
    [helper release];
    [keyWord release];
    [listData release];
    [_tableView release],_tableView=nil;
}
//打开链接
- (IBAction)buttonLinkClick:(id)sender {
    int btnTag=[sender tag];
    NSString *skipUrl=@"http://www.facebook.com/pages/幸福宜蘭-林聰賢/150474111655916";//fackbook
    if(btnTag==101){
       skipUrl=@"http://www.plurk.com/YilanFirst";
    }
    NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                   (CFStringRef)skipUrl,
                                                                                   NULL,
                                                                                   NULL,
                                                                                   kCFStringEncodingUTF8);
    [AppHelper openUrl:encodedString];
}
//点击查询按钮时，出现查询对话框
- (IBAction)btnSearchclick:(id)sender{
    [self clearChildsView];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,206,44)];
    searchBar.delegate = self;
    //searchBar.showsCancelButton=YES;
    searchBar.placeholder=@"輸入關鍵字";
    self.navigationItem.titleView=searchBar;
    [searchBar release];
    
    UIBarButtonItem *rightCancelButton=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(btnDelSearchClick:)];
    self.navigationItem.rightBarButtonItem=rightCancelButton;
    [rightCancelButton release];

}
-(void)btnDelSearchClick:(id)sender{
    _tableView.allowsSelection=YES;
    _tableView.scrollEnabled=YES;
    
    UIBarButtonItem *searchButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(buttonSearchMovie:)];
    self.navigationItem.rightBarButtonItem=searchButton;
    [searchButton release];
    
    [self clearChildsView];
    //重设Title内容
    [self.navigationItem titleViewBackground];
    /***
     UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
     customLab.backgroundColor=[UIColor clearColor];
     customLab.textColor=[UIColor whiteColor];
     customLab.font=[UIFont boldSystemFontOfSize:20];
     [customLab setText:@"影音專區"];
     [customLab sizeToFit];
     self.navigationItem.titleView = customLab;
     [customLab release];
     **/
}
- (IBAction)buttonSearchMovie:(id)sender {
    [self clearChildsView];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,206,44)];
    searchBar.delegate = self;
    //searchBar.showsCancelButton=YES;
    searchBar.placeholder=@"輸入關鍵字";
    self.navigationItem.titleView=searchBar;
    [searchBar release];
    
    UIBarButtonItem *rightCancelButton=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(btnDelSearchClick:)];
    self.navigationItem.rightBarButtonItem=rightCancelButton;
    [rightCancelButton release];
}
//清除搜寻框
-(void)clearChildsView{
    for (id v in self.navigationItem.titleView.subviews) {
        if ([v isKindOfClass:[UISearchBar class]]) {
            UISearchBar *searchBar=(UISearchBar*)v;
            for (id item in searchBar.subviews) {
                if ([item isKindOfClass:[UITextField class]]) {
                    [item resignFirstResponder];//失去焦点
                }
            }
            
        }
        [v removeFromSuperview];
    }

}
#pragma mark -
#pragma mark UISearchBar delegate Methods
//添加搜索框事件：
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    _tableView.allowsSelection=NO;
    _tableView.scrollEnabled=NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.listData removeAllObjects];
    self.KeyWord=searchBar.text;//获取查询条件
    [searchBar resignFirstResponder];
    
    _tableView.allowsSelection=YES;
    _tableView.scrollEnabled=YES;
    
    isFirstLoad=YES;
    curPage=0;
    maxPage=1;
    
    [_tableView launchRefreshing];//默认加载10笔数据
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
