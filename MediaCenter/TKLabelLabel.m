//
//  TKLabelLabel.m
//  MediaCenter
//
//  Created by aJia on 13/9/26.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "TKLabelLabel.h"

@implementation TKLabelLabel

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
   
        _detail = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, self.labelLeftWith, 44)];
        _detail.backgroundColor = [UIColor clearColor];
        _detail.textAlignment = NSTextAlignmentLeft;
        _detail.textColor = [UIColor grayColor];
        _detail.font = [UIFont boldSystemFontOfSize:12.0];
        [self.contentView addSubview:_detail];

   
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self=[self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGSize optimumSize = [self.label optimumSize];
	
	CGRect r = CGRectInset(self.contentView.bounds, 8, 8);
	r.origin.x += self.label.frame.size.width + 6;
    r.size.height =(int)optimumSize.height + 5;
	r.size.width -= self.label.frame.size.width + 6;
	_detail.frame = r;
    
   
	
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
