//
//  SoapHelper.m
//  HttpRequest
/****
 //SOAP Envelope
 GDataXMLElement *envelope = [GDataXMLElement elementWithName:@"soap:Envelope"];
 
 GDataXMLNode *soapNS = [GDataXMLNode namespaceWithName:@"soap" stringValue:@"http://schemas.xmlsoap.org/soap/envelope/"];
 GDataXMLNode *xsiNS = [GDataXMLNode namespaceWithName:@"xsi" stringValue:@"http://www.w3.org/2001/XMLSchema-instance"];
 GDataXMLNode *xsdNS = [GDataXMLNode namespaceWithName:@"xsd" stringValue:@"http://www.w3.org/2001/XMLSchema"];
 GDataXMLNode *defaultNS = [GDataXMLNode namespaceWithName:@"" stringValue:@"http://60.251.51.217/ElandMC.Admin/WebServices/"];
 
 NSArray *namespaces = [NSArray arrayWithObjects:xsiNS, xsdNS, soapNS, nil];
 [envelope setNamespaces:namespaces];
 
 //SOAP Body
 GDataXMLElement *body = [GDataXMLElement elementWithName:@"soap:Body"];
 
 //SOAP Value
 GDataXMLElement *value = [GDataXMLElement elementWithName:@"getProductAd"];
 [value addNamespace:defaultNS];
 [body addChild:value];
 
 [envelope addChild:body];
 
 //SOAP Document
 GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithRootElement:envelope];
 [doc setCharacterEncoding:@"utf-8"];
 
 NSLog(@"doc = %@", [NSString stringWithCString:(const char *)[[doc XMLData] bytes] encoding:NSUTF8StringEncoding]);
 [doc release];
 ****/

//  Created by rang on 12-10-27.
//
//

#import "SoapHelper.h"


@implementation SoapHelper
+(NSString*)defaultSoapMesage{
   NSString *soapBody=@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>%@</soap:Body></soap:Envelope>";
    return soapBody;
}
+(NSString*)MethodSoapMessage:(NSString*)methodName{
    NSMutableString *soap=[NSMutableString stringWithFormat:@"<%@ xmlns=\"%@\">",methodName,defaultWebServiceNameSpace];
    [soap appendString:@"%@"];
    [soap appendFormat:@"</%@>",methodName];
    return [NSString stringWithFormat:[self defaultSoapMesage],soap];
}
+(NSString*)NameSpaceSoapMessage:(NSString*)space MethodName:(NSString*)methodName{
    NSMutableString *soap=[NSMutableString stringWithFormat:@"<%@ xmlns=\"%@\">",methodName,space];
    [soap appendString:@"%@"];
    [soap appendFormat:@"</%@>",methodName];
    return [NSString stringWithFormat:[self defaultSoapMesage],soap];
}
+(NSString*)SoapMessageMethod:(NSString*)methodName paramKey:(NSMutableArray*)key paramValue:(NSMutableArray*)value{
   
    if (key==nil||[key count]==0) {
        return [NSString stringWithFormat:[self defaultSoapMesage],[NSString stringWithFormat:@"<%@ xmlns=\"%@\" />",methodName,defaultWebServiceNameSpace]];
    }
    
    NSMutableString *soapBody=[NSMutableString stringWithFormat:@""];
    [soapBody appendFormat:@"<%@ xmlns=\"%@\" >",methodName,defaultWebServiceNameSpace];
    [soapBody appendString:[self ArrayToXml:key valueArray:value isXmlString:YES]];
    [soapBody appendFormat:@"</%@>",methodName];
    return [NSString stringWithFormat:[self defaultSoapMesage],soapBody];
}
+(NSString*)SoapMsgXmlMethod:(NSString*)objectName paramKey:(NSMutableArray*)key paramValue:(NSMutableArray*)value{
   NSMutableString *soapBody=[NSMutableString stringWithFormat:@"&lt;?xml version=\"1.0\"?&gt;%@",@""];
    [soapBody appendFormat:@"&lt;%@ xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns=\"%@\"&gt;",objectName,objectName];
    [soapBody appendString:[self ArrayToXml:key valueArray:value isXmlString:NO]];
    [soapBody appendFormat:@"&lt;/%@&gt;",objectName];
    return [NSString stringWithFormat:@"%@",soapBody];
}

+(NSString*)ArrayToXml:(NSMutableArray*)key valueArray:(NSMutableArray*)value isXmlString:(BOOL)isString{
    NSMutableString *soapBody=[NSMutableString stringWithFormat:@""];
    NSString *startString=@"<%@>",*endString=@"</%@>";
    if (!isString) {
        startString=@"&lt;%@&gt;";
        endString=@"&lt/%@&gt;";
    }
    for (int i=0;i<[key count];i++) {
        [soapBody appendFormat:startString,[key objectAtIndex:i]];
        [soapBody appendString:[value objectAtIndex:i]];
        [soapBody appendFormat:endString,[key objectAtIndex:i]];
    }
    return [NSString stringWithFormat:@"%@",soapBody];

}

@end
