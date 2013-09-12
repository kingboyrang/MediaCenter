//
//  IndexViewController.m
//  MediaCenter
//
//  Created by aJia on 12/12/1.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "NewMovieViewController.h"
#import "CommonCell.h"
#import "SoapXmlParseHelper.h"
#import "MediaSoapMessage.h"
#import "SearchMetaData.h"
#import "AlterMessage.h"
#import "NetWorkConnection.h"
@interface NewMovieViewController ()

@end

@implementation NewMovieViewController
@synthesize movieTableView,movieListData;
@synthesize KeyWord;
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
    
    helper=[[ServiceHelper alloc] initWithDelegate:self];
    //定义TableView
     CGRect tabRect=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.movieTableView=[[UITableView alloc] initWithFrame:tabRect];
    self.movieTableView.delegate=self;
    self.movieTableView.dataSource=self;
    [self.movieTableView setAutoresizesSubviews:YES];
    [self.movieTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view addSubview:self.movieTableView];
    
    //初始化保存的数据
    self.movieListData=[NSMutableArray array];
    //最新影音
    self.KeyWord=@"";
    curPage=1;
    maxPage=1;
    isFirst=YES;
    commonPageSize=10;
    if ([AppHelper isIPad]) {
        commonPageSize=20;
    }
   
    //第一次默认加载最新影音信息
    if (!self.hasNetwork) {
        [self showNoNetworkNotice:nil];
    }else{
    
    [self startSearch];
    }
    
	// Do any additional setup after loading the view.
}
//开始加载数据
-(void)startSearch{
    if (!self.hasNetwork) {
        [self showNoNetworkNotice:nil];
        return;
    }
    [self showLoadingAnimated:YES];
    NSString *soap=[MediaSoapMessage NewMovieSoap:self.KeyWord withCurPage:curPage withCurSize:commonPageSize];
    [helper AsyServiceMethod:@"CategorySearchMetaData" SoapMessage:soap];
}
#pragma mark -
#pragma mark  搜寻部分
//点击查询时出现查询框
- (IBAction)btnSearchclick:(id)sender {
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
-(void)btnDelSearchClick:(id)sender{
    self.movieTableView.allowsSelection=YES;
    self.movieTableView.scrollEnabled=YES;
    
    UIBarButtonItem *searchButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(buttonSearchMovie:)];
    self.navigationItem.rightBarButtonItem=searchButton;
    [searchButton release];
    
    [self clearChildsView];
    //重设Title内容
    [self.navigationItem titleViewBackground];
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
#pragma mark -
#pragma mark UISearchBar delegate Methods
//添加搜索框事件：
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.movieTableView.allowsSelection=NO;
    self.movieTableView.scrollEnabled=NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.movieListData removeAllObjects];
    self.KeyWord=searchBar.text;//获取查询条件
    [searchBar resignFirstResponder];
    
    self.movieTableView.allowsSelection=YES;
    self.movieTableView.scrollEnabled=YES;
    
    isFirst=YES;
    curPage=1;
    maxPage=1;
    //开始查询
    
    [self startSearch];
}
#pragma mark -
#pragma mark ASIHTTPRequest delegate Methods
-(void)finishSuccessRequest:(NSString*)responseText responseData:(NSData*)requestData{
    [self handlerNewMovie:responseText];
    
}
-(void)finishFailRequest:(NSError*)error{
    [self hideLoadingViewAnimated:YES completed:^(AnimateLoadView *hideView) {
        [hideView.activityIndicatorView stopAnimating];
        [self showErrorNoticeWithTitle:@"沒有返回數據" message:@"加載失敗!" dismiss:nil];
    }];
}
//最新影音
-(void)handlerNewMovie:(NSString*)xml{
    NSString *page;
    NSMutableArray *arr=[SearchMetaData XmlToArray:xml withMaxPage:&page];
    maxPage=[page intValue];
    if (isFirst) {//表示第一次加载
        isFirst=NO;
        self.movieListData=arr;
        [self.movieTableView reloadData];
    }else{
        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:commonPageSize];
        for (int i=0; i<[arr count]; i++){
            [self.movieListData addObject:[arr objectAtIndex:i]];
            NSIndexPath *newPath=[NSIndexPath indexPathForRow:(curPage-1)*commonPageSize+i inSection:0];
            [insertIndexPaths addObject:newPath];
        }
        //重新呼叫UITableView的方法, 來生成行.
        //[self.movieTableView beginUpdates];
        [self.movieTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        //[self.movieTableView endUpdates];
        
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
   
    [movieTableView release];
    [movieListData release];
    [KeyWord release];
    [super dealloc];
}


#pragma mark -
#pragma mark TableView DataSource deletate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.movieListData count]==0) {//最新影音
        return 0;
    }
    return [self.movieListData count]+1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"cellMovieIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    cell.textLabel.text=@"";
    if (indexPath.row!=[self.movieListData count]) {
        NSDictionary *dic=[self.movieListData objectAtIndex:indexPath.row];
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
    if (tableView==self.movieTableView&&indexPath.row==[self.movieListData count]) {
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
    if ([self.movieListData count]!=indexPath.row) {
        selectRow=indexPath.row;
        [self performSegueWithIdentifier:@"NewMovieToDetail" sender:self];
        
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
        NSDictionary *dic=[self.movieListData objectAtIndex:selectRow];
        [destination setTitle:[dic objectForKey:@"C_NAME"]];
        [destination setValue:dic forKey:@"itemMetaData"];
    }
}
@end
