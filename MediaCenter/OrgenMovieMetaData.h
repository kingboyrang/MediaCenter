//
//  OrgenMovieMetaData.h
//  MediaCenter
//
//  Created by aJia on 12/12/17.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrgenMovieMetaData : UIView
@property(nonatomic,retain) NSDictionary *ItemData;
-(id)initWithData:(NSDictionary*)dic withFrame:(CGRect)frame;
-(void)loadConfigure;
-(void)addControl:(NSString*)txt withFont:(UIFont*)f frame:(CGRect)frame;
-(NSString*)formatDateTime:(NSString*)date;
@end
