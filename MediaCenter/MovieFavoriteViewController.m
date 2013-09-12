//
//  MovieFavoriteViewController.m
//  MediaCenter
//
//  Created by rang on 12-11-23.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "MovieFavoriteViewController.h"
#import "FileHelper.h"
#import "AlterMessage.h"
#define  MediaDownloadDirectory [NSString stringWithFormat:@"%@/Caches/MediaCenter", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]]
@interface MovieFavoriteViewController ()

@end

@implementation MovieFavoriteViewController
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
    self.listData=[AppHelper fileNameToMovieCollection];
    //[FileHelper DirPathList:MediaDownloadDirectory];
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置logo图标
    [self.navigationItem titleViewBackground];
    //[FileHelper DirPathList:[NSString stringWithFormat:@"%@/Caches/MediaCenter", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
//打开一个档案
-(void)openDocumentUrl:(NSString*)fileUrl{
    NSURL *url=[NSURL fileURLWithPath:fileUrl];
    documentController = [UIDocumentInteractionController  interactionControllerWithURL:url];
    documentController.delegate=self;
    [documentController retain];
    CGRect navRect = self.navigationController.navigationBar.frame;
    
    navRect.size = CGSizeMake(1500.0f, 40.0f);
    
    [documentController presentOptionsMenuFromRect:navRect inView:self.view  animated:YES];
}
#pragma mark -
#pragma mark UIDocumentInteractionControllerDelegate Methods
- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller
{
    return self;
}
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
{
    return self.view;
}
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
{
    return self.view.frame;
}
// 点击预览窗口的“Done”(完成)按钮时调用
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController*)_controller
{
    [_controller autorelease];
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
    static NSString *CellIdentifier = @"CellFavoriteIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    //NSString *fileName=[self.listData objectAtIndex:indexPath.row];
    NSDictionary *dic=[self.listData objectAtIndex:indexPath.row];
    cell.textLabel.text=[dic objectForKey:@"name"];
    
    cell.detailTextLabel.numberOfLines=0;
    cell.detailTextLabel.lineBreakMode=NSLineBreakByWordWrapping;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@\n單位:%@",[dic objectForKey:@"date"],[dic objectForKey:@"dept"]];
    //[NSString stringWithFormat:@"%d.%@",indexPath.row+1,fileName];
    
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
    return 65;
}
//默认编辑模式为删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //deleteIndexPath=indexPath;
    deleteRow=indexPath.row;
    UIAlertView *alter=[[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:@"確定是否刪除?"
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                    otherButtonTitles:@"確定", nil];
    [alter show];
    [alter release];
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *fileUrl=[DownFileFolderPath stringByAppendingPathComponent:[[self.listData objectAtIndex:indexPath.row] objectForKey:@"name"]];
    [self openDocumentUrl:fileUrl];
}
#pragma mark -
#pragma mark UIAlertView delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {//删除
        NSDictionary *dic=[self.listData objectAtIndex:deleteRow];
        NSString *fileName=[dic objectForKey:@"name"];
        NSString *path=[DownFileFolderPath stringByAppendingPathComponent:fileName];
        //删除文件
        [FileHelper deleteFilePath:path];
        //更新影音收藏数据
        //[AppHelper movieDeleteFile:[dic objectForKey:@"guid"]];
        //删除绑定数据
        [self.listData removeObjectAtIndex:deleteRow];
        
        //重新写入文件中
        [FileHelper ContentToFile:self.listData withFileName:@"MediaMovieCollection.plist"];
        //行的删除
         NSMutableArray *indexPaths = [NSMutableArray array];
        [indexPaths addObject:[NSIndexPath indexPathForRow:deleteRow inSection:0]];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [AlterMessage initWithMessage:@"刪除成功!"];
    }else{
        
    }
}
-(void)dealloc{
    [super dealloc];
    [listData release];
}
- (IBAction)toggleEdit:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
	if(self.tableView.editing)
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
	else {
		[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
	}
}
@end
