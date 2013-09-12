//
//  ProductTypeViewController.h
//  MediaCenter
//
//  Created by aJia on 12/11/28.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "BasicTableViewController.h"
@interface ProductTypeViewController : BasicTableViewController<ServiceHelperDelegate,UISearchBarDelegate>{
    ServiceHelper *helper;
    int selectRow;
    int curPage;
    int pageSize;
    int maxPage;
    BOOL isFirstLoad;
}
@property(nonatomic,retain) NSMutableArray *listData;
@property(nonatomic,copy) NSString *keyWord;
-(void)startSearch;

//点击查询按钮时，出现查询对话框
- (IBAction)btnSearchclick:(id)sender;
//清除搜寻框
-(void)clearChildsView;
@end
