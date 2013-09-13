//
//  DistrictViewController.h
//  MediaCenter
//
//  Created by aJia on 12/12/3.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "BasicViewController.h"
#import "PullingRefreshTableView.h"
@interface DistrictViewController : BasicViewController<PullingRefreshTableViewDelegate,ServiceHelperDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    int curPage;
    int pageSize;
    int maxPage;
    BOOL isFirstLoad;//是否为第一次加载
    
    ServiceHelper *helper;
    int selectRow;
    
    PullingRefreshTableView *_tableView;
}
@property (nonatomic) BOOL refreshing;
@property(nonatomic,retain) NSString *keyWord;
@property(nonatomic,retain) NSMutableArray *listData;
//打开链接
- (IBAction)buttonLinkClick:(id)sender;
-(void)startSearch;

//点击查询按钮时，出现查询对话框
- (IBAction)btnSearchclick:(id)sender;
//清除搜寻框
-(void)clearChildsView;
@end
