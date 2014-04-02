//
//  ServiceHelper.m
//  HttpRequest
//
//  Created by aJia on 2012/10/27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ServiceHelper.h"
#import "ASIHTTPRequest.h"
#import "SoapXmlParseHelper.h"
#import "NetWorkConnection.h"
#import "AlterMessage.h"
@implementation ServiceHelper
@synthesize delegate,httpRequest;
/***
-(id)init{
    if (self=[super init]) {
        theRequest=[[ASIHTTPRequest alloc] init];
    }
    return self;
}
  ***/
+(ASIHTTPRequest*)SharedRequestMethod:(NSString*)methodName SoapMessage:(NSString*)soap{
    NSURL *webUrl=[NSURL URLWithString:defaultWebServiceUrl];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:webUrl];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soap length]];
	
    //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
	[request addRequestHeader:@"Host" value:[webUrl host]];
    //[request addRequestHeader:@"Content-Type" value:@"application/soap+xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
	[request addRequestHeader:@"Content-Length" value:msgLength];
    [request addRequestHeader:@"SOAPAction" value:[NSString stringWithFormat:@"%@%@",defaultWebServiceNameSpace,methodName]];
    [request setRequestMethod:@"POST"];
	//传soap信息
    [request appendPostData:[soap dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValidatesSecureCertificate:NO];
    [request setTimeOutSeconds:20.0];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    return request;

}
-(id)initWithDelegate:(id<ServiceHelperDelegate>)theDelegate
{
	if (self=[super init]) {
		self.delegate=theDelegate;
        //self.httpRequest=[[ASIHTTPRequest alloc] init];
        //theRequest=[[ASIHTTPRequest alloc] init];
	}
	return self;
}
-(ASIHTTPRequest*)requestCommonService:(NSString*)url ServiceNameSpace:(NSString*)nameSapce ServiceMethodName:(NSString*)strMethod SoapMessage:(NSString*)soap{
    NSURL *webUrl=[NSURL URLWithString:url];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:webUrl];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soap length]];
	
    //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
	[request addRequestHeader:@"Host" value:webUrl.host&&[webUrl.host length]>0?webUrl.host:@""];
    //[request addRequestHeader:@"Content-Type" value:@"application/soap+xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
	[request addRequestHeader:@"Content-Length" value:msgLength];
    [request addRequestHeader:@"SOAPAction" value:[NSString stringWithFormat:@"%@%@",nameSapce,strMethod]];
    [request setRequestMethod:@"POST"];
	//传soap信息
    [request appendPostData:[soap dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValidatesSecureCertificate:NO];
    [request setTimeOutSeconds:20.0];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    return request;

}
-(ASIHTTPRequest*)requestMethodName:(NSString*)methodName SoapMessage:(NSString*)soap{
    return [self requestServiceUrl:defaultWebServiceUrl ServiceMethodName:methodName SoapMessage:soap];
}
-(ASIHTTPRequest*)requestServiceUrl:(NSString*)url ServiceMethodName:(NSString*)methodName SoapMessage:(NSString*)soap{
    
    return [self requestCommonService:url ServiceNameSpace:defaultWebServiceNameSpace ServiceMethodName:methodName SoapMessage:soap];
}

#pragma -
#pragma 同步请求
-(NSString*)SysServiceUrl:(NSString*)strUrl ServiceMethodName:(NSString*)strMethod SoapMessage:(NSString*)soap
{
    return [self SysServiceNameSpace:strUrl NameSpace:defaultWebServiceNameSpace ServiceMethodName:strMethod SoapMessage:soap];
}
-(NSString*)SysServiceMethod:(NSString*)methodName SoapMessage:(NSString*)soapMsg
{
	return [self SysServiceUrl:defaultWebServiceUrl ServiceMethodName:methodName SoapMessage:soapMsg];
}
-(NSString*)SysServiceNameSpace:(NSString*)strUrl NameSpace:(NSString*)nameSpace ServiceMethodName:(NSString*)strMethod SoapMessage:(NSString*)soap{
    ASIHTTPRequest *request=[self requestCommonService:strUrl ServiceNameSpace:nameSpace ServiceMethodName:strMethod SoapMessage:soap];
    [request startSynchronous];
	NSError *error=[request error];
    int statusCode = [request responseStatusCode];
    if (error||statusCode!=200) {
        return @"";
    }
	return [SoapXmlParseHelper SoapMessageResultXml:[request responseString] ServiceMethodName:strMethod];
}
#pragma -
#pragma 异步请求
-(void)AsyCommonServiceRequest:(NSString*)WebURL ServiceNameSpace:(NSString*)nameSapce ServiceMethodName:(NSString*)strMethod SoapMessage:(NSString*)soapMsg
{
   
   
    //请求发送到的路径
    [self.httpRequest setDelegate:nil];
    [self.httpRequest cancel];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", WebURL]];
    
	//[httpRequest setURL:url];

    [self setHttpRequest:[ASIHTTPRequest requestWithURL:url]];
   //ASIHTTPRequest *httpRequest= [ASIHTTPRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
	
    //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
	[self.httpRequest addRequestHeader:@"Host" value:url.host&&[url.host length]>0?url.host:@""];
    //[self.httpRequest addRequestHeader:@"Content-Type" value:@"application/soap+xml; charset=utf-8"];
    [self.httpRequest addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
	[self.httpRequest addRequestHeader:@"Content-Length" value:msgLength];
    [self.httpRequest addRequestHeader:@"SOAPAction" value:[NSString stringWithFormat:@"%@%@",nameSapce,strMethod]];
    [self.httpRequest setRequestMethod:@"POST"];
	//传soap信息
    [self.httpRequest appendPostData:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    [self.httpRequest setValidatesSecureCertificate:NO];
    [self.httpRequest setTimeOutSeconds:20.0];
    [self.httpRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    [self.httpRequest setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:strMethod,@"name", nil]];
    [self.httpRequest setDelegate:self];
	[self.httpRequest startAsynchronous];//异步请求
}
-(void)ServiceRequestUrl:(NSString*)WebURL ServiceMethodName:(NSString*)strMethod SoapMessage:(NSString*)soapMsg{
    [self AsyCommonServiceRequest:WebURL ServiceNameSpace:defaultWebServiceNameSpace ServiceMethodName:strMethod SoapMessage:soapMsg];
    
}
-(void)AsyServiceUrl:(NSString*)strUrl ServiceMethodName:(NSString*)strMethod SoapMessage:(NSString*)soap
{
	[self ServiceRequestUrl:strUrl ServiceMethodName:strMethod SoapMessage:soap];
	//theRequest.delegate=self;
}
-(void)AsyServiceMethod:(NSString*)methodName SoapMessage:(NSString*)soapMsg{
	[self AsyServiceUrl:defaultWebServiceUrl ServiceMethodName:methodName SoapMessage:soapMsg];
}
#pragma mark -
#pragma mark ASIHTTPRequest delegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    int statusCode = [request responseStatusCode];
	NSString *soapAction=[[request requestHeaders] objectForKey:@"SOAPAction"];
    
    NSString *methodName=@"";
    NSRange range = [soapAction  rangeOfString:@"/" options:NSBackwardsSearch];
    if(range.location!=NSNotFound){
        int pos=range.location;
        methodName=[soapAction stringByReplacingCharactersInRange:NSMakeRange(0, pos+1) withString:@""];
    }
	// Use when fetching text data
	NSString *responseString = [request responseString];
	NSString *result=@"";
    NSData *responseData = [request responseData];
    if (statusCode==200) {//表示正常请求
        result=[SoapXmlParseHelper SoapMessageResultXml:responseString ServiceMethodName:methodName];
    }
    [self.delegate finishSuccessRequest:result responseData:responseData];
	
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	[self.delegate finishFailRequest:error];
	
}
-(void)dealloc{
    [httpRequest setDelegate:nil];
    [httpRequest cancel];
    [httpRequest release];
   	[super dealloc];
   
    /***
    if (theRequest) {
        [theRequest clearDelegatesAndCancel];
    }
	***/
	//[theRequest release];
	
}
@end
