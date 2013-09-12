//
//  CustomizeImageView.h
//  MediaCenter
//
//  Created by aJia on 12/11/7.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ImageViewDelegate
@optional

-(void)imageTouch:(NSSet *)touches withEvent:(UIEvent *)event whichView:(id)imageView;

@end

@interface CustomizeImageView : UIImageView
@property (nonatomic,assign) BOOL isGature;
@property (nonatomic,assign) id<ImageViewDelegate> delegate;
@end
