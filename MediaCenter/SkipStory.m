//
//  SkipStory.m
//  MediaCenter
//
//  Created by rang on 12-11-7.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "SkipStory.h"

@implementation SkipStory
-(void)perform{
    UIViewController *current = self.sourceViewController;
    //UIViewController *next = self.destinationViewController;
    //[current.navigationController pushViewController:next animated:YES];
    //NSLog(@"class=%@\n",[current class]);
    [current.navigationController popViewControllerAnimated:YES];
}
@end
