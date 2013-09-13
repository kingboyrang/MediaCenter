//
//  NewsList.m
//  MediaCenter
//
//  Created by aJia on 13/9/12.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "NewsList.h"
#import "News.h"
#import "NetWorkConnection.h"
#import "SoapXmlParseHelper.h"
#import "MediaSoapMessage.h"
@interface NewsList()
-(void)loadControls;
-(void)loadData;
-(void)loadSourceData;
-(void)updateSourceData:(NSString*)xml;
@end

@implementation NewsList
@synthesize newsType;
@synthesize sourceData=_sourceData;
@synthesize refreshing;
@synthesize scroler;
-(void)dealloc{
    [super dealloc];
    [_sourceData release],_sourceData=nil;
    [_tableView release],_tableView=nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadControls];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
//开始查询
-(void)loadingData{
    if (self.sourceData==nil||[self.sourceData count]==0) {
        govCurPage=0;
        govPageSize=10;
        if ([AppHelper isIPad]) {
            govPageSize=20;
        }
        govMaxPage=1;
        _isFirst=YES;
        //第1次加载执时[下拉加载]
        [_tableView launchRefreshing];//默认加载10笔数据
    }
}
#pragma mark loading data
-(void)updateSourceData:(NSString*)xml{
    NSString *page=nil;
    NSMutableArray *arr=[News XmlToArray:xml withMaxPage:&page];
    if (arr==nil||[arr count]==0) {
        [_tableView tableViewDidFinishedLoadingWithMessage:@"沒有返回數據!"];
        _tableView.reachedTheEnd  = NO;
        govCurPage--;
        return;
    }
    govMaxPage=[page intValue];
    if (_isFirst) {
        _isFirst=NO;
        self.sourceData=[NSMutableArray arrayWithArray:arr];
        [_tableView reloadData];
    }else{
        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
        for (int i=0; i<[arr count]; i++) {
            [self.sourceData addObject:[arr objectAtIndex:i]];
            NSIndexPath *newPath=[NSIndexPath indexPathForRow:(govCurPage-1)*govPageSize+i inSection:0];
            [insertIndexPaths addObject:newPath];
        }
        //重新呼叫UITableView的方法, 來生成行.
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
    }
}
-(void)loadSourceData{
    NSString *soap=[MediaSoapMessage WebNewsByTypeSoap:[NSString stringWithFormat:@"%d",self.newsType] withCurPage:govCurPage withCurSize:govPageSize];
    [_helper AsyServiceMethod:@"GetWebNewsByType" SoapMessage:soap];
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
    if (govCurPage!=govMaxPage) {
        govCurPage++;
        if (govCurPage>=govMaxPage) {
            govCurPage=govMaxPage;
        }
        [self loadSourceData];//加载数据
    }else{
        [_tableView tableViewDidFinishedLoadingWithMessage:@"沒有了哦.."];
        _tableView.reachedTheEnd  = YES;
        
    }
}
#pragma mark ServiceHelperDelegate
-(void)finishSuccessRequest:(NSString*)responseText responseData:(NSData*)requestData{
    [_tableView tableViewDidFinishedLoading];
    _tableView.reachedTheEnd  = NO;
    
    if (self.newsType==1) {//最新活動
    }
   else if(self.newsType==2) {//縣政新聞
    }
   else if(self.newsType==3) {//報乎你知
    }
   else if(self.newsType==4) {//招標公告
    }
   else if(self.newsType==5) {//懲材公告
    }
    if (self.newsType==6) {//最新影音
    }
    [self performSelectorOnMainThread:@selector(updateSourceData:) withObject:responseText waitUntilDone:NO];
    
}
-(void)finishFailRequest:(NSError*)error{
    [_tableView tableViewDidFinishedLoadingWithMessage:@"沒有返回數據!"];
    _tableView.reachedTheEnd  = NO;
    govCurPage--;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sourceData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellNewsIdentifier = @"CellNewsIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellNewsIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellNewsIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    //cell.textLabel.text=@"";
    //cell.detailTextLabel.text=@"";
    NSDictionary *dic=[self.sourceData objectAtIndex:indexPath.row];
    NSString *createDate=[News formatNewsDate:[dic objectForKey:@"Date"]];
    cell.detailTextLabel.text=[AppHelper formatShowDate:createDate];
    cell.textLabel.font=[UIFont boldSystemFontOfSize:17];
    cell.textLabel.text=[dic objectForKey:@"Title"];
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //goToNewsDetail
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.scroler&&[self.scroler respondsToSelector:@selector(selectedNewsType:userinfo:)]) {
        [self.scroler performSelector:@selector(selectedNewsType:userinfo:) withObject:(id)self.newsType withObject:[self.sourceData objectAtIndex:indexPath.row]];
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

#pragma mark private methods
-(void)loadControls{
    if (!_tableView){
      _tableView = [[PullingRefreshTableView alloc] initWithFrame:self.bounds pullingDelegate:self];
      _tableView.backgroundColor=[UIColor clearColor];
      _tableView.dataSource = self;
      _tableView.delegate = self;
      [_tableView setAutoresizesSubviews:YES];
      [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
      [self addSubview:_tableView];
    }
    if (!_helper) {
        _helper=[[ServiceHelper alloc] initWithDelegate:self];
    }
}
@end
