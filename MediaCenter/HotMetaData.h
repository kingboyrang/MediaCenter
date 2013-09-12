//
//  HotMetaData.h
//  MediaCenter
//
//  Created by aJia on 12/11/22.
//  Copyright (c) 2012年 rang. All rights reserved.
//
/****************热门类别****************/
#import <Foundation/Foundation.h>
#import "BaseMetaData.h"
@interface HotMetaData:BaseMetaData
/****
 <META_PK>d563c1eb-deb0-448b-8142-a9e9d6266484</META_PK>
 <C_NAME>宜蘭童玩節精選圖片集</C_NAME>
 <DESCRIPTION></DESCRIPTION>
 <REG_DATE>2012/10/27 11:17:10</REG_DATE>
 <DTYPE>1</DTYPE>
 <CATEGORY_NAME>縣長專區</CATEGORY_NAME>
 <DEPT_NAME>秘書處</DEPT_NAME>
 <VisitCount>107</VisitCount>
 <FilePath>http://60.251.51.217/ElandMDC.Web//GetSFile.aspx?CID=dm&amp;DeptCode=Deic02000&amp;MetaPK=D563C1EB-DEB0-448B-8142-A9E9D6266484&amp;FilePath=Deic02000_dm_elove_city_pic_1_101__00001-0001-t.jpg&amp;DType=1</FilePath>
 ***/
@property(nonatomic,retain) NSString *VisitCount;
+(NSMutableArray*)XmlToHotMetaData:(NSString*)xml;
+(NSMutableArray*)XmlToArray:(NSString*)xml withMaxPage:(NSString**)page;
@end
