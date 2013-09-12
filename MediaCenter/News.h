//
//  News.h
//  MediaCenter
//
//  Created by rang on 12-11-23.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject
+(NSString*)formatNewsDate:(NSString*)date;
+(NSMutableArray*)XmlToArray:(NSString*)xml withMaxPage:(NSString**)page;
@end
