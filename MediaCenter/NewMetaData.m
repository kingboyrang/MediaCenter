//
//  NewMetaData.m
//  MediaCenter
//
//  Created by aJia on 12/11/22.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "NewMetaData.h"
#import "GDataXMLNode.h"
#import "SoapXmlParseHelper.h"
@implementation NewMetaData
+(NSMutableArray*)XmlToArray:(NSString*)xml{
    NSMutableArray *array=[NSMutableArray array];
    NSError *error=nil;
    GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
    if (error) {
        [document release];
        return array;
    }
    GDataXMLElement* rootNode = [document rootElement];
    NSArray *childs=[rootNode nodesForXPath:@"//NewMetaData" error:nil];
    for (GDataXMLNode *sub in childs) {
        if ([sub.name isEqualToString:@"NewMetaData"]) {
            [array addObject:[SoapXmlParseHelper ChildsNodeDictionary:sub]];
        }
    }
    [document release];
    return array;
}
@end
