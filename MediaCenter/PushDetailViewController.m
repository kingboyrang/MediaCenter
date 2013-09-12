//
//  PushDetailViewController.m
//  MediaCenter
//
//  Created by aJia on 12/11/27.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "PushDetailViewController.h"
#import "MediaSoapMessage.h"
#import "PushInfo.h"
#import "AlterMessage.h"
@interface PushDetailViewController ()

@end

@implementation PushDetailViewController
@synthesize ItemData,GUID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.GUID!=nil) {
        self.ItemData=[NSDictionary dictionary];
        NSString *soapMsg=[MediaSoapMessage PushInfoSoap:self.GUID];
        [helper AsyCommonServiceRequest:PushWebServiceUrl ServiceNameSpace:PushWebServiceNameSpace ServiceMethodName:@"GetPushInfo" SoapMessage:soapMsg];
    }else{
        [self reLoadController:[self.ItemData objectForKey:@"Title"] withMessage:[self.ItemData objectForKey:@"Content"]];
        self.GUID=@"";
        
    }

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(btnBackClick:)];
    self.navigationItem.leftBarButtonItem=leftButton;
    [leftButton release];
    
    //设置logo图标
    [self.navigationItem titleViewBackground];
    
    
    helper=[[ServiceHelper alloc] initWithDelegate:self];
    
    
	// Do any additional setup after loading the view.
}
-(void)finishSuccessRequest:(NSString*)responseText responseData:(NSData*)requestData{
    NSMutableDictionary *dic=[PushInfo PushToDictionary:responseText];
    if([dic count]>0){
        [self reLoadController:[dic objectForKey:@"Title"] withMessage:[dic objectForKey:@"Content"]];        //文件写入
        [PushInfo writeToPushFile:dic];
    }else{
        [AlterMessage initWithMessage:@"資料加載失敗！"];
    }
}
-(void)finishFailRequest:(NSError*)error{
}
//返回
-(void)btnBackClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)reLoadController:(NSString*)title withMessage:(NSString*)msg{
    
    CGSize textSize=[title CalculateStringSize:[UIFont boldSystemFontOfSize:17] with:self.view.frame.size.width];
    
    UILabel *labTitle=[[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-textSize.width)/2, 2, textSize.width, textSize.height)];
    labTitle.font=[UIFont boldSystemFontOfSize:17];
    labTitle.textColor=[UIColor blackColor];
    labTitle.text=title;
    labTitle.backgroundColor=[UIColor clearColor];
    [self.view addSubview:labTitle];
    [labTitle release];
    
    CGFloat topY=self.view.frame.size.height;
    topY-=(textSize.height+4);
    /***
     if (self.navigationController) {
     topY-=self.navigationController.navigationBar.frame.size.height;
     }
     if (self.tabBarController) {
     topY-=self.tabBarController.tabBar.frame.size.height;
     }
     ***/
    UITextView *tv=[[UITextView alloc] initWithFrame:CGRectMake(0, textSize.height+4, self.view.frame.size.width, topY)];
    tv.editable=NO;
    tv.font=[UIFont systemFontOfSize:17];
    tv.textColor=[UIColor blackColor];
    tv.backgroundColor=[UIColor clearColor];
    //[tv setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    tv.text=msg;
    [self.view addSubview:tv];
    [tv release];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
    [super dealloc];
    [ItemData release];
}
@end
