//
//  AppConfigure.h
//  HttpRequest
//
//  Created by rang on 12-11-8.
//
//

#define DataAccessURL @"http://60.251.51.217/Pushs.Admin/WebServices/CasesAdminURL.aspx?get=elandmc"

#define DataWebPath [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]
#define DataServicesSource [NSArray arrayWithContentsOfFile:DataWebPath]
#define DataCaseUrlPre [DataServicesSource objectAtIndex:0]
#define DataPushUrlPre [DataServicesSource objectAtIndex:1]



//测试
#define defaultWebServiceUrl [NSString stringWithFormat:@"%@MDC.asmx",DataCaseUrlPre]
#define defaultWebServiceNameSpace @"http://tempuri.org/"
//推播信息webservice
#define PushWebServiceUrl [NSString stringWithFormat:@"%@WebServices/Push.asmx",DataPushUrlPre]
#define PushWebServiceNameSpace @"http://tempuri.org/"


#define DocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
//下载的文件保存路径
#define DownFileFolderPath	 [NSString stringWithFormat:@"%@/MediaCenter",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]
