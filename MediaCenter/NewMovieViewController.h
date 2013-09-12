//
//  IndexViewController.h
//  MediaCenter
//
//  Created by aJia on 12/12/1.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "BasicViewController.h"
@interface NewMovieViewController:BasicViewController<ServiceHelperDelegate,UIAlertViewDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    //最新影音
    int curPage;
    int commonPageSize;
    int maxPage;
    BOOL isFirst;

    //传值处理
    int selectRow;
    
    ServiceHelper *helper;
}
@property(retain,nonatomic) UITableView *movieTableView;//newTableView
@property(nonatomic,retain) NSMutableArray *movieListData;//newListData
@property(nonatomic,retain) NSString *KeyWord;
//点击查询按钮时，出现查询对话框
- (IBAction)btnSearchclick:(id)sender;
//开始加载数据
-(void)startSearch;
//最新影音
-(void)handlerNewMovie:(NSString*)xml;
//清除搜寻框
-(void)clearChildsView;
@end
