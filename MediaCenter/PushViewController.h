//
//  PushViewController.h
//  MediaCenter
//
//  Created by aJia on 12/11/27.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
@interface PushViewController : UITableViewController<ServiceHelperDelegate>{
    int selectRow;
    ServiceHelper *_helper;
}
@property(nonatomic,retain) NSMutableArray *listData;
@end
