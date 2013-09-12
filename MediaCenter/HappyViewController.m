//
//  HappyViewController.m
//  MediaCenter
//
//  Created by rang on 12-11-20.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "HappyViewController.h"
#import "MediaSoapMessage.h"
#import "SoapXmlParseHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "AlterMessage.h"
#import "CommonCell.h"
#import "SearchMetaData.h"
@interface HappyViewController ()

@end

@implementation HappyViewController
@synthesize listData,CategoryCode;
@synthesize KeyWord,tabView;
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
    
    isFirstLoad=YES;
    self.listData=[[NSMutableArray alloc] init];
    curPage=1;
    maxPage=1;
    commonPageSize=10;
    if ([AppHelper isIPad]){
      commonPageSize=20;
    }
    self.KeyWord=@"";
    
    
    if (!self.hasNetwork) {
        [self showNoNetworkNotice:nil];
    }else{
      
       [self startSearch];//开始查询
    }
	// Do any additional setup after loading the view.
}
//开始查询
-(void)startSearch{
    if (!self.hasNetwork) {
        [self showNoNetworkNotice:nil];
        return;
    }
    [self showLoadingAnimated:YES];
    NSString *soap=[MediaSoapMessage HappyElandSoap:self.KeyWord classCode:self.CategoryCode withCurPage:curPage withCurSize:commonPageSize];
    [helper AsyServiceMethod:@"CategorySearchMetaData" SoapMessage:soap];

}
#pragma -
#pragma serviceHelper delegate Methods
-(void)finishSuccessRequest:(NSString*)responseText responseData:(NSData*)requestData{
    NSString *xml=[responseText stringByReplacingOccurrencesOfString:@"utf-16" withString:@"utf-8"];
    NSString *page;
    NSMutableArray *arr=[SearchMetaData XmlToArray:xml withMaxPage:&page];
    maxPage=[page intValue];
    if (isFirstLoad) {
        isFirstLoad=NO;
        self.listData=arr;
        [self.tabView reloadData];
    }else{
        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:commonPageSize];
        for (int i=0; i<[arr count]; i++) {
             [self.listData addObject:[arr objectAtIndex:i]];
            NSIndexPath *newPath=[NSIndexPath indexPathForRow:(curPage-1)*commonPageSize+i inSection:0];
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
//下一页传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    SEL sel=NSSelectorFromString(@"itemMetaData");
    if ([destination respondsToSelector:sel]) {
        [destination setTitle:[[self.listData objectAtIndex:selectRow] objectForKey:@"C_NAME"]];
        //传值
        [destination setValue:[self.listData objectAtIndex:selectRow] forKey:@"itemMetaData"];
    }
}
#pragma -
#pragma TableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.listData count]==0) {
        return 0;
    }
    return [self.listData count]+1;
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
    if (indexPath.row!=[self.listData count]) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary *dic=[self.listData objectAtIndex:indexPath.row];
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
    
    
    //UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	//return cell.frame.size.height;
    if (indexPath.row==[self.listData count]) {
        if (curPage==maxPage&&maxPage>1) {
            return 0;
        }
    }
    return 60;
    //[[self.heightData objectAtIndex:indexPath.row] floatValue];
  
    //UIView *v=[cell.contentView.subviews objectAtIndex:0];
    //return v.frame.size.height+5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row!=[self.listData count]) {
        selectRow=indexPath.row;
        [self performSegueWithIdentifier:@"goToHappyDetail" sender:self];
    }else{
        if (curPage!=maxPage) {
            curPage++;
            if (curPage>=maxPage) {
                curPage=maxPage;
            }
            [self startSearch];//开始加载
        }
    }
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [tabView release];
    [super dealloc];
    [helper release];
    [listData release];
    [KeyWord release];
    [CategoryCode release];
}
//搜寻
- (IBAction)buttonSearchClick:(id)sender {
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
    self.tabView.allowsSelection=YES;
    self.tabView.scrollEnabled=YES;
    
    UIBarButtonItem *searchButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(buttonSearchMovie:)];
    self.navigationItem.rightBarButtonItem=searchButton;
    [searchButton release];
    
    [self clearChildsView];
    //重设Title内容
    [self.navigationItem titleViewBackground];
    /**
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    customLab.backgroundColor=[UIColor clearColor];
    customLab.textColor=[UIColor whiteColor];
    customLab.font=[UIFont boldSystemFontOfSize:20];
    [customLab setText:@"幸福宜蘭"];
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
    [self startSearch];//开始加载数据
}
@end
