//
//  AnimateShowView.m
//  MediaCenter
//
//  Created by aJia on 13/9/11.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "AnimateShowView.h"

@interface AnimateShowView ()
-(void)loadControls;
-(void)animalTitle:(NSString*)title;
-(CGSize)CalculateStringSize:(NSString*)text font:(UIFont*)font with:(CGFloat)w;
@end

@implementation AnimateShowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadControls];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"text"])
    {
        if (![[change objectForKey:@"new"] isEqualToString:[change objectForKey:@"old"]]) {
            [self animalTitle:[change objectForKey:@"new"]];
        }
        
    }
}
#pragma mark private Methods
-(void)loadControls{
    if (!_labelTitle) {
        NSString *title=@"loading...";
        CGSize size=[self CalculateStringSize:title font:[UIFont boldSystemFontOfSize:14] with:self.window.bounds.size.width];
        
        _labelTitle=[[UILabel alloc] initWithFrame:CGRectMake(5,(40-size.height)/2.0, size.width, size.height)];
        _labelTitle.backgroundColor=[UIColor clearColor];
        _labelTitle.textColor=[UIColor whiteColor];
        _labelTitle.font=[UIFont boldSystemFontOfSize:14];
        _labelTitle.text=title;
        
        [self addSubview:_labelTitle];
        
        //kvo模式判断内容是否发生改变
        [_labelTitle addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        self.backgroundColor=[UIColor blackColor];
    }
    
}
-(CGSize)CalculateStringSize:(NSString*)text font:(UIFont*)font with:(CGFloat)w{
    CGSize textSize = [text sizeWithFont:font
                       constrainedToSize:CGSizeMake(w, CGFLOAT_MAX)
                           lineBreakMode:NSLineBreakByWordWrapping];
    return textSize;
}
-(void)animalTitle:(NSString*)title{
    if (_labelTitle) {
        CGSize size=[self CalculateStringSize:title font:[UIFont boldSystemFontOfSize:14] with:self.window.bounds.size.width];
        CGRect frame=_labelTitle.frame;
        frame.size=size;
        _labelTitle.frame=frame;
        _labelTitle.text=title;
    }
}

@end
