//
//  UIImageView+DispatchLoad.h
//  MediaCenter
//
//  Created by aJia on 13/1/4.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (DispatchLoad)
- (void) setImageFromUrl:(NSString*)urlString;
- (void) setImageFromUrl:(NSString*)urlString
              completion:(void (^)(void))completion;
//等比缩放
-(CGSize)autoZoomSize:(CGSize)defautSize orginSize:(CGSize)size;
@end
