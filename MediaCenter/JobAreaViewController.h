//
//  JobAreaViewController.h
//  MediaCenter
//
//  Created by aJia on 13/9/25.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobAreaList.h"
@interface JobAreaViewController : UIViewController<UIScrollViewDelegate>{
@private
    UIScrollView *nibScrollView;
    
    //页面展示部分
    JobAreaList *couponTableView;
    JobAreaList *groupbuyTableView;
    
    //左右滑动部分
	UIPageControl *pageControl;
    int currentPage;
    BOOL pageControlUsed;
}
@property (nonatomic) BOOL refreshing;
@property (retain, nonatomic) IBOutlet UIButton *couponButton;
@property (retain, nonatomic) IBOutlet UIButton *groupbuyButton;
@property (retain, nonatomic) IBOutlet UILabel *slidLabel;
-(void)selectedJobDetail:(NSString*)guid;
@end
