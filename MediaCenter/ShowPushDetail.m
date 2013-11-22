//
//  ShowPushDetail.m
//  Eland
//
//  Created by aJia on 2013/11/22.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "ShowPushDetail.h"
#import "AlterMessage.h"
#import "UIColor+TPCategory.h"
@interface ShowPushDetail ()
-(NSString*)filterContent:(NSString*)str;
@end

@implementation ShowPushDetail

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.showsHorizontalScrollIndicator=NO;
        self.pagingEnabled=YES;
        self.autoresizesSubviews=YES;
        self.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.backgroundColor=[UIColor colorFromHexRGB:@"f4f4f4"];
        
        _label=[[RTLabel alloc] initWithFrame:self.bounds];
        _label.delegate=self;
        [self addSubview:_label];
    }
    return self;
}
-(NSString*)filterContent:(NSString*)str{
    NSString *emailRegEx =@"<url>(.*)</url>";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:emailRegEx
                                                                           options:0
                                                                             error:&error];

    
    NSString *searchResult=@"";
    if (regex != nil)
    {
        NSArray *array = [regex matchesInString: str
                                        options: 0
                                          range: NSMakeRange( 0, [str length])];
        if (array&&[array count]>0) {
            for (NSTextCheckingResult *match in array)
            {
                NSRange firstHalfRange = [match rangeAtIndex:0];
                searchResult=[str substringWithRange:firstHalfRange];
                break;
            }
        }
       
    }
    if ([searchResult length]>0) {
        NSString *urlString=[searchResult stringByReplacingOccurrencesOfString:@"<url>" withString:@""];
        urlString=[urlString stringByReplacingOccurrencesOfString:@"</url>" withString:@""];
        urlString=[NSString stringWithFormat:@"<a color='#666666' href='%@'>%@</a>",urlString,urlString];
        
        str=[str stringByReplacingOccurrencesOfString:searchResult withString:urlString];
    }
    return  str;
}
-(void)setTextContent:(NSString*)content{
    [_label setText:[self filterContent:content]];
    [self layoutSubviews];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGSize optimumSize = [_label optimumSize];
	CGRect frame =[_label frame];
	frame.size.height = (int)optimumSize.height + 5;
    frame.size.width=self.bounds.size.width;
	[_label setFrame:frame];
    [_label setNeedsDisplay];
    [self setContentSize:CGSizeMake(self.bounds.size.width, frame.size.height)];
}
#pragma mark -
#pragma mark RTLabelDelegate Methods
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url{
    [AlterMessage showConfirmAndCancel:@"提示" withMessage:@"是否前往瀏覽?" cancelMessage:@"取消" confirmMessage:@"確認" cancelAction:nil confirmAction:^{
         [[UIApplication sharedApplication] openURL:url];//使用浏览器打开
    }];
}

@end
