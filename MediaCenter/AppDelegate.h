//
//  AppDelegate.h
//  MediaCenter
//
//  Created by aJia on 12/11/6.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import <QuickLook/QuickLook.h>
#import "NetWorkConnection.h"
@interface AppDelegate : UIResponder <NetWorkDelegate,ServiceHelperDelegate,UIApplicationDelegate>{
    ServiceHelper *helper;
    
}
@property (strong, nonatomic) UIWindow *window;
//推播
-(void)reRegisterApns;
//推播处理
-(void)pushHandler:(NSDictionary*)userInfo;
-(void)updateAccessInterface;
@end
