//
//  CommonCell.h
//  MediaCenter
//
//  Created by aJia on 12/12/1.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonCell : UIView{
    CGRect orginRect;
}
@property(nonatomic,retain) NSDictionary *ItemData;
-(id)initWithData:(NSDictionary*)dic withFrame:(CGRect)frame;
-(void)loadConfigure;
-(NSString*)formatDateTime:(NSString*)date;
@end
