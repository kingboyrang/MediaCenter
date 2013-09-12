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

@end

@implementation DistrictViewController
@synthesize keyWord,listData,tabView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //初始化
    curPage=1;
    maxPage=1;
    isFirstLoad=YES;
    self.keyWord=@"";
    if (!self.hasNetwork) {
        [self showNoNetworkNotice:nil];
    }else{
      [self startSearch];//默认加载数据
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置logo图标
    [self.navigationItem titleViewBackground];
    //创建UITableView
    CGFloat h=self.view.frame.size.height-48;
    self.tabView=[[UITableView alloc] initWithFrame:CGRectMake(0, 48, self.view.frame.size.width,h)];
    self.tabView.delegate=self;
    self.tabView.dataSource=self;
    [self.tabView setAutoresizesSubviews:YES];
    [self.tabView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view addSubview:self.tabView];
    
    pageSize=10;
    if ([AppHelper isIPad]) {
        pageSize=20;
    }
     helper=[[ServiceHelper alloc] initWithDelegate:self];

}
//查询
-(void)startSearch{
    [self showLoadingAnimated:YES];
    NSString *soapMsg=[MediaSoapMessage DistrictMovieSoap:self.keyWord withCurPage:curPage withCurSize:pageSize];
    [helper AsyServiceMethod:@"CategorySearchMetaData" SoapMessage:soapMsg];
}
#pragma mark -
#pragma mark ServiceHelper delegate Methods
-(void)finishSuccessRequest:(NSString*)xml responseData:(NSData*)requestData{
    NSString *page;
    NSMutableArray *arr=[SearchMetaData XmlToArray:xml withMaxPage:&page];
    maxPage=[page intValue];
    if (isFirstLoad) {//表示第一次加载
        isFirstLoad=NO;
        self.listData=arr;
        [self.tabView reloadData];
    }else{
        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:pageSize];
        for (int i=0; i<[arr count]; i++){
            [self.listData addObject:[arr objectAtIndex:i]];
            NSIndexPath *newPath=[NSIndexPath indexPathForRow:(curPage-1)*pageSize+i inSection:0];
            [insertIndexPaths addObject:newPath];
        }
        //重新呼叫UITableView的方法, 來生成行.
        [self.tabView beginUpdates];
        [self.tabView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tabView endUpdates];
        
    }

    if ([arr count]>0) {
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
#pragma mark -
#pragma mark TableView DataSource delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.listData count]==0) {
        return 0;
    }
    return [self.listData count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellNewsIdentifier = @"CellDistrictIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellNewsIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellNewsIdentifier] autorelease];
    }
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    cell.textLabel.text=@"";
    if (indexPath.row!=[self.listData count]) {
        NSDictionary *dic=[self.listData objectAtIndex:indexPath.row];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        CommonCell *commonCell=[[CommonCell alloc] initWithData:dic withFrame:CGRectMake(0, 0, self.view.frame.size.width-25, 60)];
        [cell.contentView addSubview:commonCell];
        [commonCell release];
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
        if (curPage!=maxPage) {
            cell.textLabel.font=[UIFont boldSystemFontOfSize:20];
            cell.textLabel.text=@"loading more...";
        }else{
            cell.textLabel.text=@"";
        }
        
    }

    return cell;
}
#pragma -
#pragma TableView delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==[self.listData count]) {
        if (curPage==maxPage) {
            return 0;
        }
    }
    return 60;
    /**
     UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
     return cell.frame.size.height;
     **/
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.listData count]!=indexPath.row) {
        selectRow=indexPath.row;
        [self performSegueWithIdentifier:@"DistrictToDetail" sender:self];
        
    }else{
        if (curPage!=maxPage){
            curPage++;
            if (curPage>=maxPage) {
                curPage=maxPage;
            }
            [self startSearch];
        }
    }
    
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
    [tabView release];
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
    self.tabView.allowsSelection=YES;
    self.tabView.scrollEnabled=YES;
    
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
    self.tabView.allowsSelection=NO;
    self.tabView.scrollEnabled=NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.listData removeAllObjects];
    self.KeyWord=searchBar.text;//获取查询条件
    [searchBar resignFirstResponder];
    
    self.tabView.allowsSelection=YES;
    self.tabView.scrollEnabled=YES;
    
    isFirstLoad=YES;
    curPage=1;
    maxPage=1;
    if (!self.hasNetwork) {
        [self showNoNetworkNotice:nil];
        return;
    }
    //开始查询
    [self startSearch];
}
@end
