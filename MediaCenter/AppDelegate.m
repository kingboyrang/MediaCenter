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
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    
    [self reRegisterApns];//注册推播
    
   
    
    
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
    if ([xml isEqualToString:@"true"]) {
    }else{
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
    NSString *code=[[UIDevice currentDevice] uniqueDeviceIdentifier];
    helper=[[ServiceHelper alloc] initWithDelegate:self];
     NSString *soapMsg=[MediaSoapMessage GCMRegisterSoap:deviceId AppCode:code];
    [helper AsyCommonServiceRequest:PushWebServiceUrl ServiceNameSpace:PushWebServiceNameSpace ServiceMethodName:@"GCMRegister" SoapMessage:soapMsg];
    
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
        NSString *post=[userInfo objectForKey:@"content"];
        NSDictionary  *dic=[PushInfo PushCheckStringToDictionary:post];
        
        NSNotification *notification = [NSNotification notificationWithName:@"pushDetail" object:nil userInfo:dic];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
    }
}
@end
