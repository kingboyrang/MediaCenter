//
//  ProductTypeViewController.h
//  MediaCenter
//
//  Created by aJia on 12/11/28.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "PullingRefreshTableView.h"
@interface ProductTypeViewController : UIViewController<PullingRefreshTableViewDelegate,ServiceHelperDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    ServiceHelper *helper;
    int selectRow;
    int curPage;
    int pageSize;
    int maxPage;
    BOOL isFirstLoad;
    
   PullingRefreshTableView *_tableView;
}



@property(nonatomic,retain) NSMutableArray *listData;
@property(nonatomic,copy) NSString *keyWord;
@property (nonatomic) BOOL refreshing;
-(void)startSearch;

//点击查询按钮时，出现查询对话框
- (IBAction)btnSearchclick:(id)sender;
//清除搜寻框
-(void)clearChildsView;
@end
