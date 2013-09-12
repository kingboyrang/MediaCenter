//
//  XmlParseHelper.m
//  HttpRequest
//
//  Created by rang on 12-11-10.
//
//

#import "SoapXmlParseHelper.h"
#import "GDataXMLNode.h"

@implementation SoapXmlParseHelper
+(BOOL)isKindOfStringOrData:(id)xml{
    if ([xml isKindOfClass:[NSString class]]||[xml isKindOfClass:[NSData class]]) {
        return YES;
    }
    return NO;
}
+(NSString*)SoapMessageResultXml:(id)data ServiceMethodName:(NSString*)methodName{
    
    
    NSError *error=nil;
    GDataXMLDocument *document;
    if ([data isKindOfClass:[NSString class]]) {
        document=[[GDataXMLDocument alloc] initWithXMLString:data options:0 error:&error];
    }else{
        document=[[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    }
    if (error) {
        [document release];
        return @"";
    }
    GDataXMLElement* rootNode = [document rootElement];
    NSString *searchStr=[NSString stringWithFormat:@"%@Result",methodName];
   NSString *MsgResult=@"";
    NSArray *result=[rootNode children];
    while ([result count]>0) {
        NSString *nodeName=[[result objectAtIndex:0] name];
        if ([nodeName isEqualToString: searchStr]) {
            MsgResult=[[result objectAtIndex:0] stringValue];
            break;
        }
        result=[[result objectAtIndex:0] children];
    }
    [document release];
    return MsgResult;
}
+(NSMutableArray*)XmlToArray:(id)xml{
    NSMutableArray *arr=[NSMutableArray array];
    if (![self isKindOfStringOrData:xml]) {
        return arr;
    }
    NSError *error=nil;
    GDataXMLDocument *document;
    if ([xml isKindOfClass:[NSString class]]) {
        document=[[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
    }
    else
       document=[[GDataXMLDocument alloc] initWithData:xml options:0 error:&error];
    if (error) {
        [document release];
        return arr;
    }
    GDataXMLElement* rootNode = [document rootElement];
    NSArray *rootChilds=[rootNode children];
    for (GDataXMLNode *node in rootChilds) {
        NSString *nodeName=node.name;
        if ([node.children count]>0) {
            [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[self nodeChilds:node],nodeName, nil]];
        }else{
            [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[node stringValue],nodeName, nil]];
        }
    }
    [document release];
    return arr;
}
+(NSMutableArray*)nodeChilds:(GDataXMLNode*)node{
    NSMutableArray *arr=[NSMutableArray array];
    NSArray *childs=[node children];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    for (GDataXMLNode* child in childs){
        NSString *nodeName=child.name;//获取节点名称
        NSArray  *childNode=[child children];
        if ([childNode count]>0) {//存在子节点
            [dic setValue:[self nodeChilds:child] forKey:nodeName];
        }else{
            [dic setValue:[child stringValue] forKey:nodeName];
        }
    }
    [arr addObject:dic];
    return arr;
}
+(NSMutableDictionary*)ChildsNodeDictionary:(GDataXMLNode*)node{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    NSArray *childs=[node children];
    for (GDataXMLNode *item in childs) {
        [dic setValue:[item stringValue] forKey:item.name];
    }
    return dic;
}
+(id)ChildsToObject:(GDataXMLNode*)node withClassName:(NSString*)className{
    id hot=[[NSClassFromString(className) alloc] init];
     NSArray *childs=[node children];
    for (GDataXMLNode *item in childs){
        SEL sel=NSSelectorFromString(item.name);
        if ([hot respondsToSelector:sel]) {
            [hot setValue:[item stringValue] forKey:item.name];
        }
    }
    return [hot autorelease];
}
+(NSArray*)ChildsRootNodeArray:(NSString*)xml{
    NSArray *arr=[NSArray array];
    NSError *error=nil;
    GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
    if (error) {
        [document release];
        return arr;
    }
    GDataXMLElement* rootNode = [document rootElement];
    arr=[rootNode children];
    [document release];
    return arr;
}
+(NSMutableArray*)TwoLevelXmlToArray:(NSString*)xml{
    NSMutableArray *arr=[NSMutableArray array];
    NSError *error=nil;
    GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
    if (error) {
        [document release];
        return arr;
    }
    GDataXMLElement* rootNode = [document rootElement];
    NSArray *rootChilds=[rootNode children];
    for (GDataXMLNode *node in rootChilds){
        [arr addObject:[self ChildsNodeDictionary:node]];
    }
    [document release];
    return arr;
}
+(NSMutableArray*)XmlOjbectToArray:(NSString*)xml ClassName:(NSString*)name{
    NSMutableArray *arr=[NSMutableArray array];
    NSError *error=nil;
    GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
    if (error) {
        [document release];
        return arr;
    }
    GDataXMLElement* rootNode = [document rootElement];
    NSArray *rootChilds=[rootNode children];
    for (GDataXMLNode *node in rootChilds){
        //[arr addObject:[self ChildsNodeDictionary:node]];
        id obj=[[NSClassFromString(name) alloc] init];
        NSArray *nodechilds=[node children];
        for (GDataXMLNode *item in nodechilds) {
            SEL sel=NSSelectorFromString(item.name);
            if ([obj respondsToSelector:sel]) {
                [obj setValue:[item stringValue] forKey:item.name];
                //[obj performSelector:sel withObject:[item stringValue]];
            }
        }
        [arr addObject:obj];
        [obj release];
    }
   // NSLog(@"result=%@\n",arr);
    [document release];
    return arr;
}
+(NSMutableArray*)DataTableToArray:(id)data{
    NSMutableArray *array=[NSMutableArray array];
    //xml=[xml stringByReplacingOccurrencesOfString:@"utf-16" withString:@"utf-8"];
    NSError *error=nil;
    GDataXMLDocument *document;
    if ([data isKindOfClass:[NSString class]]) {
        document=[[GDataXMLDocument alloc] initWithXMLString:data options:0 error:&error];
    }else{
        document=[[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    }
    if (error) {
        [document release];
        return array;
    }
    GDataXMLElement* rootNode = [document rootElement];
    NSArray *rootChilds=[rootNode children];
    for (GDataXMLNode *node in rootChilds){
        NSArray *arr=[node children];
        if ([arr count]>0) {
            GDataXMLNode *newNode=[arr objectAtIndex:0];
            NSArray *childs=[newNode children];
            for (GDataXMLNode *item in childs) {
                if ([item.name isEqualToString:@"xs:complexType"]) {
                    continue;
                }
                //NSLog(@"nodename=%@\n",item.name);
                [array addObject:[self ChildsNodeDictionary:item]];
            }
            
        }
    }
    [document release];
    return array;
}
+(NSMutableArray*)SearchNodeToArray:(id)data NodeName:(NSString*)nodeName{
    NSMutableArray *array=[NSMutableArray array];
    NSError *error=nil;
    GDataXMLDocument *document;
    if ([data isKindOfClass:[NSString class]]) {
        document=[[GDataXMLDocument alloc] initWithXMLString:data options:0 error:&error];
    }else{
        document=[[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    }
    if (error) {
        [document release];
        return array;
    }
    NSString *searchStr=[NSString stringWithFormat:@"//%@",nodeName];
    GDataXMLElement* rootNode = [document rootElement];
    NSArray *childs=[rootNode nodesForXPath:searchStr error:nil];
    for (GDataXMLNode *item in childs){
        [array addObject:[self ChildsNodeDictionary:item]];
    }
    [document release];
    return array;
}
@end
