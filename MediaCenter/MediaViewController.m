//
//  MediaViewController.m
//  MediaCenter
//
//  Created by aJia on 12/11/6.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "MediaViewController.h"
#import "MediaSoapMessage.h"
#import "AlterMessage.h"
#import "SearchMetaData.h"
#import "NewMetaData.h"
@interface MediaViewController ()

@end

@implementation MediaViewController
@synthesize sourceData,listData,heightData,KeyWord;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//搜寻
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
-(void)btnDelSearchClick:(id)sender{
    self.tabView.allowsSelection=YES;
    self.tabView.scrollEnabled=YES;
    
    UIBarButtonItem *searchButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(buttonSearchMovie:)];
    self.navigationItem.rightBarButtonItem=searchButton;
    [searchButton release];
    
    [self clearChildsView];
    //重设Title内容
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    customLab.backgroundColor=[UIColor clearColor];
    customLab.textColor=[UIColor whiteColor];
    customLab.font=[UIFont boldSystemFontOfSize:20];
    [customLab setText:currentTitle];
    [customLab sizeToFit];
    self.navigationItem.titleView = customLab;
    [customLab release];
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(revicenotification:) name:@"viewTitle" object:nil];
    self.title=@"最新影音";
    currentTitle=@"最新影音";
    
    curPage=1;
    maxPage=1;
    self.KeyWord=@"";
   
    self.listData=[[NSMutableArray alloc] init];
    self.heightData=[[NSMutableArray alloc] init];
    helper=[[ServiceHelper alloc] initWithDelegate:self];
    isFirstLoad=YES;
    
    if (!self.hasNetwork) {
        [self showNoNetworkNotice:nil];
    }else{
     
     [self defaultLoadData];//第一次加载默认数据
    }
}
//第一次加载默认数据
-(void)defaultLoadData{
     
    
    //NSString *soapMsg=[MediaSoapMessage PublishMetaDataSoap];
    //[helper AsyServiceMethod:@"GetPublishMetaData" SoapMessage:soapMsg];
    [self showLoadingAnimated:YES];
    NSString *soap=[MediaSoapMessage NewMovieSoap:self.KeyWord withCurPage:curPage withCurSize:20];
    [helper AsyServiceMethod:@"CategorySearchMetaData" SoapMessage:soap];
}
//开始加载数据
-(void)startLoadData{
    [self showLoadingAnimated:YES];
    NSString *soapMsg=[MediaSoapMessage SearchMetaDataSoap:self.KeyWord withCurPage:curPage withCurSize:20];
    [helper AsyServiceMethod:@"SearchMetaData" SoapMessage:soapMsg];
}
#pragma mark -
#pragma mark UISearchBar delegate Methods
//添加搜索框事件：
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.tabView.allowsSelection=NO;
    self.tabView.scrollEnabled=NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.sourceData removeAllObjects];
    [self.listData removeAllObjects];
    [self.heightData removeAllObjects];
    
    self.KeyWord=searchBar.text;//获取查询条件
    [searchBar resignFirstResponder];
    
    self.tabView.allowsSelection=YES;
    self.tabView.scrollEnabled=YES;
    
    curPage=1;
    maxPage=1;
    isFirstLoad=YES;
    [self defaultLoadData];//开始加载数据
}
#pragma mark -
#pragma mark serviceHelper delegate Methods 
-(void)finishSuccessRequest:(NSString*)responseText responseData:(NSData*)requestData{
    NSString *xml=[responseText stringByReplacingOccurrencesOfString:@"utf-16" withString:@"utf-8"];
    NSString *page;
    NSMutableArray *arr=[SearchMetaData XmlToArray:xml withMaxPage:&page];
    maxPage=[page intValue];
    if (isFirstLoad) {
        isFirstLoad=NO;
        self.sourceData=arr;
        CGFloat w=self.view.frame.size.width-9*2;
        for (int i=0;i<[arr count];i++) {
            CGRect viewRect=CGRectMake(9, 10, w, 200);
            ShowMetaDataCell *showCell=[[ShowMetaDataCell alloc] initWithData:[arr objectAtIndex:i] withFrame:viewRect];
            showCell.tag=100+i;
            showCell.delegate=self;
            [self.listData addObject:showCell];
            [self.heightData addObject:[NSString stringWithFormat:@"%f",showCell.frame.size.height+10]];
            [showCell release];
        }
        [self.tabView reloadData];
    }else{
        
        CGFloat w=self.view.frame.size.width-9*2;
        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
        for (int i=0; i<[arr count]; i++) {
            CGRect viewRect=CGRectMake(9, 10, w, 200);
            ShowMetaDataCell *showCell=[[ShowMetaDataCell alloc] initWithData:[arr objectAtIndex:i] withFrame:viewRect];
            showCell.tag=100+(curPage-1)*20+i;
            showCell.delegate=self;
            [self.listData addObject:showCell];
            [self.heightData addObject:[NSString stringWithFormat:@"%f",showCell.frame.size.height+10]];
            [showCell release];
            
            [self.sourceData addObject:[arr objectAtIndex:i]];
            NSIndexPath *newPath=[NSIndexPath indexPathForRow:(curPage-1)*10+i+1 inSection:0];
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
#pragma -
#pragma TableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *metaCell=@"metaidentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:metaCell];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:metaCell] autorelease];
    }
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    cell.textLabel.text=@"";
    [cell.contentView addSubview:[self.listData objectAtIndex:indexPath.row]];
    return cell;
}
#pragma -
#pragma TableView delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	//return cell.frame.size.height;
    return [[self.heightData objectAtIndex:indexPath.row] floatValue];
    
    //UIView *v=[cell.contentView.subviews objectAtIndex:0];
    //return v.frame.size.height+5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma -
#pragma ShowMetaDataCell delegate Methods
-(void)ShowMetaDataDetail:(NSSet *)touches withEvent:(UIEvent *)event whichView:(id)which
{
   UITouch *touch=[touches anyObject];
    if (touch.tapCount==1) {
        chooseImg=[which tag]-100;
      [self performSegueWithIdentifier:@"goToHappy" sender:self];//页面跳转
    }
}
//如果还要传值，可以再这处理
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   UIViewController *destination = segue.destinationViewController;
     SEL sel=NSSelectorFromString(@"itemMetaData");
     if ([destination respondsToSelector:sel]) {
         [destination setTitle:[[self.sourceData objectAtIndex:chooseImg] objectForKey:@"C_NAME"]];
         [destination setValue:[self.sourceData objectAtIndex:chooseImg] forKey:@"itemMetaData"];
     }
}
//接收通知
-(void)revicenotification:(NSNotification*)notice{
    NSDictionary *dic=(NSDictionary*)[notice userInfo];
    self.title=[dic objectForKey:@"title"];
    currentTitle=[dic objectForKey:@"title"];
    //[self.navigationItem  setTitle:[dic objectForKey:@"title"]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
    [_tabView release];
    [sourceData release];
    [listData release];
    [heightData release];
    [KeyWord release];
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
@end
