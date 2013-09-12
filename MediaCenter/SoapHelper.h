//
//  SoapHelper.h
//  HttpRequest
//
//  Created by rang on 12-10-27.
//
//

#import <Foundation/Foundation.h>

@interface SoapHelper : NSObject
+(NSString*)defaultSoapMesage;
//生成soap信息
+(NSString*)SoapMessageMethod:(NSString*)methodName paramKey:(NSMutableArray*)key paramValue:(NSMutableArray*)value;
//表示传递的时xml参数
+(NSString*)SoapMsgXmlMethod:(NSString*)objectName paramKey:(NSMutableArray*)key paramValue:(NSMutableArray*)value;


+(NSString*)ArrayToXml:(NSMutableArray*)key valueArray:(NSMutableArray*)value isXmlString:(BOOL)isString;

+(NSString*)MethodSoapMessage:(NSString*)methodName;
+(NSString*)NameSpaceSoapMessage:(NSString*)space MethodName:(NSString*)methodName;
@end
