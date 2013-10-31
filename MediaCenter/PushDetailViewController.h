//
//  PushDetailViewController.h
//  MediaCenter
//
//  Created by aJia on 12/11/27.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "PushResult.h"
@interface PushDetailViewController : UIViewController<ServiceHelperDelegate>{
    ServiceHelper *helper;
}
-(void)loadPushDetail:(NSString*)guid;
@property(nonatomic,strong) PushResult *Entity;
@end
