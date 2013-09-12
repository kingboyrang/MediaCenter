//
//  PreviewDataSource.h
//  MediaCenter
//
//  Created by aJia on 13/1/3.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>
@interface PreviewDataSource : NSObject<QLPreviewControllerDataSource>
@property(nonatomic,assign) BOOL isRoteUrl;
@property (nonatomic, copy) NSString *path;
@end
