//
//  PushDetailViewController.h
//  MediaCenter
//
//  Created by aJia on 12/11/27.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
@interface PushDetailViewController : UIViewController<ServiceHelperDelegate>{
    ServiceHelper *helper;
}
@property(nonatomic,retain) NSDictionary *ItemData;
@property(nonatomic,retain) NSString *GUID;
-(void)reLoadController:(NSString*)title withMessage:(NSString*)msg;
@end
