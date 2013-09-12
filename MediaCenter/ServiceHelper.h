//
//  ServiceHelper.h
//  HttpRequest
//
//  Created by aJia on 2012/10/27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASIHTTPRequest;
@protocol ServiceHelperDelegate
@optional
-(void)finishSuccessRequest:(NSString*)responseText responseData:(NSData*)requestData;
-(void)finishFailRequest:(NSError*)error;
@end

@interface ServiceHelper : NSObject{
    
}
@property(nonatomic,retain) ASIHTTPRequest *httpRequest;
@property(nonatomic,assign) id<ServiceHelperDelegate> delegate;
//初始化
-(id)initWithDelegate:(id<ServiceHelperDelegate>)theDelegate;
//创建请求对象
-(void)ServiceRequestUrl:(NSString*)strUrl ServiceMethodName:(NSString*)strMethod SoapMessage:(NSString*)soap;
//同步请求

-(NSString*)SysServiceMethod:(NSString*)methodName SoapMessage:(NSString*)soapMsg;
-(NSString*)SysServiceUrl:(NSString*)strUrl ServiceMethodName:(NSString*)strMethod SoapMessage:(NSString*)soap;
-(NSString*)SysServiceNameSpace:(NSString*)strUrl NameSpace:(NSString*)nameSpace ServiceMethodName:(NSString*)strMethod SoapMessage:(NSString*)soap;
//异步请求
-(void)AsyCommonServiceRequest:(NSString*)url ServiceNameSpace:(NSString*)nameSapce ServiceMethodName:(NSString*)strMethod SoapMessage:(NSString*)soap;
-(void)AsyServiceUrl:(NSString*)strUrl ServiceMethodName:(NSString*)strMethod SoapMessage:(NSString*)soap;
-(void)AsyServiceMethod:(NSString*)methodName SoapMessage:(NSString*)soapMsg;
//获取ASIHTTPRequest
-(ASIHTTPRequest*)requestMethodName:(NSString*)methodName SoapMessage:(NSString*)soap;
-(ASIHTTPRequest*)requestServiceUrl:(NSString*)url ServiceMethodName:(NSString*)methodName SoapMessage:(NSString*)soap;
-(ASIHTTPRequest*)requestCommonService:(NSString*)url ServiceNameSpace:(NSString*)nameSapce ServiceMethodName:(NSString*)strMethod SoapMessage:(NSString*)soap;
+(ASIHTTPRequest*)SharedRequestMethod:(NSString*)methodName SoapMessage:(NSString*)soap;

@end
