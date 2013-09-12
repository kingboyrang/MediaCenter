//
//  BasicTableViewController.h
//  MediaCenter
//
//  Created by aJia on 13/9/11.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimateLoadView.h"
#import "AnimateErrorView.h"
#import "NetWorkConnection.h"
@interface BasicTableViewController : UITableViewController
@property(nonatomic,readonly) BOOL hasNetwork;
@property(nonatomic,readonly) BOOL isPad;
@property(nonatomic,readonly) BOOL isLandscape;
//动画操作
-(AnimateErrorView*) errorView;
-(AnimateLoadView*) loadingView;
-(void) showLoadingAnimated:(BOOL) animated;
-(void) showLoadingAnimated:(BOOL) animated process:(void (^)(AnimateLoadView *showView))process;
-(void) hideLoadingViewAnimated:(BOOL) animated;
-(void) hideLoadingViewAnimated:(BOOL) animated completed:(void (^)(AnimateLoadView *hideView))complete;
-(void) showErrorViewAnimated:(BOOL) animated;
-(void) showErrorViewAnimated:(BOOL) animated process:(void (^)(AnimateErrorView *errorView))process;
-(void) hideErrorViewAnimated:(BOOL) animated;
-(void) hideErrorViewAnimated:(BOOL) animated completed:(void (^)(AnimateErrorView *errorView))complete;
//网络提示
- (void) showNoNetworkNotice:(void (^)(void))dismissError;
- (void) showSuccessNoticeWithTitle:(NSString*)title;
- (void) showErrorNoticeWithTitle:(NSString*)title message:(NSString*)message dismiss:(void (^)(void))dismissError;
@end
