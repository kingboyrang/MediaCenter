//
//  MediaSoapMessage.m
//  MediaCenter
//
//  Created by rang on 12-11-20.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "MediaSoapMessage.h"
#import "SoapHelper.h"
@implementation MediaSoapMessage
/****公有查询
 Category:1:幸福宜蘭; 2:熱門影音; 3:最新影音;
 KeyWord:关键字
 withCurPage:当前页
 withCurSize:每页显示数量
 *****/
+(NSString*)CategorySearchMetaData:(NSString*)Category classCode:(NSString*)code KeyWord:(NSString*)keyword withCurPage:(int)curPage withCurSize:(int)pageSize{
    NSString *soap=[SoapHelper MethodSoapMessage:@"CategorySearchMetaData"];
    NSMutableString *body=[NSMutableString stringWithFormat:@""];
    [body appendFormat:@"<category>%@</category>",Category];
    [body appendFormat:@"<classcode>%@</classcode>",code];
    [body appendFormat:@"<keywork>%@</keywork>",keyword];
    [body appendFormat:@"<curPage>%d</curPage>",curPage];
    [body appendFormat:@"<pageSize>%d</pageSize>",pageSize];
    return [NSString stringWithFormat:soap,body];
    
}
/**幸福宜蘭***
 KeyWord:关键字
 classCode:分类别代码
 withCurPage:当前页
 withCurSize:每页显示数量
 ***/
+(NSString*)HappyElandSoap:(NSString*)keyword classCode:(NSString*)code withCurPage:(int)curPage withCurSize:(int)pageSize{
    return [self CategorySearchMetaData:@"1" classCode:code KeyWord:keyword withCurPage:curPage withCurSize:pageSize];
}
/**熱門影音***
 KeyWord:关键字
 withCurPage:当前页
 withCurSize:每页显示数量
 ***/
+(NSString*)HotMovieSoap:(NSString*)keyword withCurPage:(int)curPage withCurSize:(int)pageSize{
  return [self CategorySearchMetaData:@"2" classCode:@"" KeyWord:keyword withCurPage:curPage withCurSize:pageSize];
}
/**最新影音***
 KeyWord:关键字
 withCurPage:当前页
 withCurSize:每页显示数量
 ***/
+(NSString*)NewMovieSoap:(NSString*)keyword withCurPage:(int)curPage withCurSize:(int)pageSize{
   return [self CategorySearchMetaData:@"3" classCode:@"" KeyWord:keyword withCurPage:curPage withCurSize:pageSize];
}

/**县长专区***
 KeyWord:关键字
 withCurPage:当前页
 withCurSize:每页显示数量
 ***/
+(NSString*)DistrictMovieSoap:(NSString*)keyword withCurPage:(int)curPage withCurSize:(int)pageSize{
 return [self CategorySearchMetaData:@"4" classCode:@"" KeyWord:keyword withCurPage:curPage withCurSize:pageSize];
}
/**数位出版品***
 KeyWord:关键字
 withCurPage:当前页
 withCurSize:每页显示数量
 ***/
+(NSString*)EbookMovieSoap:(NSString*)keyword withCurPage:(int)curPage withCurSize:(int)pageSize{
 return [self CategorySearchMetaData:@"5" classCode:@"" KeyWord:keyword withCurPage:curPage withCurSize:pageSize];
}

/**福利专区***
 KeyWord:关键字
 withCurPage:当前页
 withCurSize:每页显示数量
 ***/
+(NSString*)BenfitMovieSoap:(NSString*)keyword withCurPage:(int)curPage withCurSize:(int)pageSize{
 return [self CategorySearchMetaData:@"6" classCode:@"" KeyWord:keyword withCurPage:curPage withCurSize:pageSize];
}

/****
 **获取机关类别
 ***/
+(NSString*)OrgenTypeSoap{
    return [NSString stringWithFormat:[SoapHelper defaultSoapMesage],@"<GetFirstDeptList xmlns=\"http://tempuri.org/\" />"];
}
/**最新消息**
 type:2:县政消息 1.县政活动 3.最新消息
 withCurPage:当前页
 withCurSize:每页显示数量
 ****/
+(NSString*)WebNewsByTypeSoap:(NSString*)type withCurPage:(int)curPage withCurSize:(int)pageSize;
{
    NSString *soap=[SoapHelper MethodSoapMessage:@"GetWebNewsByType"];
    NSMutableString *body=[NSMutableString stringWithFormat:@""];
    [body appendFormat:@"<type>%@</type>",type];
    [body appendFormat:@"<curPage>%d</curPage>",curPage];
    [body appendFormat:@"<pageSize>%d</pageSize>",pageSize];
    return [NSString stringWithFormat:soap,body];

}
/****获取分类别soap****/
+(NSString*)CategoryListSoap{
    NSString *soap=[SoapHelper defaultSoapMesage];
    NSString *body=[NSString stringWithFormat:@"<GetCategoryList xmlns=\"%@\" />",defaultWebServiceNameSpace];
    return [NSString stringWithFormat:soap,body];
}

+(NSString*)NewMetaDataSoap{
    NSString *soap=[SoapHelper MethodSoapMessage:@"GetNewMetaData"];
    return [NSString stringWithFormat:soap,@"<topN>20</topN>"];
}
+(NSString*)SubMetaListSoap:(NSString*)metaPK{
  NSString *soap=[SoapHelper MethodSoapMessage:@"GetSubMetaList"];
    NSString *body=[NSString stringWithFormat:@"<metaPK>%@</metaPK>",metaPK];
    return [NSString stringWithFormat:soap,body];
}
+(NSString*)SearchMetaDataSoap:(NSString*)keyword withCurPage:(int)curPage withCurSize:(int)pageSize{
    NSString *soap=[SoapHelper MethodSoapMessage:@"SearchMetaData"];
    NSMutableString *msg=[NSMutableString stringWithFormat:@""];
    [msg appendFormat:@"<keywork>%@</keywork>",keyword];
    [msg appendFormat:@"<curPage>%d</curPage>",curPage];
    [msg appendFormat:@"<pageSize>%d</pageSize>",pageSize];
    return [NSString stringWithFormat:soap,msg];
}

+(NSString*)HotMetaDataSoap{
    NSString *soap=[SoapHelper MethodSoapMessage:@"GetHotMetaData"];
    return [NSString stringWithFormat:soap,@"<topN>20</topN>"];
}
+(NSString*)PublishMetaDataSoap{
    NSString *soap=[SoapHelper MethodSoapMessage:@"GetPublishMetaData"];
    return [NSString stringWithFormat:soap,@"<topN>20</topN>"];
}
+(NSString*)MetaDataByDeptSoap:(NSString*)topDept childDept:(NSString*)childDept{
  NSString *soap=[SoapHelper MethodSoapMessage:@"GetMetaDataByDept"];
    NSString *param1=[NSString stringWithFormat:@"<topDept>%@</topDept><childDept>%@</childDept>",topDept,childDept];
    /***
     <TopDept>string</TopDept>
     <ChildDept>string</ChildDept>
     ***/
    return [NSString stringWithFormat:soap,param1];
}

+(NSString*)GCMRegisterSoap:(NSString*)token  AppCode:(NSString*)code{
    NSString *soap=[SoapHelper NameSpaceSoapMessage:PushWebServiceNameSpace MethodName:@"Register"];
    NSString *body=[NSString stringWithFormat:@"<token>%@</token><appName>ios.app.elandmc.mdc</appName><appCode>%@</appCode>",token,code];
    /***
     <token>string</token>
     <appName>string</appName>
     <appCode>string</appCode>
     ***/
    return [NSString stringWithFormat:soap,body];
}
+(NSString*)GCMUnRegisterSoap:(NSString*)token{
    NSString *soap=[SoapHelper NameSpaceSoapMessage:PushWebServiceNameSpace MethodName:@"GCMUnRegister"];
    NSString *body=[NSString stringWithFormat:@"<token>%@</token>",token];
    return [NSString stringWithFormat:soap,body];
}
+(NSString*)PushInfoSoap:(NSString*)guid{
    NSString *soap=[SoapHelper NameSpaceSoapMessage:PushWebServiceNameSpace MethodName:@"GetPushInfo"];
    NSString *body=[NSString stringWithFormat:@"<guid>%@</guid>",guid];
    return [NSString stringWithFormat:soap,body];
}
//職缺資料列表
+(NSString*)GetRecruitersListSoapMesage:(int)curPage withCurSize:(int)pageSize{
    NSString *soap=[SoapHelper MethodSoapMessage:@"GetRecruitersList"];
    NSMutableString *msg=[NSMutableString stringWithFormat:@""];
    [msg appendFormat:@"<curPage>%d</curPage>",curPage];
    [msg appendFormat:@"<pageSize>%d</pageSize>",pageSize];
    return [NSString stringWithFormat:soap,msg];
}
//職缺資料明細
+(NSString*)GetRecruitersDetailSoapMessage:(NSString*)guid{
    NSString *soap=[SoapHelper MethodSoapMessage:@"GetRecruitersDetail"];
    NSMutableString *msg=[NSMutableString stringWithFormat:@""];
    [msg appendFormat:@"<PK>%@</PK>",guid];
    return [NSString stringWithFormat:soap,msg];
}
//求才活動資料列表
+(NSString*)GetActivityListSoapMesage:(int)curPage withCurSize:(int)pageSize{
    NSString *soap=[SoapHelper MethodSoapMessage:@"GetActivityList"];
    NSMutableString *msg=[NSMutableString stringWithFormat:@""];
    [msg appendFormat:@"<curPage>%d</curPage>",curPage];
    [msg appendFormat:@"<pageSize>%d</pageSize>",pageSize];
    return [NSString stringWithFormat:soap,msg];
}
@end
