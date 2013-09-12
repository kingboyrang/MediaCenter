//
//  HotMetaDataCell.h
//  MediaCenter
//
//  Created by aJia on 12/11/22.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotMetaData.h"
#import "CustomizeImageView.h"

@protocol HotMetaDataDelegate <NSObject>
-(void)HotMetaDataDetail:(NSSet *)touches withEvent:(UIEvent *)event whichView:(id)which;
@end

@interface HotMetaDataCell : UIView<ImageViewDelegate>{
    CGRect orginRect;
}
@property(nonatomic,assign) id<HotMetaDataDelegate> delegate;
@property(nonatomic,retain) HotMetaData *metaData;
-(id)initWithData:(HotMetaData*)hot withFrame:(CGRect)frame;
-(void)loadConfigure;
@end
