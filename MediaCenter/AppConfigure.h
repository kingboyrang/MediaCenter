//
//  AppConfigure.h
//  HttpRequest
//
//  Created by rang on 12-11-8.
//
//

/***
//台北
//webservice配置
#define defaultWebServiceUrl @"http://60.251.51.217/dmc.eland/admin/MDC.asmx"
#define defaultWebServiceNameSpace @"http://tempuri.org/"
//推播信息webservice
#define PushWebServiceUrl @"http://60.251.51.217/ElandMC.Admin1206/WebServices/WebService.asmx"
#define PushWebServiceNameSpace @"http://60.251.51.217/ELandMC.Admin1206/WebServices/"
***/


//宜蘭
#define defaultWebServiceUrl @"http://dmc.e-land.gov.tw/admin/MDC.asmx"
#define defaultWebServiceNameSpace @"http://tempuri.org/"
//推播信息webservice
#define PushWebServiceUrl @"http://210.69.148.65/ElandWE.Admin/WebServices/Webservice.asmx"
#define PushWebServiceNameSpace @"http://210.69.148.65/ELandWE.Admin/WebServices/"


//下载的文件保存路径
#define DownFileFolderPath	 [NSString stringWithFormat:@"%@/MediaCenter",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]



