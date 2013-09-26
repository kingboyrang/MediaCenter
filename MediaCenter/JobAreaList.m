//
//  JobAreaList.m
//  MediaCenter
//
//  Created by aJia on 13/9/25.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "JobAreaList.h"
#import "NetWorkConnection.h"
#import "MediaSoapMessage.h"
#import "GDataXMLNode.h"
#import "SoapXmlParseHelper.h"
@interface JobAreaList()
-(void)loadControls;
- (void)loadData;
-(void)loadSourceData;
-(void)updateSourceData:(NSString*)xml;
-(NSMutableArray*)XmlToArray:(NSString*)xml nodeName:(NSString*)searchName withMaxPage:(NSString**)page;
@end
@implementation JobAreaList
@synthesize sourceData=_sourceData;
@synthesize jobType;
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
        self.jobType=1;
        self.backgroundColor=[UIColor clearColor];
        [self loadControls];
    }
    return self;
}
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
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellNewsIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dic=[self.sourceData objectAtIndex:indexPath.row];
    NSString *leftName=self.jobType==1?@"JobName":@"Name";
    NSString *rightName=self.jobType==1?@"WorkAddress":@"Category";
    
    NSString *labShow=[dic objectForKey:leftName];
    if (self.jobType==2) {
        labShow=[NSString stringWithFormat:@"%@\n日期:%@",labShow,[dic objectForKey:@"Date"]];
    }
   
    cell.detailTextLabel.text=[dic objectForKey:rightName];
    cell.textLabel.font=[UIFont boldSystemFontOfSize:17];
    cell.textLabel.text=labShow;
    if (self.jobType==2) {
        cell.textLabel.numberOfLines=0;
        cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    }
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //goToNewsDetail
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.scroler&&[self.scroler respondsToSelector:@selector(selectedJobDetail:)]) {
        NSDictionary *dic=[self.sourceData objectAtIndex:indexPath.row];
        [self.scroler performSelector:@selector(selectedJobDetail:) withObject:[dic objectForKey:@"PK"]];
    }
    
}
#pragma mark ServiceHelperDelegate
-(void)finishSuccessRequest:(NSString*)responseText responseData:(NSData*)requestData{
    [_tableView tableViewDidFinishedLoading];
    _tableView.reachedTheEnd  = NO;
    [self performSelectorOnMainThread:@selector(updateSourceData:) withObject:responseText waitUntilDone:NO];
    
}
-(void)finishFailRequest:(NSError*)error{
    [_tableView tableViewDidFinishedLoadingWithMessage:@"沒有返回數據!"];
    _tableView.reachedTheEnd  = NO;
    govCurPage--;
}
#pragma mark loading data
-(void)updateSourceData:(NSString*)xml{
    NSString *page=nil;
    NSString *searchName=self.jobType==1?@"Recruiters":@"Activity";
    NSMutableArray *arr=[self XmlToArray:xml nodeName:searchName withMaxPage:&page];
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
    if (self.jobType==1) {
        NSString *soap=[MediaSoapMessage GetRecruitersListSoapMesage:govCurPage withCurSize:govPageSize];
        [_helper AsyServiceMethod:@"GetRecruitersList" SoapMessage:soap];
    }else{
        NSString *soap=[MediaSoapMessage GetActivityListSoapMesage:govCurPage withCurSize:govPageSize];
        [_helper AsyServiceMethod:@"GetActivityList" SoapMessage:soap];
    
    }
    
}
- (void)loadData{
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
-(NSMutableArray*)XmlToArray:(NSString*)xml nodeName:(NSString*)searchName withMaxPage:(NSString**)page{
    NSMutableArray *array=[NSMutableArray array];
    NSError *error=nil;
    GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
    if (error) {
        [document release];
        *page=@"1";
        return array;
    }
    
    GDataXMLElement* rootNode = [document rootElement];
    NSArray *rootChilds=[rootNode children];
    for (GDataXMLNode *node in rootChilds){
        NSArray *arr=[node children];
        if ([arr count]>0) {
            for (GDataXMLNode *xmlnode in arr) {
                if ([xmlnode.name isEqualToString:@"Pager"]) {
                    //取得最大页数
                    
                    NSArray *pageArr=[xmlnode children];
                    for (GDataXMLNode *p in pageArr) {
                        if ([p.name isEqualToString:@"PageCount"]) {
                            *page=[p stringValue];
                            break;
                        }
                    }
                    
                }
            }
            
            
            //取得资料
            GDataXMLNode *newNode=[arr objectAtIndex:0];
            NSArray *childs=[newNode children];
            for (GDataXMLNode *item in childs) {
                if ([item.name isEqualToString:searchName]) {
                    [array addObject:[SoapXmlParseHelper ChildsNodeDictionary:item]];
                }
            }
        }
    }
    [document release];
    if (*page==nil) {
        *page=@"1";
    }
    return array;
}
@end
