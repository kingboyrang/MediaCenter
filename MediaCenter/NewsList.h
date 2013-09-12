//
//  NewsList.h
//  MediaCenter
//
//  Created by aJia on 13/9/12.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "PullingRefreshTableView.h"
@interface NewsList : UIView<PullingRefreshTableViewDelegate,ServiceHelperDelegate,UITableViewDataSource,UITableViewDelegate>{
 @private
    PullingRefreshTableView *_tableView;
    NSInteger govCurPage;
    NSInteger govMaxPage;
    ServiceHelper *_helper;
    BOOL   _isFirst;
}
@property (nonatomic) BOOL refreshing;
@property(nonatomic,assign) NSInteger newsType;
@property(nonatomic,retain) NSMutableArray *sourceData;
@property(nonatomic,assign) id scroler;
-(void)loadingData;
@end
