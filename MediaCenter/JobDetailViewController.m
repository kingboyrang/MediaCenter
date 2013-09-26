//
//  JobDetailViewController.m
//  MediaCenter
//
//  Created by aJia on 13/9/25.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "JobDetailViewController.h"
#import "MediaSoapMessage.h"
#import "SoapXmlParseHelper.h"
#import "TKLabelLabel.h"
@interface JobDetailViewController ()
@end

@implementation JobDetailViewController
@synthesize detailPK;
@synthesize tableView=_tableView;
@synthesize sourceData=_sourceData;
@synthesize cells=_cells;
-(void)dealloc{
    [super dealloc];
    [_sourceData release];
    [_tableView release];
    [_cells release],_cells=nil;
}
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
    self.view.backgroundColor=[UIColor whiteColor];
    //设置logo图标
    [self.navigationItem titleViewBackground];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    TKLabelLabel *cell1=[[[TKLabelLabel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell1.label setText:@"廠商名稱"];
    
    TKLabelLabel *cell2=[[[TKLabelLabel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell2.label setText:@"職位名稱\n(職業類別)"];
    
    TKLabelLabel *cell3=[[[TKLabelLabel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell3.label setText:@"工作地點"];
    
    TKLabelLabel *cell4=[[[TKLabelLabel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell4.label setText:@"計薪方式"];
    
    TKLabelLabel *cell5=[[[TKLabelLabel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell5.label setText:@"聯絡方式"];
    
    TKLabelLabel *cell6=[[[TKLabelLabel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell6.label setText:@"學經歷要求"];
    
    self.cells =[NSMutableArray arrayWithObjects:cell1,cell2,cell3,cell4,cell5,cell6, nil];
    
    helper=[[ServiceHelper alloc] initWithDelegate:self];
    [self showLoadingAnimated:YES];
    NSString *soapMsg=[MediaSoapMessage GetRecruitersDetailSoapMessage:self.detailPK];
    [helper AsyServiceMethod:@"GetRecruitersDetail" SoapMessage:soapMsg];
    /**
    self.sourceData=[[NSMutableArray alloc] init];
    [self.sourceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"廠商名稱",@"Company",@"",@"value", nil]];
    [self.sourceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"職位名稱(職業類別)",@"JobName",@"",@"value", nil]];
    [self.sourceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"工作地點",@"WorkAddress",@"",@"value", nil]];
    [self.sourceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"計薪方式",@"PayMode",@"",@"value", nil]];
    [self.sourceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"聯絡方式",@"Contact",@"",@"value", nil]];
    [self.sourceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"學經歷要求",@"Education",@"",@"value", nil]];
     **/
}
#pragma mark UITableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return [self.cells count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKLabelLabel *tableCell=self.cells[indexPath.row];
    if (indexPath.row!=0||indexPath.row!=2) {
        tableCell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (self.sourceData&&[self.sourceData objectAtIndex:indexPath.row]!=nil) {
         [tableCell.detail setText:[self.sourceData objectAtIndex:indexPath.row]];
    }
   
    return tableCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sourceData&&[self.sourceData objectAtIndex:indexPath.row]!=nil) {
        // 列寬
        CGFloat contentWidth = self.tableView.frame.size.width;
        // 用何種字體進行顯示
        UIFont *font = [UIFont boldSystemFontOfSize:16];
        
        // 該行要顯示的內容
        NSString *content = [self.sourceData objectAtIndex:indexPath.row];
        // 計算出顯示完內容需要的最小尺寸
        CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        
        // 這裏返回需要的高度
        return size.height<44.0?44.0:size.height;
    }
    return 44;
}
#pragma mark ServiceHelperDelegate
-(void)finishSuccessRequest:(NSString*)responseText responseData:(NSData*)requestData{
    [self hideLoadingViewAnimated:YES];
    NSArray *arr=[SoapXmlParseHelper DataTableToArray:responseText];
    if (!self.sourceData) {
        self.sourceData=[[NSMutableArray alloc] init];
    }else{
        [self.sourceData removeAllObjects];
    }
    if (arr!=nil&&[arr count]>0) {
        NSDictionary *dic=[arr objectAtIndex:0];
        [self.sourceData addObject:[dic objectForKey:@"Company"]];
 [self.sourceData addObject:[dic objectForKey:@"JobName"]];
[self.sourceData addObject:[dic objectForKey:@"WorkAddress"]];
[self.sourceData addObject:[dic objectForKey:@"PayMode"]];     
[self.sourceData addObject:[dic objectForKey:@"Contact"]];     
[self.sourceData addObject:[dic objectForKey:@"Education"]];     
        [self.tableView reloadData];
        
        
    }else{
        [self hideLoadingViewAnimated:YES completed:^(AnimateLoadView *hideView) {
            [hideView.activityIndicatorView stopAnimating];
            [self showErrorViewAnimated:YES];
        }];
    }
    
}
-(void)finishFailRequest:(NSError*)error{
    [self hideLoadingViewAnimated:YES completed:^(AnimateLoadView *hideView) {
        [hideView.activityIndicatorView stopAnimating];
        [self showErrorViewAnimated:YES];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
