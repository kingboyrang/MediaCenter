//
//  HotMetaData.m
//  MediaCenter
//
//  Created by aJia on 12/11/22.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "HotMetaData.h"
#import "GDataXMLNode.h"
#import "SoapXmlParseHelper.h"
@implementation HotMetaData

@synthesize VisitCount;
+(NSMutableArray*)XmlToHotMetaData:(NSString*)xml{
    NSMutableArray *array=[NSMutableArray array];
    NSError *error=nil;
    GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
    if (error) {
        [document release];
        return array;
    }
    GDataXMLElement* rootNode = [document rootElement];
    NSArray *childs=[rootNode nodesForXPath:@"//HotMetaData" error:nil];
    for (GDataXMLNode *sub in childs) {
        if ([sub.name isEqualToString:@"HotMetaData"]) {
            [array addObject:[SoapXmlParseHelper ChildsToObject:sub withClassName:@"HotMetaData"]];
        }
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
    NSArray *childs=[rootNode nodesForXPath:@"//HotMetaData" error:nil];
    for (GDataXMLNode *sub in childs) {
            [array addObject:[SoapXmlParseHelper ChildsNodeDictionary:sub]];
    }
             NSArray *pageArr=[rootNode nodesForXPath:@"//Pager" error:nil];
             for (GDataXMLNode *p in pageArr) {
                 if ([p.name isEqualToString:@"PageCount"]) {
                     *page=[p stringValue];
                     break;
                 }
             }

    
   
    [document release];
    return array;
}
@end
