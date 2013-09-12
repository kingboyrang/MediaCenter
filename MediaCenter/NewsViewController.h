//
//  NewsViewController.h
//  MediaCenter
//
//  Created by aJia on 12/11/19.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "LightMenuBar.h"
#import "LightMenuBarDelegate.h"
@interface NewsViewController : BasicViewController<LightMenuBarDelegate>
-(void)selectedNewsType:(NSInteger)type userinfo:(id)info;
@end
