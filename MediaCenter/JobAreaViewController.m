//
//  JobAreaViewController.m
//  MediaCenter
//
//  Created by aJia on 13/9/25.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "JobAreaViewController.h"
#import "JobDetailViewController.h"
@interface JobAreaViewController ()
- (void)initAddControls;
- (void) addBasicView;
//界面按钮事件
- (void) btnActionShow;
- (void) couponButtonAction;
- (void) groupbuyButtonAction;
@end

@implementation JobAreaViewController
@synthesize refreshing;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置logo图标
    [self.navigationItem titleViewBackground];
    
    [self initAddControls];
    [self addBasicView];
    
    [couponTableView loadingData];
	
}
//求职详情
-(void)selectedJobDetail:(NSString*)guid{
    JobDetailViewController *detail=[[JobDetailViewController alloc] init];
    detail.detailPK=guid;
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}
#pragma mark-
#pragma mark 添加控件
- (void)initAddControls{
    nibScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-40-44*2)];
    nibScrollView.scrollEnabled=YES;
    nibScrollView.showsHorizontalScrollIndicator=NO;
    nibScrollView.showsVerticalScrollIndicator=NO;
    nibScrollView.scrollsToTop = NO;
    nibScrollView.delegate = self;
    [nibScrollView setContentOffset:CGPointMake(0, 0)];
    [nibScrollView setContentSize:CGSizeMake(2*self.view.bounds.size.width,nibScrollView.frame.size.height)];
    
    couponTableView=[[JobAreaList alloc] initWithFrame:CGRectMake(0, 0,nibScrollView.frame.size.width,nibScrollView.frame.size.height)];
    couponTableView.scroler=self;
    [couponTableView setAutoresizesSubviews:YES];
    [couponTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [nibScrollView addSubview:couponTableView];
    
    
    groupbuyTableView=[[JobAreaList alloc] initWithFrame:CGRectMake(nibScrollView.frame.size.width, 0,nibScrollView.frame.size.width,nibScrollView.frame.size.height)];
    groupbuyTableView.jobType=2;
    [groupbuyTableView setAutoresizesSubviews:YES];
    [groupbuyTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [nibScrollView addSubview:groupbuyTableView];
    [self.view addSubview:nibScrollView];
    
    //公用
    currentPage = 0;
    pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-100)/2.0, 0, 100, 30)];
    pageControl.currentPage=0;
    pageControl.numberOfPages=2;
    pageControl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pageControl];
    pageControl.hidden=YES;
}
- (void) addBasicView
{
    self.couponButton.showsTouchWhenHighlighted = YES;  //指定按钮被按下时发光
    [self.couponButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//此时选中
    [self.couponButton addTarget:self action:@selector(couponButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.groupbuyButton.showsTouchWhenHighlighted = YES;  //指定按钮被按下时发光
    [self.groupbuyButton setTitleColor:[UIColor colorWithRed:(220/255.0) green:(220/255.0) blue:(220/255.0) alpha:1] forState:UIControlStateNormal];//此时未被选中
    [self.groupbuyButton addTarget:self action:@selector(groupbuyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark-
#pragma mark 界面按钮事件

- (void) btnActionShow
{
    if (currentPage == 0) {
        [self couponButtonAction];
    }
    else{
        [self groupbuyButtonAction];
    }
}

- (void) couponButtonAction
{
    [self.couponButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//此时选中
    [self.groupbuyButton setTitleColor:[UIColor colorWithRed:(220/255.0) green:(220/255.0) blue:(220/255.0) alpha:1] forState:UIControlStateNormal];//此时未被选中
    
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    
    CGFloat w=160;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        w=384;
    }
    
    self.slidLabel.frame = CGRectMake(0, 36, w, 4);//384
    [nibScrollView setContentOffset:CGPointMake(self.view.bounds.size.width*0, 0)];//页面滑动
    
    [UIView commitAnimations];
    [couponTableView loadingData];
}

- (void) groupbuyButtonAction
{
    [self.groupbuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//此时选中
    [self.couponButton setTitleColor:[UIColor colorWithRed:(220/255.0) green:(220/255.0) blue:(220/255.0) alpha:1] forState:UIControlStateNormal];//此时未被选中
    
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    
    CGFloat w=161,leftX=159;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        w=385;
        leftX=384;
    }
    
    self.slidLabel.frame = CGRectMake(leftX, 36, w, 4);
    [nibScrollView setContentOffset:CGPointMake(self.view.bounds.size.width*1, 0)];
    
    [UIView commitAnimations];
    [groupbuyTableView loadingData];
}
#pragma mark UIScrollViewDelegate Methods
// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = nibScrollView.frame.size.width;
    int page = floor((nibScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    pageControl.currentPage = page;
    currentPage = page;
    pageControlUsed = NO;
    [self btnActionShow];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //暂不处理 - 其实左右滑动还有包含开始等等操作，这里不做介绍
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return YES;
}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_slidLabel release];
    [_groupbuyButton release];
    [_couponButton release];
    [nibScrollView release];
    [couponTableView release];
    [groupbuyTableView release];
    [pageControl release];
    [super dealloc];
}
@end
