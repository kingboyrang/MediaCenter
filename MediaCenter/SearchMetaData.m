//
//  SearchMetaData.m
//  MediaCenter
//
//  Created by aJia on 12/11/21.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "SearchMetaData.h"
#import "GDataXMLNode.h"
#import "SoapXmlParseHelper.h"
@implementation SearchMetaData
+(NSString*)formatImageUrl:(NSString*)url{
    url=[url stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    return url;
}
+(NSMutableArray*)XmlToObject:(NSString*)xml withClassName:(NSString*)className withMaxPage:(NSString**)page
{
    NSMutableArray *array=[NSMutableArray array];
    NSError *error=nil;
    GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
    if (error) {
        [document release];
        *page=@"1";
        return array;
    }
    GDataXMLElement* rootNode = [document rootElement];
    NSArray *childs=[rootNode nodesForXPath:@"//SearchMetaData" error:nil];
    for (GDataXMLNode *sub in childs) {
        if ([sub.name isEqualToString:@"SearchMetaData"]) {
            [array addObject:[SoapXmlParseHelper ChildsToObject:sub withClassName:className]];
        }
    }
    NSArray *pageArr=[rootNode nodesForXPath:@"//PageCount" error:nil];
    if ([pageArr count]>0) {
         *page=[[pageArr objectAtIndex:0] stringValue];
    }
    [document release];
    return array;
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
                if ([item.name isEqualToString:@"SearchMetaData"]) {
                    [array addObject:[SoapXmlParseHelper ChildsNodeDictionary:item]];
                }
            }
        }
    }
    [document release];
    return array;
}
//NSRange range = [url  rangeOfString:@"/" options:NSBackwardsSearch];
@end
