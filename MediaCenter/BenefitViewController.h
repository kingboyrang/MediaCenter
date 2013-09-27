//
//  BenefitViewController.h
//  MediaCenter
//
//  Created by aJia on 13/9/25.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "BasicViewController.h"
#import "PullingRefreshTableView.h"
@interface BenefitViewController : BasicViewController<PullingRefreshTableViewDelegate,ServiceHelperDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    int curPage;
    int pageSize;
    int maxPage;
    BOOL isFirstLoad;//是否为第一次加载
    
    ServiceHelper *helper;
    int selectRow;
    
    PullingRefreshTableView *_tableView;
}
@property (nonatomic) BOOL refreshing;
@property(nonatomic,retain) NSMutableArray *listData;
@end
