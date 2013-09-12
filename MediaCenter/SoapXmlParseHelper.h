//
//  XmlParseHelper.h
//  HttpRequest
//
//  Created by rang on 12-11-10.
//
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface SoapXmlParseHelper : NSObject

//获取webservice调用返回的xml内容
+(NSString*)SoapMessageResultXml:(id)xml ServiceMethodName:(NSString*)methodName;
//xml转换成Array
+(NSMutableArray*)XmlToArray:(id)xml;
+(NSMutableArray*)nodeChilds:(GDataXMLNode*)node;
//判断xml是否为NSData或NSString
+(BOOL)isKindOfStringOrData:(id)xml;

//获取节点下，子节点的所有内容
+(NSMutableDictionary*)ChildsNodeDictionary:(GDataXMLNode*)node;
//将某个节电内容转换成对象
+(id)ChildsToObject:(GDataXMLNode*)node withClassName:(NSString*)className;

//获取根节点下的子节点
+(NSArray*)ChildsRootNodeArray:(NSString*)xml;

//获取只有两层的xml转换成数组
+(NSMutableArray*)TwoLevelXmlToArray:(NSString*)xml;
+(NSMutableArray*)XmlOjbectToArray:(NSString*)xml ClassName:(NSString*)name;

//DataTableToArray
+(NSMutableArray*)DataTableToArray:(id)data;
//查找指定节点保存到数组中
+(NSMutableArray*)SearchNodeToArray:(id)data NodeName:(NSString*)nodeName;
@end
