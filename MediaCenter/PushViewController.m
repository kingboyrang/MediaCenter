//
//  PushViewController.m
//  MediaCenter
//
//  Created by aJia on 12/11/27.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "PushViewController.h"
#import "FileHelper.h"
#import "AlterMessage.h"
#import "PushInfo.h"
#import "CacheHelper.h"
#import "SoapHelper.h"
#import "XmlParseHelper.h"
#import "PushDetail.h"
@interface PushViewController ()
-(void)loadAndUpdatePush;
-(void)reloadPushInfo;
@end

@implementation PushViewController
@synthesize listData;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadPushInfo];
    [self loadAndUpdatePush];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置logo图标
    [self.navigationItem titleViewBackground];
    
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonEditClick:)];
    self.navigationItem.rightBarButtonItem=rightButton;
    [rightButton release];
    _helper=[[ServiceHelper alloc] initWithDelegate:self];
}
-(void)reloadPushInfo{
    NSArray *arr=[CacheHelper readCacheCasePush];
    if (arr&&[arr count]>0) {
        //排序
        NSSortDescriptor *_sorter  = [[NSSortDescriptor alloc] initWithKey:@"SendTime" ascending:NO];
        NSArray *sortArr=[arr sortedArrayUsingDescriptors:[NSArray arrayWithObjects:_sorter, nil]];
        self.listData=[NSMutableArray arrayWithArray:sortArr];
        [_sorter release];
        [self.tableView reloadData];
    }
}
-(void)loadAndUpdatePush{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token=[userDefaults objectForKey:@"Flag"];
    //NSString *token=@"6997eda072e4e60784a108bb9a98a777f737403caaaa2ed22f69580d14a411f5";
    if ([token length]==0)return;
    
    NSString *soap=[SoapHelper NameSpaceSoapMessage:PushWebServiceNameSpace MethodName:@"GetMessages"];
    NSString *msg=[NSString stringWithFormat:@"<token>%@</token>",token];
    NSString *body=[NSString stringWithFormat:soap,msg];
    [_helper AsyCommonServiceRequest:PushWebServiceUrl ServiceNameSpace:PushWebServiceNameSpace ServiceMethodName:@"GetMessage" SoapMessage:body];
}
-(void)finishSuccessRequest:(NSString*)responseText responseData:(NSData*)requestData{
    if ([responseText length]>0) {
        NSString *xml=[responseText stringByReplacingOccurrencesOfString:@"xmlns=\"Push[]\"" withString:@""];
        XmlParseHelper *result=[[[XmlParseHelper alloc] initWithData:xml] autorelease];
        NSArray *arr=[result selectNodes:@"//Push" className:@"PushResult"];
        if (arr&&[arr count]>0) {
            [CacheHelper cacheCasePushArray:arr];
            [self reloadPushInfo];
            
        }
    }
}
-(void)finishFailRequest:(NSError*)error{
}
//编辑
-(IBAction)buttonEditClick:(id)sender{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if(self.tableView.editing)
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
	else {
		[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
	}
}
//如果还要传值，可以再这处理
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    //NSString *guid=[[self.listData objectAtIndex:selectRow] objectForKey:@"GUID"];
    //[destination setValue:@"7a4d1b42-e0c1-4020-9ae9-c879262212ec" forKey:@"GUID"];
     SEL sel=NSSelectorFromString(@"ItemData");
    if ([destination respondsToSelector:sel]) {
         [destination setValue:[self.listData objectAtIndex:selectRow] forKey:@"ItemData"];
    }
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
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellPushIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        PushDetail *detail=[[PushDetail alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 53)];
        detail.tag=100;
        [cell.contentView addSubview:detail];
        [detail release];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    PushResult *entity=[self.listData objectAtIndex:indexPath.row];
    PushDetail *pushDetail=(PushDetail*)[cell viewWithTag:100];
    [pushDetail setDataSource:entity];
    // Configure the cell...
    
    return cell;
}
//默认编辑模式为删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger deleteRow=indexPath.row;
    [AlterMessage initWithTip:@"確定是否刪除?" confirmMessage:@"確定" cancelMessage:@"取消" confirmAction:^(){
        PushResult *entity=[[self.listData objectAtIndex:deleteRow] retain];
        [CacheHelper cacheDeletePushWithGuid:entity.GUID];
        [entity release];
        //删除绑定数据
        [self.listData removeObjectAtIndex:deleteRow];
        //重新写入文件中
        [CacheHelper cacheCasePushFromArray:self.listData];
        //行的删除
        NSMutableArray *indexPaths = [NSMutableArray array];
        [indexPaths addObject:[NSIndexPath indexPathForRow:deleteRow inSection:0]];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [AlterMessage initWithMessage:@"刪除成功!"];
    
    }];

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
    return 53;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectRow=indexPath.row;
}
-(void)dealloc{
    [super dealloc];
    [listData release];
    [_helper release],_helper=nil;
}
@end
