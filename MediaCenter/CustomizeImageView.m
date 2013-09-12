//
//  CustomizeImageView.m
//  MediaCenter
//
//  Created by aJia on 12/11/7.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "CustomizeImageView.h"

@implementation CustomizeImageView
@synthesize delegate,isGature;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled=YES;
       
    }
    return self;
}
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"delegate:%@",self.delegate);
    if (self.isGature){
      [self.delegate imageTouch:touches withEvent:event whichView:self];
    }
    //[self.delegate TouchesBegin:self.tag];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
