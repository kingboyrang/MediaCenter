//
//  TKLabelCell.m
//  Created by Devin Ross on 7/1/09.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "TKLabelCell.h"
#import <QuartzCore/QuartzCore.h>
#define defaultLabelWith 100.0
@implementation TKLabelCell
@synthesize labelLeftWith;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;

    self.labelLeftWith=defaultLabelWith;
    _label = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, self.labelLeftWith, 44)];
	_label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentRight;
    _label.textColor = [UIColor grayColor];
    _label.font = [UIFont boldSystemFontOfSize:12.0];
	[self.contentView addSubview:_label];

   
    
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}
- (void)setLabelName:(NSString*)showname
{
    [self.label setText:showname];
}
- (void)setLabelName:(NSString*)title required:(BOOL)required
{
    NSString *content=[self labelName:title required:required];
    [self setLabelName:content];
}
/***
-(void)setLabelLeftWith:(CGFloat)width{
    self.labelLeftWith=width;
    CGRect frame = [self.label frame];
    frame.size.width=self.labelLeftWith;
    [self.label setFrame:frame];
}
 ***/
- (void) layoutSubviews {
    [super layoutSubviews];
	
    CGSize optimumSize = [self.label optimumSize];
	CGRect frame = [self.label frame];
	frame.size.height = (int)optimumSize.height + 5;
    frame.origin.y=(self.bounds.size.height-frame.size.height)/2.0;
	[self.label setFrame:frame];

}
-(NSString*)labelName:(NSString*)title required:(BOOL)required{
    NSString *showTitle=[NSString stringWithFormat:@"<font face='HelveticaNeue-CondensedBold' size=16 color='#666666'>%@</font>",title];
    NSString *requiredTitle=@"";
    if (required) {
        requiredTitle=@"<font size=16 color='#dd1100'>*</font>";
    }
    return [NSString stringWithFormat:@"%@%@",showTitle,requiredTitle];
}

- (void)shake {
    CAKeyframeAnimation *animationKey = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animationKey setDuration:0.5f];
    
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      nil];
    [animationKey setValues:array];
    [array release];
    
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:0.1f],
                      [NSNumber numberWithFloat:0.2f],
                      [NSNumber numberWithFloat:0.3f],
                      [NSNumber numberWithFloat:0.4f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.6f],
                      [NSNumber numberWithFloat:0.7f],
                      [NSNumber numberWithFloat:0.8f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f],
                      nil];
    [animationKey setKeyTimes:times];
    [times release];
    
    [self.layer addAnimation:animationKey forKey:@"CellTextFieldShake"];
}

-(NSString*)Trim:(NSString*)str{
    if (str) {
        //whitespaceAndNewlineCharacterSet 去除前后空格与回车
        //whitespaceCharacterSet 除前后空格
        return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return @"";
}
@end
