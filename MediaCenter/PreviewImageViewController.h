//
//  PreviewImageViewController.h
//  MediaCenter
//
//  Created by aJia on 13/1/3.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewImageViewController : UIViewController<UIScrollViewDelegate>{
    int lastCurPage;
}
@property(nonatomic,retain) IBOutlet UIScrollView  *scrollView;
@property (retain, nonatomic) IBOutlet UINavigationItem *barbuttonBg;

@property(nonatomic,retain)  NSArray *listData;
@property(nonatomic,assign) int curPage;
- (IBAction)buttonCloseView:(id)sender;
- (IBAction)buttonPrevImage:(id)sender;
- (IBAction)buttonNextImage:(id)sender;
-(void)reloadScrollView;
-(UIImage*)autoImageSize:(UIImage*)img;

-(void)resetLocation;
-(void)resetImageLocation:(int)curImg;
@end
