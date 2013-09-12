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
@interface PushViewController ()

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
    NSArray *arr=[AppHelper fileNameToPush];
    //排序
    NSSortDescriptor *_sorter  = [[NSSortDescriptor alloc] initWithKey:@"Created" ascending:NO];
    NSArray *sortArr=[arr sortedArrayUsingDescriptors:[NSArray arrayWithObjects:_sorter, nil]];
    self.listData=[NSMutableArray array];
    [self.listData addObjectsFromArray:sortArr];
    [_sorter release];

    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置logo图标
    [self.navigationItem titleViewBackground];
    
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonEditClick:)];
    self.navigationItem.rightBarButtonItem=rightButton;
    [rightButton release];
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
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[[self.listData objectAtIndex:indexPath.row] objectForKey:@"Title"];
    cell.detailTextLabel.text=[PushInfo formatCreateTime:[[self.listData objectAtIndex:indexPath.row] objectForKey:@"Created"]];//Created
    // Configure the cell...
    
    return cell;
}
//默认编辑模式为删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger deleteRow=indexPath.row;
    [AlterMessage initWithTip:@"確定是否刪除?" confirmMessage:@"確定" cancelMessage:@"取消" confirmAction:^(){
        //删除绑定数据
        [self.listData removeObjectAtIndex:deleteRow];
        //重新写入文件中
        [FileHelper ContentToFile:self.listData withFileName:@"Push.plist"];
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
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectRow=indexPath.row;
}
-(void)dealloc{
    [super dealloc];
    [listData release];
}
@end
