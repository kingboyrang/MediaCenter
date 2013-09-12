//
//  AlterMessage.m
//  ControlAnimation
//
//  Created by aJia on 2012/3/29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AlterMessage.h"
#import "UIAlertView+Blocks.h"
#import "RIButtonItem.h"
@implementation AlterMessage
+(void)showConfirmAndCancel:(NSString*)title withMessage:(NSString*)msg cancelMessage:(NSString*)cancelMsg confirmMessage:(NSString*)confirmMsg cancelAction:(void (^)(void))act confirmAction:
(void (^)(void))confirmAct{
    
    RIButtonItem *cancelButton=[RIButtonItem item];
    cancelButton.label=cancelMsg;
    cancelButton.action=act;
    
    
    RIButtonItem *button=[RIButtonItem item];
    button.label=confirmMsg;
    button.action=confirmAct;
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title
                                                  message:msg
                                         cancelButtonItem:cancelButton
                                         otherButtonItems:button, nil];
    [alert show];
    [alert release];
}
+(void)initWithTip:(NSString*)msg confirmMessage:(NSString*)confirm cancelMessage:(NSString*)cancel confirmAction:(void (^)(void))act{
    
    
     RIButtonItem *cancelButton=[RIButtonItem item];
    cancelButton.label=cancel;
    cancelButton.action=nil;
    
    RIButtonItem *button=[RIButtonItem item];
    button.label=confirm;
    button.action=act;
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:msg
                                         cancelButtonItem:cancelButton
                                         otherButtonItems:button, nil];
    [alert show];
    [alert release];
}

+(void)initWithMessage:(NSString*)message
{
	[self initWithTitleandMessage:@"提示" withMessage:message];
}
+(void)initWithTitleandMessage:(NSString*)title withMessage:(NSString*)message
{
	[self initWithArguments:title 
				withMessage:message 
				   delegate:nil 
				 buttonName:@"確定" 
				buttonNames:nil];
}
+(void)initWithArguments:(NSString*)title withMessage:(NSString*)message delegate:(id)sender buttonName:(NSString*)btnName
			 buttonNames:(NSString*)other, ...
{
	UIAlertView *alter=[[UIAlertView alloc] init];
	alter.title=title;
	alter.message=message;
	alter.delegate=sender;
	if(other){
		va_list va_Average;
		NSString *str;
		NSMutableArray *array=[[NSMutableArray alloc] init];
		[array addObject:other];
	  va_start(va_Average,other);//va_start 第二個參數為... 的前一個參數
		while ((str = va_arg(va_Average, NSString *))){
			[array addObject:str];
		}
		va_end(va_Average);
		NSLog(@"len:%d\n",[array count]);
		NSLog(@"%@",[array componentsJoinedByString:@";"]);
		for (NSString *item in array) 
			[alter addButtonWithTitle:item];
		[array release];
	}
	if(btnName)
		[alter addButtonWithTitle:btnName];
	[alter show];
	[alter release];
}
-(void)ShowActivityIndicatorView:(NSString*)titile withMessage:(NSString*)message
{
	alterView=[[UIAlertView alloc] initWithTitle:titile 
										 message:message 
										delegate:nil 
							   cancelButtonTitle:nil 
							   otherButtonTitles:nil];
	
	[alterView show];
	//NSLog(@"x:%f,y:%f,w:%f,h:%f",alterView.bounds.origin.x,alterView.bounds.origin.y,alterView.bounds.size.width,alterView.bounds.size.height);
	UIActivityIndicatorView *indicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	//indicatorView.center=CGPointMake(alterView.bounds.size.width/2, alterView.bounds.size.height/2);
	indicatorView.center = CGPointMake(145.0f,70.0f); 
	[indicatorView startAnimating];
	[alterView addSubview:indicatorView];
	
	[NSThread sleepForTimeInterval:3.0f];
	//sleep(2);
	[alterView dismissWithClickedButtonIndex:0 animated:YES];
	[self CloseAlterView];
}
-(void)CloseAlterView{
	if(alterView)[alterView release];
}
-(void)alterLoginView{//登入頁面
	alterView=[[UIAlertView alloc] initWithTitle:@"系統登入"
										 message:nil 
										delegate:nil 
							   cancelButtonTitle:@"登入"
							   otherButtonTitles:@"取消",nil];
	[alterView show];
	CGRect alterframe=alterView.frame;
	alterframe.size.height=200;
	alterView.frame=alterframe;
	UIView *loginView=[[UIView alloc] initWithFrame:CGRectMake(10,45, alterView.bounds.size.width-20, 72)];
	loginView.backgroundColor=[UIColor clearColor];
	UITextField *userField=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, loginView.frame.size.width-20, 31)];
	userField.borderStyle=UITextBorderStyleRoundedRect;
	userField.placeholder=@"使用者";
	userField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
	userField.font=[UIFont fontWithName:@"Helvetica" size:12];
	[loginView addSubview:userField];
	//[alterView addSubview:userField];
	[userField release];
	
	UITextField *pwdField=[[UITextField alloc] initWithFrame:CGRectMake(0, 41, loginView.frame.size.width-20, 31)];
	pwdField.borderStyle=UITextBorderStyleRoundedRect;
	pwdField.placeholder=@"密碼";
	pwdField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
	pwdField.font=[UIFont fontWithName:@"Helvetica" size:12];
	pwdField.secureTextEntry=YES;
	[loginView addSubview:pwdField];
	//[alterView addSubview:pwdField];
	[pwdField release];
	[alterView addSubview:loginView];
	[loginView release];
	
	
	[self CloseAlterView];
	

}
- (NSMutableArray*)formatParams:(NSString *)format, ...
{   
	NSMutableArray *array=[[NSMutableArray alloc] init];
    NSString* eachArg;
    va_list argList;
    if (format)// 第一個參數 format 是不屬於參數列表的,
    {       
		[array addObject:format];
        va_start(argList, format);          // 從 format 開始遍歷參數，不包括 format 本身.
        while ((eachArg = va_arg(argList, NSString*))) // 从 args 中遍歷出參數，NSString* 指名類型
		{ 
			//NSLog(@"%@",eachArg);              // 顯示每一個參數.
			[array addObject:eachArg];
		}
        va_end(argList);
    }
	return array;
}
@end
