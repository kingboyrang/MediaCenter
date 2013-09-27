//
//  MediaSoapMessage.h
//  MediaCenter
//
//  Created by rang on 12-11-20.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaSoapMessage : NSObject

/****公有查询
 Category:1:幸福宜蘭; 2:熱門影音; 3:最新影音 4:县长专区 5:数位出版品;
 classcode:分类别
 KeyWord:关键字
 withCurPage:当前页
 withCurSize:每页显示数量
 *****/
+(NSString*)CategorySearchMetaData:(NSString*)Category classCode:(NSString*)code KeyWord:(NSString*)keyword withCurPage:(int)curPage withCurSize:(int)pageSize;

/**幸福宜蘭***
 KeyWord:关键字
 classCode:分类别代码
 withCurPage:当前页
 withCurSize:每页显示数量
 ***/
+(NSString*)HappyElandSoap:(NSString*)keyword classCode:(NSString*)code withCurPage:(int)curPage withCurSize:(int)pageSize;

/**熱門影音***
 KeyWord:关键字
 withCurPage:当前页
 withCurSize:每页显示数量
 ***/
+(NSString*)HotMovieSoap:(NSString*)keyword withCurPage:(int)curPage withCurSize:(int)pageSize;

/**最新影音***
 KeyWord:关键字
 withCurPage:当前页
 withCurSize:每页显示数量
 ***/
+(NSString*)NewMovieSoap:(NSString*)keyword withCurPage:(int)curPage withCurSize:(int)pageSize;

/**县长专区***
 KeyWord:关键字
 withCurPage:当前页
 withCurSize:每页显示数量
 ***/
+(NSString*)DistrictMovieSoap:(NSString*)keyword withCurPage:(int)curPage withCurSize:(int)pageSize;

/**福利专区***
 KeyWord:关键字
 withCurPage:当前页
 withCurSize:每页显示数量
 ***/
+(NSString*)BenfitMovieSoap:(NSString*)keyword withCurPage:(int)curPage withCurSize:(int)pageSize;

/**数位出版品***
 KeyWord:关键字
 withCurPage:当前页
 withCurSize:每页显示数量
 ***/
+(NSString*)EbookMovieSoap:(NSString*)keyword withCurPage:(int)curPage withCurSize:(int)pageSize;

/****
 **获取机关类别
 ***/
+(NSString*)OrgenTypeSoap;

/**最新消息**
 type:1:县政消息 2.县政活动 3.最新消息
 withCurPage:当前页
 withCurSize:每页显示数量
 ****/
+(NSString*)WebNewsByTypeSoap:(NSString*)type withCurPage:(int)curPage withCurSize:(int)pageSize;

/****获取分类别soap****/
+(NSString*)CategoryListSoap;


//職缺資料列表
+(NSString*)GetRecruitersListSoapMesage:(int)curPage withCurSize:(int)pageSize;
//職缺資料明細
+(NSString*)GetRecruitersDetailSoapMessage:(NSString*)guid;
//求才活動資料列表
+(NSString*)GetActivityListSoapMesage:(int)curPage withCurSize:(int)pageSize;




//获取幸福宜蘭前20笔资料
+(NSString*)NewMetaDataSoap;
//获取热门类别的前20笔资料
+(NSString*)HotMetaDataSoap;
//获取最新影音前20笔资料
+(NSString*)PublishMetaDataSoap;
//最新影音查询
+(NSString*)SearchMetaDataSoap:(NSString*)keyword withCurPage:(int)curPage withCurSize:(int)pageSize;



//获取指定MetaData下的资料
+(NSString*)SubMetaListSoap:(NSString*)metaPK;

//机关类别
+(NSString*)MetaDataByDeptSoap:(NSString*)topDept childDept:(NSString*)childDept;

// _apps.Add(new AppModel("ios.app.elandmc.mdc", "IOS數位媒體中心"));
//注册推播
+(NSString*)GCMRegisterSoap:(NSString*)token AppCode:(NSString*)code;
//取消注册
+(NSString*)GCMUnRegisterSoap:(NSString*)token;
//获取一笔推播信息
+(NSString*)PushInfoSoap:(NSString*)guid;
@end
