//
//  HappyTypeViewController.h
//  MediaCenter
//
//  Created by aJia on 12/12/17.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "BasicTableViewController.h"
@interface HappyTypeViewController : BasicTableViewController<ServiceHelperDelegate>{
    ServiceHelper *helper;
}
@property(nonatomic,retain) NSMutableArray *listData;
@end
