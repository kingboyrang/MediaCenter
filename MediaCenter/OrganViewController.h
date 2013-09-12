//
//  OrganViewController.h
//  MediaCenter
//
//  Created by aJia on 12/11/26.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "BasicTableViewController.h"
@interface OrganViewController : BasicTableViewController<ServiceHelperDelegate>{
    ServiceHelper *helper;
    int selectRow;
}

@property(nonatomic,retain) NSMutableArray *listData;
@end
