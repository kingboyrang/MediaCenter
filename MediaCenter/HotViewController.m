//
//  HotViewController.m
//  MediaCenter
//
//  Created by aJia on 12/11/22.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "HotViewController.h"
#import "AlterMessage.h"
#import "MediaSoapMessage.h"
#import "HotMetaData.h"
#import "SearchMetaData.h"
#import "CommonCell.h"
#import "OrgenMovieMetaData.h"
@interface HotViewController ()

@end

@implementation HotViewController
@synthesize listData;
@synthesize KeyWord;
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
    
    helper=[[ServiceHelper alloc] initWithDelegate:self];
    self.listData=[NSMutableArray array];
    
    isFirstLoadHot=YES;
    hotCurPage=1;
    hotMaxPage=1;
    hotPageSize=10;
    if ([AppHelper isIPad]) {
        hotPageSize=20;
    }
    self.KeyWord=@"";
    if (!self.hasNetwork) {
        [self showNoNetworkNotice:nil];
    }else{
     
     [self startSearch];//开始加载数据
    }
}
//开始查询
-(void)startSearch{
    [self showLoadingAnimated:YES];
    NSString *soap=[MediaSoapMessage HotMovieSoap:self.KeyWord withCurPage:hotCurPage withCurSize:hotPageSize];
    [helper AsyServiceMethod:@"CategorySearchMetaData" SoapMessage:soap];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnSearchClick:(id)sender {
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
    self.tableView.allowsSelection=YES;
    self.tableView.scrollEnabled=YES;
    
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
    self.tableView.allowsSelection=NO;
    self.tableView.scrollEnabled=NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.listData removeAllObjects];
    
    self.KeyWord=searchBar.text;//获取查询条件
    [searchBar resignFirstResponder];
    
    self.tableView.allowsSelection=YES;
    self.tableView.scrollEnabled=YES;
    
    hotCurPage=1;
    hotMaxPage=1;
    isFirstLoadHot=YES;
    [self startSearch];//开始加载数据
}
//下一页传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    SEL sel=NSSelectorFromString(@"itemMetaData");
    if ([destination respondsToSelector:sel]) {
        NSDictionary *dic=[self.listData objectAtIndex:selectRow];
        [destination setTitle:[dic objectForKey:@"C_NAME"]];
        //传值
        [destination setValue:dic forKey:@"itemMetaData"];
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
        self.listData=arr;
        [self.tableView reloadData];
    }else{
        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:hotPageSize];
        for (int i=0; i<[arr count]; i++) {
            [self.listData addObject:[arr objectAtIndex:i]];
            NSIndexPath *newPath=[NSIndexPath indexPathForRow:(hotCurPage-1)*hotPageSize+i inSection:0];
            [insertIndexPaths addObject:newPath];
        }
        //重新呼叫UITableView的方法, 來生成行.
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
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
#pragma mark -
#pragma mark ServiceHelper delegate Methods
-(void)finishSuccessRequest:(NSString*)responseText responseData:(NSData*)requestData{
    [self handlerHotMovie:responseText];
}
-(void)finishFailRequest:(NSError*)error{
    [self hideLoadingViewAnimated:YES completed:^(AnimateLoadView *hideView) {
        [hideView.activityIndicatorView stopAnimating];
        [self showErrorNoticeWithTitle:@"沒有返回數據" message:@"加載失敗!" dismiss:nil];
    }];
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
    if ([self.listData count]==0) {
        return 0;
    }
    return [self.listData count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]
               autorelease];
    }
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    cell.textLabel.text=@"";
    cell.detailTextLabel.text=@"";
    if ([self.listData count]!=indexPath.row) {
        NSDictionary *dic=[self.listData objectAtIndex:indexPath.row];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        OrgenMovieMetaData *commonCell=[[OrgenMovieMetaData alloc] initWithData:dic withFrame:CGRectMake(0, 0, self.view.frame.size.width-25, 78)];
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
    return cell;
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        if (indexPath.row==[self.listData count]) {
            if (hotCurPage==hotMaxPage) {
                return 0;
            }
        }
        return 78;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(hotCurPage!=hotMaxPage&&[self.listData count]==indexPath.row){
        hotCurPage++;
        if (hotCurPage>=hotMaxPage) {
            hotCurPage=hotMaxPage;
        }
        
        [self startSearch];
    }else{
         selectRow=indexPath.row;
         [self performSegueWithIdentifier:@"hotToDetail" sender:self];
    }

}
-(void)dealloc{
    [super dealloc];
    if (KeyWord) {
        //[KeyWord release];
    }
    [helper release];
    [listData release];
}
@end
