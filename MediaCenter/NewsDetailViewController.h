//
//  NewsDetailViewController.h
//  MediaCenter
//
//  Created by aJia on 12/11/24.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
@interface NewsDetailViewController : BasicViewController

@property (retain, nonatomic) IBOutlet UITextView *tView;
@property(nonatomic,retain) NSDictionary *NewsItem;
@end
