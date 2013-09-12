//
//  PreviewDataSource.m
//  MediaCenter
//
//  Created by aJia on 13/1/3.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "PreviewDataSource.h"

@implementation PreviewDataSource
@synthesize path,isRoteUrl;
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}
- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    if (self.isRoteUrl) {
        return [NSURL URLWithString:self.path];
    }
    return [NSURL fileURLWithPath:self.path];
}
- (void)dealloc {
    [path release];
    [super dealloc];
}
@end
