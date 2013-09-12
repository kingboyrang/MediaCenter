//
//  BasicTableViewController.m
//  MediaCenter
//
//  Created by aJia on 13/9/11.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "BasicTableViewController.h"
#import "WBErrorNoticeView.h"
#import "WBSuccessNoticeView.h"
@interface BasicTableViewController (){
    AnimateLoadView *_loadView;
    AnimateErrorView *_errorView;
}
-(void)detectShowOrientation;

@end

@implementation BasicTableViewController
@synthesize hasNetwork=_hasNetwork;
@synthesize isPad;
@synthesize isLandscape=_isLandscape;
-(void)dealloc{
    [super dealloc];
    if(_loadView){
        [_loadView release],_loadView=nil;
    }
    if(_errorView){
        [_errorView release],_errorView=nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //横竖屏检测
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectShowOrientation) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 横竖屏检测
-(void)detectShowOrientation{
    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft ||[UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight){//
        //NSLog(@"videolist 横屏");
        _isLandscape=YES;
    }else{//
        //NSLog(@"videoList 竖屏");
        _isLandscape=NO;
    }
}
#pragma mark 属性重写
-(BOOL)isPad{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
}
#pragma mark 网络未连接提示
- (void) showNoNetworkNotice:(void (^)(void))dismissError{
    [self showErrorNoticeWithTitle:@"Network Error" message:@"Check your network connection." dismiss:dismissError];
}
- (void) showSuccessNoticeWithTitle:(NSString*)title{
    WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:self.view title:title];
    [notice show];
}
- (void) showErrorNoticeWithTitle:(NSString*)title message:(NSString*)message dismiss:(void (^)(void))dismissError{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:title message:message];
    [notice setDismissalBlock:^(BOOL dismissedInteractively) {
        if (dismissError) {
            dismissError();
        }
    }];
    [notice show];
}
#pragma mark 网络检测
-(BOOL)hasNetwork{
    return [[NetWorkConnection sharedInstance] hasConnection];
}
#pragma mark 动画提示
-(AnimateErrorView*) errorView {
    
    if (!_errorView) {
        _errorView=[[AnimateErrorView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
        
    }
    return _errorView;
}

-(AnimateLoadView*) loadingView {
    if (!_loadView) {
        _loadView=[[AnimateLoadView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
        
    }
    return _loadView;
}
-(void) showLoadingAnimated:(BOOL) animated{
    [self showLoadingAnimated:animated process:^(AnimateLoadView *showView) {
        [showView.labelTitle setText:@"正在加載..."];
        [showView.activityIndicatorView startAnimating];
    }];
}
-(void) showLoadingAnimated:(BOOL) animated process:(void (^)(AnimateLoadView *showView))process{
    
    AnimateLoadView *loadingView = [self loadingView];
    if (process) {
        process(loadingView);
    }
    loadingView.alpha = 0.0f;
    [self.view addSubview:loadingView];
    [self.view bringSubviewToFront:loadingView];
    
    double duration = animated ? 0.4f:0.0f;
    [UIView animateWithDuration:duration animations:^{
        loadingView.alpha = 1.0f;
    }];
}
-(void) hideLoadingViewAnimated:(BOOL) animated{
    [self hideLoadingViewAnimated:animated completed:^(AnimateLoadView *hideView) {
        [hideView.activityIndicatorView stopAnimating];
    }];
}
-(void) hideLoadingViewAnimated:(BOOL) animated completed:(void (^)(AnimateLoadView *hideView))complete{
    
    AnimateLoadView *loadingView = [self loadingView];
    
    double duration = animated ? 0.4f:0.0f;
    [UIView animateWithDuration:duration animations:^{
        loadingView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [loadingView removeFromSuperview];
        if (complete) {
            complete(loadingView);
        }
    }];
}
-(void) showErrorViewAnimated:(BOOL) animated{
    [self showErrorViewAnimated:animated process:^(AnimateErrorView *errorView) {
        [errorView.labelTitle setText:@"加載失敗!"];
    }];
}
-(void) showErrorViewAnimated:(BOOL) animated process:(void (^)(AnimateErrorView *errView))process{
    
    AnimateErrorView *errorView = [self errorView];
    if (process) {
        process(errorView);
    }
    errorView.alpha = 0.0f;
    [self.view addSubview:errorView];
    [self.view bringSubviewToFront:errorView];
    
    double duration = animated ? 0.4f:0.0f;
    [UIView animateWithDuration:duration animations:^{
        errorView.alpha = 1.0f;
    }];
}
-(void) hideErrorViewAnimated:(BOOL) animated{
    [self hideErrorViewAnimated:animated completed:nil];
}
-(void) hideErrorViewAnimated:(BOOL) animated completed:(void (^)(AnimateErrorView *errView))complete{
    
    AnimateErrorView *errorView = [self errorView];
    
    double duration = animated ? 0.4f:0.0f;
    [UIView animateWithDuration:duration animations:^{
        errorView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [errorView removeFromSuperview];
        if (complete) {
            complete(errorView);
        }
    }];
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    
    CGRect screnRect=self.view.bounds;
    CGFloat screenW=screnRect.size.width,screenH=screnRect.size.height;
    if (_loadView) {
        CGRect frame=_loadView.frame;
        frame.origin.x=(screenW-frame.size.width)/2.0;
        frame.origin.y=(screenH-frame.size.height)/2.0;
        _loadView.frame=frame;
    }
    if (_errorView) {
        CGRect frame=_errorView.frame;
        frame.origin.x=(screenW-frame.size.width)/2.0;
        frame.origin.y=(screenH-frame.size.height)/2.0;
        _errorView.frame=frame;
    }
}

@end
