//
//  News.m
//  MediaCenter
//
//  Created by rang on 12-11-23.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "News.h"
#import "GDataXMLNode.h"
#import "SoapXmlParseHelper.h"
@implementation News
+(NSString*)formatNewsDate:(NSString*)date{
    date=[date stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSRange range = [date  rangeOfString:@"." options:NSBackwardsSearch];
    if (range.location!=NSNotFound) {
        int pos=range.location;
        date=[date substringWithRange:NSMakeRange(0, pos)];
    }
    return date;
}
+(NSMutableArray*)XmlToArray:(NSString*)xml withMaxPage:(NSString**)page{
    NSMutableArray *array=[NSMutableArray array];
    NSError *error=nil;
    GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
    if (error) {
        [document release];
        *page=@"1";
        return array;
    }
    
    GDataXMLElement* rootNode = [document rootElement];
    NSArray *rootChilds=[rootNode children];
    for (GDataXMLNode *node in rootChilds){
        NSArray *arr=[node children];
        if ([arr count]>0) {
            for (GDataXMLNode *xmlnode in arr) {
                if ([xmlnode.name isEqualToString:@"Pager"]) {
                    //取得最大页数
                    
                    NSArray *pageArr=[xmlnode children];
                    for (GDataXMLNode *p in pageArr) {
                        if ([p.name isEqualToString:@"PageCount"]) {
                            *page=[p stringValue];
                            break;
                        }
                    }
                    
                }
            }
            
            
            //取得资料
            GDataXMLNode *newNode=[arr objectAtIndex:0];
            NSArray *childs=[newNode children];
            for (GDataXMLNode *item in childs) {
                if ([item.name isEqualToString:@"WebNews"]) {
                    [array addObject:[SoapXmlParseHelper ChildsNodeDictionary:item]];
                }
            }
        }
    }
    [document release];
    if (*page==nil) {
        *page=@"1";
    }
    return array;
}
@end
