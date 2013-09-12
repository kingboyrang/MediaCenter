//
//  ProductTypeViewController.m
//  MediaCenter
//
//  Created by aJia on 12/11/28.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "ProductTypeViewController.h"
#import "MediaSoapMessage.h"
#import "SoapXmlParseHelper.h"
#import "CommonCell.h"
#import "AlterMessage.h"
#import "SearchMetaData.h"
@interface ProductTypeViewController ()

@end

@implementation ProductTypeViewController
@synthesize listData,keyWord;
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
    
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(btnSearchclick:)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    [rightBtn release];
   
    self.listData=[NSMutableArray array];
    
    helper=[[ServiceHelper alloc] initWithDelegate:self];
    
    isFirstLoad=YES;
    curPage=1;
    maxPage=1;
    pageSize=10;
    if ([AppHelper isIPad]) {
        pageSize=20;
    }
    self.keyWord=[[NSString alloc] initWithString:@""];
    if (!self.hasNetwork){
        [self showNoNetworkNotice:nil];
    }else{
       [self startSearch];
    }
    
}
-(void)startSearch{
    [self showLoadingAnimated:YES];
    NSString *soapMsg=[MediaSoapMessage EbookMovieSoap:self.keyWord withCurPage:curPage withCurSize:pageSize];
    [helper AsyServiceMethod:@"CategorySearchMetaData" SoapMessage:soapMsg];
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

    /***
    UIViewController *destination = segue.destinationViewController;
    SEL sel=NSSelectorFromString(@"ItemEBook");
    if ([destination respondsToSelector:sel]) {
        [destination setTitle:[[self.listData objectAtIndex:selectRow] objectForKey:@"Title"]];
        [destination setValue:[self.listData objectAtIndex:selectRow] forKey:@"ItemEBook"];
    }
     ***/
}
#pragma mark -
#pragma mark ServiceHelper delegate methods
-(void)finishSuccessRequest:(NSString*)xml responseData:(NSData*)requestData{
    NSString *page;
    NSMutableArray *arr=[SearchMetaData XmlToArray:xml withMaxPage:&page];
    maxPage=[page intValue];
    if (isFirstLoad) {//表示第一次加载
        isFirstLoad=NO;
        self.listData=arr;
        [self.tableView reloadData];
    }else{
        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:pageSize];
        for (int i=0; i<[arr count]; i++){
            [self.listData addObject:[arr objectAtIndex:i]];
            NSIndexPath *newPath=[NSIndexPath indexPathForRow:(curPage-1)*pageSize+i inSection:0];
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
-(void)finishFailRequest:(NSError*)error{
    [self hideLoadingViewAnimated:YES completed:^(AnimateLoadView *hideView) {
        [hideView.activityIndicatorView stopAnimating];
        [self showErrorNoticeWithTitle:@"沒有返回數據" message:@"加載失敗!" dismiss:nil];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    cell.textLabel.text=@"";
    if (indexPath.row!=[self.listData count]) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary *dic=[self.listData objectAtIndex:indexPath.row];
        // NSDictionary *newDic=[NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"Title"],@"C_NAME",[dic objectForKey:@"UnitName"],@"DEPT_NAME",[dic objectForKey:@"Created"],@"REG_DATE",[dic objectForKey:@"TypeName"],@"ClassCodeName", nil];
        
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
      // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==[self.listData count]) {
        if (curPage==maxPage) {
            return 0;
        }
    }
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row!=[self.listData count]) {
        selectRow=indexPath.row;
        [self performSegueWithIdentifier:@"produceToDetail" sender:self];
    }else{
        if (curPage!=maxPage){
            curPage++;
            if (curPage>=maxPage) {
                curPage=maxPage;
            }
            [self startSearch];
        }
    }
    
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
    self.tableView.allowsSelection=YES;
    self.tableView.scrollEnabled=YES;
    
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
    self.tableView.allowsSelection=NO;
    self.tableView.scrollEnabled=NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.listData removeAllObjects];
    self.KeyWord=searchBar.text;//获取查询条件
    [searchBar resignFirstResponder];
    
    self.tableView.allowsSelection=YES;
    self.tableView.scrollEnabled=YES;
    
    isFirstLoad=YES;
    curPage=1;
    maxPage=1;
    
    if (!self.hasNetwork){
        [self showNoNetworkNotice:nil];
        return;
    }
    //开始查询
    [self startSearch];
}
-(void)dealloc{
    [super dealloc];
    [helper release];
    [listData release];
    //[keyWord release];
}
@end
