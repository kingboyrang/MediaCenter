//
//  SearchMetaData.h
//  MediaCenter
//
//  Created by aJia on 12/11/21.
//  Copyright (c) 2012年 rang. All rights reserved.
//
/****************最新影音****************/
#import <Foundation/Foundation.h>
#import "BaseMetaData.h"
@interface SearchMetaData : BaseMetaData
+(NSString*)formatImageUrl:(NSString*)url;
+(NSMutableArray*)XmlToArray:(NSString*)xml withMaxPage:(NSString**)page;
+(NSMutableArray*)XmlToObject:(NSString*)xml withClassName:(NSString*)className withMaxPage:(NSString**)page;
/***
 <SearchMetaData diffgr:id="SearchMetaData2" msdata:rowOrder="1">
 <META_PK>274f7fff-e998-4011-bfdd-cf114181568a</META_PK>
 <C_NAME>宜蘭童玩節_異國舞蹈表演(100年)</C_NAME>
 <DESCRIPTION>「2012年宜蘭國際童玩藝術節」將從7月7日至8月19日於宜蘭縣冬山河親水公園 .... 廣邀世界各國的民俗舞蹈團體來宜蘭，將各種充滿異國風情的藝術表演呈現給國人</DESCRIPTION>
 <REG_DATE>2012/11/22 07:06:59</REG_DATE>
 <DTYPE>1</DTYPE>
 <CATEGORY_NAME>歷年宜蘭童玩節活影音欣賞</CATEGORY_NAME>
 <DEPT_NAME>工商旅遊處</DEPT_NAME>
 <FilePath>http://60.251.51.217/ElandMDC.Web//GetSFile.aspx?CID=ep&amp;DeptCode=Deic02000&amp;MetaPK=274F7FFF-E998-4011-BFDD-CF114181568A&amp;FilePath=Deic02000_ep_toy100_pic__1_104__00001-0001-t.jpg&amp;DType=1</FilePath>
 </SearchMetaData>
 ***/
@end
