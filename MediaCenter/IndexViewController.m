//
//  IndexViewController.m
//  MediaCenter
//
//  Created by aJia on 12/12/1.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "IndexViewController.h"
#import "CommonCell.h"
#import "ServiceHelper.h"

#import "SoapXmlParseHelper.h"
#import "MediaSoapMessage.h"
#import "SearchMetaData.h"
#import "HotMetaData.h"
#import "AlterMessage.h"
#import "OrgenMovieMetaData.h"
@interface IndexViewController ()

@end

@implementation IndexViewController
@synthesize orginTableView,hotTableView,movieTableView;
@synthesize orginListData,hotListData,movieListData;
@synthesize KeyWord;
@synthesize typeListData,typeTableView;
@synthesize httpRequest;
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
    
   
    //默认选中最新影音
    //self.SegmentSwitch.selectedSegmentIndex=0;
    //定义TableView
     CGRect tabRect=CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44);
    

    //机关类别
    self.orginTableView=[[UITableView alloc] initWithFrame:tabRect];
    self.orginTableView.delegate=self;
    self.orginTableView.dataSource=self;
    [self.orginTableView setAutoresizesSubviews:YES];
    [self.orginTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view addSubview:self.orginTableView];
    self.orginTableView.hidden=YES;
    self.orginListData=[NSMutableArray array];
    
    //热们影音
    self.hotTableView=[[UITableView alloc] initWithFrame:tabRect];
    self.hotTableView.delegate=self;
    self.hotTableView.dataSource=self;
    [self.hotTableView setAutoresizesSubviews:YES];
    [self.hotTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view addSubview:self.hotTableView];
     self.hotTableView.hidden=YES;
    self.hotListData=[NSMutableArray array];
    //最新影音
    self.movieTableView=[[UITableView alloc] initWithFrame:tabRect];
    self.movieTableView.delegate=self;
    self.movieTableView.dataSource=self;
    [self.movieTableView setAutoresizesSubviews:YES];
    [self.movieTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
     [self.view addSubview:self.movieTableView];   
     self.movieTableView.hidden=YES;
     self.movieListData=[NSMutableArray array];

    //幸福宜蘭
    self.typeTableView=[[UITableView alloc] initWithFrame:tabRect];
    self.typeTableView.dataSource=self;
    self.typeTableView.delegate=self;
    [self.typeTableView setAutoresizesSubviews:YES];
    [self.typeTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    //self.typeTableView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.typeTableView];
    
        
  
    
    //self.hotTableView.hidden=NO;
    [self.view bringSubviewToFront:self.typeTableView];
    
    //初始化保存的数据
    
    
    
    //机关类别
    isorginFirst=YES;//点击机关类别标签是否为第一次加载 
    //热门影音
     hotCurPage=1;
     hotMaxPage=1;
    isFirstLoadHot=YES;
    ishotFirst=YES;//点击热门影音标签是否为第一次加载 
    //最新影音
    self.KeyWord=@"";
    curPage=1;
    maxPage=1;
    isFirst=YES;
    //第一次默认加载最新影音信息
    commonPageSize=10;
    if ([AppHelper isIPad]) {
        commonPageSize=20;
    }
   
    if (!self.hasNetwork) {
        [self showNoNetworkNotice:nil];
    }else{
      NSString *soapHappyMsg=[MediaSoapMessage CategoryListSoap];
      [self loadMovieData:@"GetCategoryList" SoapMessage:soapHappyMsg RequestName:@"happyType"];
    }    
	// Do any additional setup after loading the view.
}

//加载数据
-(void)loadMovieData:(NSString*)methodName SoapMessage:(NSString*)soap RequestName:(NSString*)name{
    [self showLoadingAnimated:YES];
    [self.httpRequest setDelegate:nil];
    [self.httpRequest cancel];
    [self setHttpRequest:[ServiceHelper SharedRequestMethod:methodName SoapMessage:soap]];
    //ASIHTTPRequest *request=[ServiceHelper SharedRequestMethod:methodName SoapMessage:soap];
    [self.httpRequest setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:name,@"name", nil]];
    [self.httpRequest setTimeOutSeconds:20.0];
    [self.httpRequest setDelegate:self];
    [self.httpRequest startAsynchronous];
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
#pragma mark -
#pragma mark UISearchBar delegate Methods
//添加搜索框事件：
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.movieTableView.allowsSelection=NO;
    self.movieTableView.scrollEnabled=NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
   self.SegmentSwitch.selectedSegmentIndex=3;//选中最新影音
    [self switchSegmentShow:3];
    [self.movieListData removeAllObjects];
    
    
    self.KeyWord=searchBar.text;//获取查询条件
    [searchBar resignFirstResponder];
    
    self.movieTableView.allowsSelection=YES;
    self.movieTableView.scrollEnabled=YES;
    
    isFirst=YES;
    curPage=1;
    maxPage=1;
    //开始查询
    NSString *soap=[MediaSoapMessage NewMovieSoap:self.KeyWord withCurPage:curPage withCurSize:commonPageSize];
    [self loadMovieData:@"CategorySearchMetaData" SoapMessage:soap RequestName:@"newMovie"];
    //[self startSearch];//开始加载数据
}
#pragma mark -
#pragma mark ASIHTTPRequest delegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self hideLoadingViewAnimated:YES];
    int statusCode = [request responseStatusCode];
    if (statusCode==404) {
        [self showErrorNoticeWithTitle:@"服務連接不可用" message:@"沒有返回數據!" dismiss:nil];
    }
	NSString *soapAction=[[request requestHeaders] objectForKey:@"SOAPAction"];
    
    NSString *methodName=@"";
    NSRange range = [soapAction  rangeOfString:@"/" options:NSBackwardsSearch];
    if(range.location!=NSNotFound){
        int pos=range.location;
        methodName=[soapAction stringByReplacingCharactersInRange:NSMakeRange(0, pos+1) withString:@""];
    }
	// Use when fetching text data
	NSString *responseString = [request responseString];
	NSString *result=@"";
    if (statusCode==200) {//表示正常请求
        result=[SoapXmlParseHelper SoapMessageResultXml:responseString ServiceMethodName:methodName];
    }
    NSString *requestName=[[request userInfo] objectForKey:@"name"];
    
    if ([requestName isEqualToString:@"newMovie"]) {//最新影音
        [self handlerNewMovie:result];
        
    }
    if ([requestName isEqualToString:@"hotMoive"]) {//热门影音
        [self handlerHotMovie:result];
         //[HUD hide:YES];
    }
    if ([requestName isEqualToString:@"orgin"]) {
        self.orginListData=[SoapXmlParseHelper SearchNodeToArray:result NodeName:@"Department"];
        [self.orginTableView reloadData];
        //[HUD hide:YES];
    }
    if ([requestName isEqualToString:@"happyType"]) {//幸福宜蘭
        [self handlerHapplyMovie:result];
    }
    if(statusCode!=404&&[result length]==0){
       [self showErrorNoticeWithTitle:@"請求完成" message:@"沒有返回數據!" dismiss:nil];
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingViewAnimated:YES completed:^(AnimateLoadView *hideView) {
        [hideView.activityIndicatorView stopAnimating];
        [self showErrorNoticeWithTitle:@"沒有返回數據" message:@"加載失敗!" dismiss:nil];
    }];
}
//幸福宜蘭
-(void)handlerHapplyMovie:(NSString*)xml{

    
    NSMutableArray *arr=[SoapXmlParseHelper SearchNodeToArray:xml NodeName:@"Categroy"];
    self.typeListData=arr;
    //NSLog(@"source=%@\n",self.typeTableView.dataSource);
    [self.typeTableView reloadData];
    /***
    if (!self.typeListData) {
        self.typeListData=[NSMutableArray array];
    }
    
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:[arr count]];
    for (int i=0; i<[arr count]; i++){
        [self.typeListData addObject:[arr objectAtIndex:i]];
        NSIndexPath *newPath=[NSIndexPath indexPathForRow:i inSection:0];
        [insertIndexPaths addObject:newPath];
    }
    //重新呼叫UITableView的方法, 來生成行.
    [self.typeTableView beginUpdates];
    [self.typeTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.typeTableView endUpdates];
  ***/


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
}
//热门影音
-(void)handlerHotMovie:(NSString*)xml{
    NSString *page=nil;
    NSMutableArray *arr=[SearchMetaData XmlToArray:xml withMaxPage:&page];
    if (page!=nil) {
        hotMaxPage=[page intValue];
    }
    if (isFirstLoadHot) {
        isFirstLoadHot=NO;
        self.hotListData=arr;
        [self.hotTableView reloadData];
    }else{
        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:commonPageSize];
        for (int i=0; i<[arr count]; i++) {
            [self.hotListData addObject:[arr objectAtIndex:i]];
            NSIndexPath *newPath=[NSIndexPath indexPathForRow:(hotCurPage-1)*commonPageSize+i inSection:0];
            [insertIndexPaths addObject:newPath];
        }
        //重新呼叫UITableView的方法, 來生成行.
        [self.hotTableView beginUpdates];
        [self.hotTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.hotTableView endUpdates];
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [httpRequest setDelegate:nil];
    [httpRequest cancel];
    [httpRequest release];
    [_SegmentSwitch release];
    [orginTableView release];
    [hotTableView release];
    [movieTableView release];
    [orginListData release];
    [hotListData release];
    [movieListData release];
    [KeyWord release];
    [typeListData release];
    [typeTableView release];
    [super dealloc];
}
//标签功能显示
- (IBAction)SegmentSwitchView:(id)sender {
    UISegmentedControl *segment=(UISegmentedControl*)sender;
    int index=segment.selectedSegmentIndex;
    [self switchSegmentShow:index];
}
//切换不同的标签
-(void)switchSegmentShow:(int)index{
    if (index==0) {//幸福宜蘭
        if ([self.typeListData count]==0) {
            if (!self.hasNetwork) {
                [self showNoNetworkNotice:nil];
            }else{
             
           NSString *soapHappyMsg=[MediaSoapMessage CategoryListSoap];
            [self loadMovieData:@"GetCategoryList" SoapMessage:soapHappyMsg RequestName:@"happyType"];
            }
        }
        self.typeTableView.hidden=NO;
        [self.view bringSubviewToFront:self.typeTableView];
        self.orginTableView.hidden=YES;
        [self.view sendSubviewToBack:self.orginTableView];
        self.hotTableView.hidden=YES;
        [self.view sendSubviewToBack:self.hotTableView];
        self.movieTableView.hidden=YES;
        [self.view sendSubviewToBack:self.movieTableView];
    }else if(index==1){//机关类别
        if (isorginFirst||[self.orginListData count]==0) {
            isorginFirst=NO;
            if (!self.hasNetwork) {
                [self showNoNetworkNotice:nil];
            }else{
            
            NSString *soapMsg=[MediaSoapMessage OrgenTypeSoap];
            [self loadMovieData:@"GetFirstDeptList" SoapMessage:soapMsg RequestName:@"orgin"];
            }
        }
        self.orginTableView.hidden=NO;
        [self.view bringSubviewToFront:self.orginTableView];
        self.movieTableView.hidden=YES;
        [self.view sendSubviewToBack:self.movieTableView];
        self.hotTableView.hidden=YES;
        [self.view sendSubviewToBack:self.hotTableView];
        self.typeTableView.hidden=YES;
        [self.view sendSubviewToBack:self.typeTableView];
    }else if(index==2){//热门影音
        if (ishotFirst||[self.hotListData count]==0) {
            ishotFirst=NO;
            if (!self.hasNetwork) {
                [self showNoNetworkNotice:nil];
            }else{
           
            NSString *soap=[MediaSoapMessage HotMovieSoap:@"" withCurPage:1 withCurSize:commonPageSize];
            [self loadMovieData:@"CategorySearchMetaData" SoapMessage:soap RequestName:@"hotMoive"];
            }
        }
        self.hotTableView.hidden=NO;
        [self.view bringSubviewToFront:self.hotTableView];
        self.typeTableView.hidden=YES;
        [self.view sendSubviewToBack:self.typeTableView];
        self.orginTableView.hidden=YES;
        [self.view sendSubviewToBack:self.orginTableView];
        self.movieTableView.hidden=YES;
        [self.view sendSubviewToBack:self.movieTableView];
    }else{//最新影音
        if ([self.movieListData count]==0||isFirst) {
            isFirst=NO;
            self.KeyWord=@"";
            curPage=1;
            maxPage=1;
            isFirst=YES;
            //第一次默认加载最新影音信息
           
            commonPageSize=10;
            if ([AppHelper isIPad]) {
                commonPageSize=20;
            }
            if (!self.hasNetwork) {
                [self showNoNetworkNotice:nil];
            }else{
            NSString *soap=[MediaSoapMessage NewMovieSoap:self.KeyWord withCurPage:curPage withCurSize:commonPageSize];
            [self loadMovieData:@"CategorySearchMetaData" SoapMessage:soap RequestName:@"newMovie"];
            }
        }
        
        self.movieTableView.hidden=NO;
        [self.view bringSubviewToFront:self.movieTableView];
        self.hotTableView.hidden=YES;
        [self.view sendSubviewToBack:self.hotTableView];
        self.typeTableView.hidden=YES;
        [self.view sendSubviewToBack:self.typeTableView];
        self.orginTableView.hidden=YES;
        [self.view sendSubviewToBack:self.orginTableView];
    }

}
#pragma mark -
#pragma mark TableView DataSource deletate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.orginTableView) {//机关类别
        return [self.orginListData count];
    }
    if(tableView==self.hotTableView){//熱門影音
        if ([self.hotListData count]==0) {
            return 0;
        }
        return [self.hotListData count]+1;
    }
    if (tableView==self.movieTableView) {//最新影音
        if ([self.movieListData count]==0) {
            return 0;
        }
        return [self.movieListData count]+1;
    }
    if (tableView==self.typeTableView) {//幸福宜蓝
        return [self.typeListData count];
    }
    return 0;
   
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"cellMovieIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        if (tableView==self.orginTableView||tableView==self.typeTableView) {//UITableViewCellStyleValue1
            cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
        }else{
          cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
    }
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    cell.textLabel.text=@"";
    cell.detailTextLabel.text=@"";
    if (tableView==self.typeTableView) {//幸福宜蘭
        NSDictionary *happydic=[self.typeListData objectAtIndex:indexPath.row];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text=[happydic objectForKey:@"NAME"];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"影片數量:%@",[happydic objectForKey:@"MetaCount"]];
    }
    if (tableView==self.orginTableView) {//机关类别
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            NSDictionary *organDic=[self.orginListData objectAtIndex:indexPath.row];
            cell.textLabel.text=[organDic objectForKey:@"DEPT_NAME"];
            cell.detailTextLabel.text=[NSString stringWithFormat:@"影片數量:%@",[organDic objectForKey:@"MetaCount"]];

    }
    
    if (tableView==self.hotTableView) {//热们影音
        if (indexPath.row!=[self.hotListData count]) {
             NSDictionary *hotdic=[self.hotListData objectAtIndex:indexPath.row];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            OrgenMovieMetaData *commonCell=[[OrgenMovieMetaData alloc] initWithData:hotdic withFrame:CGRectMake(0, 0, self.view.frame.size.width-25, 78)];
            [cell.contentView addSubview:commonCell];
            [commonCell release];
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
            if (hotCurPage!=hotMaxPage) {
                cell.textLabel.font=[UIFont boldSystemFontOfSize:20];
                cell.textLabel.text=@"loading more...";
            }else{
                cell.textLabel.text=@"";
            }

        }
    }
    
    if (tableView==self.movieTableView) {//最新影音
        if(indexPath.row!=[self.movieListData count]){
          NSDictionary  *dic=[self.movieListData objectAtIndex:indexPath.row];
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
    }
    return cell;
}
#pragma -
#pragma TableView delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView==self.hotTableView){//热们影音
        if (indexPath.row==[self.hotListData count]) {
            if (hotCurPage==maxPage) {
                return 0;
            }
        }
        return 78;
    }
    
    if(tableView==self.movieTableView){//最新影音
        if (indexPath.row==[self.movieListData count]) {
            if (curPage==maxPage) {
                return 0;
            }
        }
        return 60;
    }
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.typeTableView==tableView) {//幸福宜蘭
        segmentSelect=0;//表示幸福宜蘭跳转
        selectRow=indexPath.row;
        [self performSegueWithIdentifier:@"indexGoToHappy" sender:self];
        return;
    }
    if (self.orginTableView==tableView) {//机关类别
        selectRow=indexPath.row;
        segmentSelect=1;//表示机关类别跳转
        [self performSegueWithIdentifier:@"indexToOrgin" sender:self];
        return;
    }
    if (self.hotTableView==tableView) {//热们影音
        if (indexPath.row!=[self.hotListData count]) {
            segmentSelect=2;//表示热们影音跳转
            selectRow=indexPath.row;
            [self performSegueWithIdentifier:@"indexToDetail" sender:self];
            return;
        }else{
            if(hotCurPage!=hotMaxPage){
                hotCurPage++;
                if (hotCurPage>=hotMaxPage) {
                    hotCurPage=hotMaxPage;
                }
                NSString *soap=[MediaSoapMessage HotMovieSoap:@"" withCurPage:hotCurPage withCurSize:commonPageSize];
                [self loadMovieData:@"CategorySearchMetaData" SoapMessage:soap RequestName:@"hotMoive"];
                return;
            }
        }
    }
    
    if (self.movieTableView==tableView) {//最新影音
        if(indexPath.row!=[self.movieListData count]){
           segmentSelect=3;//表示最新影音跳转
           selectRow=indexPath.row;
            [self performSegueWithIdentifier:@"indexToDetail" sender:self];
            return;
        }else{
            if (curPage!=maxPage) {
                curPage++;
                if (curPage>=maxPage) {
                    curPage=maxPage;
                }
                NSString *soap=[MediaSoapMessage NewMovieSoap:self.KeyWord withCurPage:curPage withCurSize:commonPageSize];
                [self loadMovieData:@"CategorySearchMetaData" SoapMessage:soap RequestName:@"newMovie"];
                return;
                
            }
        }
    }
    
}
//如果还要传值，可以再这处理
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if (segmentSelect==0) {//幸福宜蘭
        SEL sel=NSSelectorFromString(@"CategoryCode");
        if ([destination respondsToSelector:sel]) {
            NSDictionary *dic=[self.typeListData objectAtIndex:selectRow];
            [destination setValue:[dic objectForKey:@"CODE"] forKey:@"CategoryCode"];
        }
    }else if(segmentSelect==1){//机关类别
        SEL sel=NSSelectorFromString(@"ItemData");
        if ([destination respondsToSelector:sel]) {
            [destination setTitle:[[self.orginListData objectAtIndex:selectRow] objectForKey:@"DEPT_NAME"]];
            [destination setValue:[self.orginListData objectAtIndex:selectRow] forKey:@"ItemData"];
        }
    }else if(segmentSelect==2){//热们影音
        SEL sel=NSSelectorFromString(@"itemMetaData");
        if ([destination respondsToSelector:sel]) {
            NSDictionary *dic=[self.hotListData objectAtIndex:selectRow];
            [destination setTitle:[dic objectForKey:@"C_NAME"]];
            //传值
            [destination setValue:dic forKey:@"itemMetaData"];
        }
    }else{//最新影音
        SEL sel=NSSelectorFromString(@"itemMetaData");
        if ([destination respondsToSelector:sel]) {
            NSDictionary *dic=[self.movieListData objectAtIndex:selectRow];
            [destination setTitle:[dic objectForKey:@"C_NAME"]];
            [destination setValue:dic forKey:@"itemMetaData"];
        }
    }
}
@end
