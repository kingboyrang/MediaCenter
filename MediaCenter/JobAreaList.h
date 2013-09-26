//
//  JobAreaList.h
//  MediaCenter
//
//  Created by aJia on 13/9/25.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "PullingRefreshTableView.h"
@interface JobAreaList : UIView<PullingRefreshTableViewDelegate,ServiceHelperDelegate,UITableViewDataSource,UITableViewDelegate>{
@private
    PullingRefreshTableView *_tableView;
    NSInteger govCurPage;
    NSInteger govPageSize;
    NSInteger govMaxPage;
    ServiceHelper *_helper;
    BOOL   _isFirst;
}
@property(nonatomic,assign) int jobType;
@property (nonatomic) BOOL refreshing;
@property(nonatomic,retain) NSMutableArray *sourceData;
@property(nonatomic,assign) id scroler;
-(void)loadingData;
@end
