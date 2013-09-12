//
//  NewsViewController.m
//  MediaCenter
//
//  Created by aJia on 12/11/19.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsList.h"
#import "NewsDetailViewController.h"
#import "UIColor+TPCategory.h"
#define MenuSoureData [NSArray arrayWithObjects:@"最新活動", @"縣政新聞", @"最新影音", @"招標公告", @"懲材公告", @"報乎你知", nil]

@interface NewsViewController ()<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    LightMenuBar *_menuBar;
}

@end

@implementation NewsViewController
- (void)dealloc {
    [super dealloc];
    [_scrollView release],_scrollView=nil;
    [_menuBar release],_menuBar=nil;
}
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
    
    _menuBar= [[LightMenuBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40) andStyle:LightMenuBarStyleItem];
    _menuBar.delegate = self;
    _menuBar.bounces = YES;
    _menuBar.selectedItemIndex = 0;
    if ([self isPad]) {
        UIView *viewBg=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        viewBg.backgroundColor=[UIColor colorFromHexRGB:@"f0f0f0"];
        [viewBg addSubview:_menuBar];
        viewBg.autoresizesSubviews=YES;
        viewBg.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:viewBg];
        [viewBg release];
    }else{
       [self.view addSubview:_menuBar];
    }
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-44*3)];
    //開啟捲動分頁功能，如果不需要這個功能關閉即可
    [_scrollView setPagingEnabled:YES];
    //隐藏横向與縱向的捲軸
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    //在本類別中繼承scrollView的整體事件
    [_scrollView setDelegate:self];
    [_scrollView setContentSize:CGSizeMake(self.view.bounds.size.width*6,_scrollView.bounds.size.height)];
    
    for (int i=0; i<6; i++) {
        NewsList *item=[[NewsList alloc] initWithFrame:CGRectMake(i*self.view.bounds.size.width, 0, self.view.bounds.size.width, _scrollView.bounds.size.height)];
        item.newsType=i+1;
        item.tag=100+i;
        item.scroler=self;
        [_scrollView addSubview:item];
        if (i==0) {
            [item loadingData];
        }
        [item release];
    }
    [self.view addSubview:_scrollView];
}
#pragma mark LightMenuBarDelegate
- (NSUInteger)itemCountInMenuBar:(LightMenuBar *)menuBar {
    return 6;
}

- (NSString *)itemTitleAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar {
    return [MenuSoureData objectAtIndex:index];
}

- (void)itemSelectedAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar {
    NewsList *item=(NewsList*)[_scrollView viewWithTag:100+index];
    if (item) {
        [item loadingData];
    }
    [_scrollView setContentOffset:CGPointMake(index*_scrollView.bounds.size.width,0) animated:YES];
}

//< Optional
- (CGFloat)itemWidthAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar {
    return 91.0f;
}
/****************************************************************************/
//< For Background Area
/****************************************************************************/

/**< Top and Bottom Padding, by Default 5.0f */
- (CGFloat)verticalPaddingInMenuBar:(LightMenuBar *)menuBar {
    return 0.0f;
}

/**< Left and Right Padding, by Default 5.0f */
- (CGFloat)horizontalPaddingInMenuBar:(LightMenuBar *)menuBar {
    return 0.0f;
}

/**< Corner Radius of the background Area, by Default 5.0f */
- (CGFloat)cornerRadiusOfBackgroundInMenuBar:(LightMenuBar *)menuBar {
    return 0.0f;
}

- (UIColor *)colorOfBackgroundInMenuBar:(LightMenuBar *)menuBar {
    return [UIColor colorFromHexRGB:@"f0f0f0"];
}

#pragma mark 页面跳转
-(void)selectedNewsType:(NSInteger)type userinfo:(id)info{
    UIStoryboard *storyboard=self.storyboard;
    NewsDetailViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"NewsDetailViewController"];
    NSDictionary *dic=(NSDictionary*)info;
    if (dic) {
        controller.title=[dic objectForKey:@"Title"];
        controller.NewsItem=dic;
    }
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    NSInteger page=offset.x / bounds.size.width;
    _menuBar.selectedItemIndex=page;
}
@end
