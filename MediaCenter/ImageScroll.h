//
//  ImageScroll.h
//  MediaCenter
//
//  Created by aJia on 12/11/21.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomizeImageView.h"
@protocol ImageScrollDelegate <NSObject>
@optional
-(void)stopImageScroll:(int)curImg;
-(void)currentClickImage:(int)curImg;
@end

@interface ImageScroll : UIView<ImageViewDelegate,UIScrollViewDelegate>{
   int curPage;
}
@property(nonatomic,assign) id<ImageScrollDelegate> delegate;
@property(nonatomic,retain)  UIScrollView *scrollView;
@property(nonatomic,retain)  NSArray *listData;
-(id)initWithData:(NSArray*)arr frame:(CGRect)frame;
-(void)loadConfigure:(CGRect)frame;
-(void)reloadScrollView;

//前一张图片
-(void)buttonPrevImg;
//下一张图片
-(void)buttonNextImg;
//图片等比缩放
-(UIImage*)autoImageSize:(UIImage*)img;
//-(void)stopScroll;
@end


