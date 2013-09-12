//
//  NewMetaData.h
//  MediaCenter
//
//  Created by aJia on 12/11/22.
//  Copyright (c) 2012年 rang. All rights reserved.
//
/****************幸福宜蘭****************/
#import <Foundation/Foundation.h>
#import "BaseMetaData.h"
@interface NewMetaData : BaseMetaData
/***
 <META_PK>79b33d35-32ab-42ca-bafb-0bf611f3d6f7</META_PK>
 <C_NAME>宜蘭童玩節水上活動(101年)</C_NAME>
 <DESCRIPTION>每年的宜蘭童玩節，總帶給人不一樣的驚喜，而它也成為盛夏的遊玩景點之一，不但與朋友們一起玩水也帶著他們重溫一下這個酷熱天氣中難得的清涼～並且，這次還發現新增了許多有趣的水上遊樂設施，以及大小朋友都喜歡的展覽喲！</DESCRIPTION>
 <REG_DATE>2012/11/22 07:06:59</REG_DATE>
 <DTYPE>1</DTYPE>
 <CATEGORY_NAME>歷年宜蘭童玩節活影音欣賞</CATEGORY_NAME>
 <DEPT_NAME>工商旅遊處</DEPT_NAME>
 <FilePath>http://60.251.51.217/ElandMDC.Web//GetSFile.aspx?CID=ep&amp;DeptCode=Deic02000&amp;MetaPK=79B33D35-32AB-42CA-BAFB-0BF611F3D6F7&amp;FilePath=Deic02000_ep_toy101_pic__1_104__00001-0001-t.jpg&amp;DType=1</FilePath>
 ***/

//获取最新影音列表
+(NSMutableArray*)XmlToArray:(NSString*)xml;
@end
