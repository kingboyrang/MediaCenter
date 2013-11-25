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
#import "UIColor+TPCategory.h"
#import "NSString+StringExtension.h"
#import "WBErrorNoticeView.h"
#import "SoapHelper.h"
#import "XmlParseHelper.h"
#import "CacheHelper.h"
#import "ShowPushDetail.h"
@interface PushDetailViewController (){
    UILabel *_labTitle;
    ShowPushDetail *_textView;
}
-(void)initEntityValue;
-(void)showErrorView;
-(void)updateUIShow;
@end

@implementation PushDetailViewController
-(void)dealloc{
    [super dealloc];
    [_labTitle release],_labTitle=nil;
    [_textView release],_textView=nil;
    [helper release];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    _labTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
	_labTitle.backgroundColor=[UIColor colorFromHexRGB:@"dfdfdf"];
    _labTitle.font=[UIFont boldSystemFontOfSize:16];
    _labTitle.textColor=[UIColor colorFromHexRGB:@"3DB5C0"];
    [self.view addSubview:_labTitle];
    
    _textView=[[ShowPushDetail alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-40)];
    [self.view addSubview:_textView];
    
    if (self.Entity) {
        if (![self.Entity.Subject isEqual:[NSNull null]]&&[self.Entity.Subject length]>0) {
            [self updateUIShow];
        }else{
            [self loadPushDetail:self.Entity.GUID];
        }
    }

	// Do any additional setup after loading the view.
}
-(void)initEntityValue{
    if (self.Entity) {
        self.Entity.Body=@"內容建置中...";
    }
    [self updateUIShow];
}
-(void)updateUIShow{
    CGSize size=[self.Entity.Subject CalculateStringSize:[UIFont boldSystemFontOfSize:16] with:self.view.bounds.size.width];
    CGRect frame=_labTitle.frame;
    frame.size.height=size.height;
    if (size.height<40) {
        frame.size.height=40;
    }
    _labTitle.frame=frame;
    _labTitle.text=self.Entity.Subject;
    
    frame=_textView.frame;
    frame.origin.y=_labTitle.frame.size.height;
    frame.size.height=self.view.bounds.size.height-_labTitle.frame.size.height;
    _textView.frame=frame;
    [_textView setTextContent:self.Entity.Body];
}
-(void)showErrorView{
    WBErrorNoticeView *errorView=[WBErrorNoticeView errorNoticeInView:self.view title:@"提示" message:@"資料加載失敗!"];
    [errorView show];
}
-(void)loadPushDetail:(NSString*)guid{
    NSString *soap=[SoapHelper NameSpaceSoapMessage:PushWebServiceNameSpace MethodName:@"GetMessage"];
    NSString *msg=[NSString stringWithFormat:@"<guid>%@</guid>",guid];
    NSString *body=[NSString stringWithFormat:soap,msg];
    [helper AsyCommonServiceRequest:PushWebServiceUrl ServiceNameSpace:PushWebServiceNameSpace ServiceMethodName:@"GetMessage" SoapMessage:body];
}
-(void)finishSuccessRequest:(NSString*)responseText responseData:(NSData*)requestData{
    if ([responseText length]>0) {
        
       NSString *xml=[responseText stringByReplacingOccurrencesOfString:@"xmlns=\"PushResult\"" withString:@""];
        XmlParseHelper *result=[[[XmlParseHelper alloc] initWithData:xml] autorelease];
        NSArray *arr=[result selectNodes:@"//Entity" className:@"PushResult"];
        if ([arr count]>0) {
            self.Entity=[arr objectAtIndex:0];
            [CacheHelper cacheCasePushResult:self.Entity];
            [self updateUIShow];
        }else{
           [self showErrorView];
            //[self initEntityValue];
        }
    }else{
        [self showErrorView];
        //[self initEntityValue];
    }
}
-(void)finishFailRequest:(NSError*)error{
    [self showErrorView];
    //[self initEntityValue];
}
//返回
-(void)btnBackClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
