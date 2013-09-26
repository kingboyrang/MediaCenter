//
//  JobDetailViewController.h
//  MediaCenter
//
//  Created by aJia on 13/9/25.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "BasicViewController.h"
@interface JobDetailViewController : BasicViewController<ServiceHelperDelegate,UITableViewDataSource,UITableViewDelegate>{
    ServiceHelper *helper;
}
@property(nonatomic,copy) NSString* detailPK;
@property(nonatomic,retain) NSMutableArray *sourceData;
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *cells;
@end
