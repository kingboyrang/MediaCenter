//
//  AppDelegate.m
//  MediaCenter
//
//  Created by aJia on 12/11/6.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "AppDelegate.h"
#import "FileHelper.h"
#import "MediaSoapMessage.h"
#import "PushInfo.h"
#import "PushDetailViewController.h"
#import "AlterMessage.h"
#import "PreviewDataSource.h"
#import "PushToken.h"
#import "XmlParseHelper.h"
#import "ASIHTTPRequest.h"
#import "AdminURL.h"
#import "NSString+StringExtension.h"
@implementation AppDelegate
- (void)dealloc
{
    [_window release];
    [helper release];
    [super dealloc];
}
-(void)reRegisterApns{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"Flag"]==nil) {
        //向apns注册
        //注册推播
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
    }
}
-(void)updateAccessInterface{
   ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:DataAccessURL]];
    [request setCompletionBlock:^{
        if (request.responseStatusCode==200) {
            NSString *xml=[request.responseString stringByReplacingOccurrencesOfString:@"xmlns=\"AdminURL[]\"" withString:@""];
            XmlParseHelper *parse=[[[XmlParseHelper alloc] initWithData:xml] autorelease];
            NSArray *source=[parse selectNodes:@"//AdminURL" className:@"AdminURL"];
            NSMutableArray *arr=[NSMutableArray arrayWithArray:DataServicesSource];
            if (source&&[source count]>0) {
                 NSString *url2=@"";
                for (AdminURL *item in source) {
                    if ([item.name isEqualToString:@"elandmcwebserviceurl"]&&[item.url length]>0) {
                        arr[0]=[item.url Trim];
                    }
                    if ([item.name isEqualToString:@"pushsadminurl"]&&[item.url length]>0) {
                        url2=[item.url Trim];
                    }
                }
                if ([url2 length]>0) {
                    if (![url2 isEqualToString:arr[1]]) {
                        arr[1]=url2;
                        //重新注册
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        if ([userDefaults objectForKey:@"Flag"]!=nil)
                        {
                            NSString *soapMsg=[PushToken registerTokenWithDeivceId:[userDefaults objectForKey:@"Flag"]];
                            [helper AsyCommonServiceRequest:PushWebServiceUrl ServiceNameSpace:PushWebServiceNameSpace ServiceMethodName:@"Register" SoapMessage:soapMsg];
                            
                        }else{
                           [self reRegisterApns];
                        }
                    }
                }
                [arr writeToFile:DataWebPath atomically:YES];
            }

        }
        
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
    
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     helper=[[ServiceHelper alloc] initWithDelegate:self];
    [self updateAccessInterface];
   
    application.applicationIconBadgeNumber=0;
    //[fileName stringByDeletingPathExtension];
    //创建文件夹
    [FileHelper createFileDir:@"MediaCenter"];
    
    //向apns注册
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
    
    
    /*****远程通知启动****/
    NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo)
    {
        [self pushHandler:userInfo];
    }
    //网络实时检测
    NetWorkConnection *network=[NetWorkConnection sharedInstance];
    [network setHasConnection:YES];
    [network ListenerConection:@"http://www.apple.com" delegate:self];
    
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *sharedCache = [[[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"] autorelease];
    [NSURLCache setSharedURLCache:sharedCache];
   
    return YES;
}
-(void)NetWorkHandler:(NetworkStatus)status IsConnection:(BOOL)hasConnection{
    [[NetWorkConnection sharedInstance] setHasConnection:hasConnection];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    
    [self reRegisterApns];//注册推播
    [self updateAccessInterface];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
#pragma mark -
#pragma mark 本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //点击提示框的打开
    application.applicationIconBadgeNumber = 0;
    UIApplicationState state = application.applicationState;
    //    NSLog(@"%@,%d",notification,state);
    if (state == UIApplicationStateActive) {
        [AlterMessage initWithTip:[NSString stringWithFormat:@"%@,是否直接開啟?",notification.alertBody] confirmMessage:@"是" cancelMessage:@"否" confirmAction:^(){
              //处理确认操作
            
             UITabBarController *rootController=(UITabBarController*)self.window.rootViewController;
             NSArray *arr=rootController.viewControllers;
            UINavigationController *nav=(UINavigationController*)[arr objectAtIndex:rootController.selectedIndex];
            
            NSString *filePath=[[notification userInfo] objectForKey:@"path"];
            NSString *name=[[filePath lastPathComponent] stringByDeletingPathExtension];
            QLPreviewController *previewoCntroller = [[[QLPreviewController alloc] init] autorelease];
            
            
            
            PreviewDataSource *dataSource = [[[PreviewDataSource alloc]init] autorelease];
            dataSource.path=[[NSString alloc] initWithString:filePath];
            previewoCntroller.dataSource=dataSource;
            [nav pushViewController: previewoCntroller animated:YES];
            [previewoCntroller setTitle:name];
            previewoCntroller.navigationItem.rightBarButtonItem=nil;
            
            /***
            OpenFileViewController *openController=[[OpenFileViewController alloc] init];
            openController.openFileUrl=[[notification userInfo] objectForKey:@"path"];
            [nav pushViewController:openController animated:YES];
            [openController release];
             ***/

        }];
    }
    //[application cancelLocalNotification:notification];
    
}
/***
-(void)applicationDidBecomeActive:(UIApplication *)application{
    //当程序还在后天运行
    application.applicationIconBadgeNumber = 0;
}
 **/
#pragma mark -
#pragma mark ServiceHelper delegate Methods
-(void)finishSuccessRequest:(NSString*)xml responseData:(NSData*)requestData{
    BOOL boo=NO;
    if ([xml length]>0) {
        xml=[xml stringByReplacingOccurrencesOfString:@"xmlns=\"Result\"" withString:@""];
        XmlParseHelper *result=[[[XmlParseHelper alloc] initWithData:xml] autorelease];
        XmlNode *resultNode=[result selectSingleNode:@"//Success"];
        if ([resultNode.Value isEqualToString:@"true"]) {
            boo=YES;
        }
    }
    if (!boo) {
        [self reRegisterApns];
    }
}
-(void)finishFailRequest:(NSError*)error{
    [self reRegisterApns];
}
#pragma mark - APNS 回傳結果
// 成功取得設備編號token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceId = [[deviceToken description]
                          substringWithRange:NSMakeRange(1, [[deviceToken description] length]-2)];
    deviceId = [deviceId stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceId = [deviceId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:deviceId forKey:@"Flag"];
    //NSString *code=[[UIDevice currentDevice] uniqueDeviceIdentifier];
     NSString *soapMsg=[PushToken registerTokenWithDeivceId:deviceId];
     //NSString *soapMsg=[PushToken registerTokenWithDeivceId:@"762e025eafe03fdbb13b2f03e6224d5216dfcc78dbeebfbb3147c9973d114ecc"];
    //我的设置token
    //762e025eafe03fdbb13b2f03e6224d5216dfcc78dbeebfbb3147c9973d114ecc
    [helper AsyCommonServiceRequest:PushWebServiceUrl ServiceNameSpace:PushWebServiceNameSpace ServiceMethodName:@"Register" SoapMessage:soapMsg];
    
}
//获取接收的推播信息
- (void) application:(UIApplication *) app didReceiveRemoteNotification:(NSDictionary *) userInfo
{
    //app.applicationIconBadgeNumber=0;
    [self pushHandler:userInfo];
}

// 或無法取得設備編號token
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //表示信息推播失败
}
//推播处理
-(void)pushHandler:(NSDictionary*)userInfo{
    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=nil) {
        NSString *post=[userInfo objectForKey:@"guid"];
        NSDictionary  *dic=[NSDictionary dictionaryWithObjectsAndKeys:post,@"guid", nil];
        
        NSNotification *notification = [NSNotification notificationWithName:@"pushDetail" object:nil userInfo:dic];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
    }
}
@end
