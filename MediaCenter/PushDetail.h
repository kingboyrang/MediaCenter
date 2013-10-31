//
//  PushDetail.h
//  Eland
//
//  Created by aJia on 13/10/9.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushResult.h"
@interface PushDetail : UIView
@property(nonatomic,strong) UILabel *labSubject;
@property(nonatomic,strong) UILabel *labBody;
@property(nonatomic,strong) UILabel *labApplyDate;
-(void)setDataSource:(PushResult*)args;
@end
