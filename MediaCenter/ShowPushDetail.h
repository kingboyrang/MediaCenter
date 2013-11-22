//
//  ShowPushDetail.h
//  Eland
//
//  Created by aJia on 2013/11/22.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
@interface ShowPushDetail : UIScrollView<RTLabelDelegate>
@property(nonatomic,strong) RTLabel *label;
-(void)setTextContent:(NSString*)content;
@end
