//
//  AlterMessage.h
//  ControlAnimation
//
//  Created by aJia on 2012/3/29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlterMessage : NSObject {
	UIAlertView *alterView;
}
+(void)showConfirmAndCancel:(NSString*)title withMessage:(NSString*)msg cancelMessage:(NSString*)cancelMsg confirmMessage:(NSString*)confirmMsg cancelAction:(void (^)(void))act confirmAction:
(void (^)(void))confirmAct;

+(void)initWithTip:(NSString*)msg confirmMessage:(NSString*)confirm cancelMessage:(NSString*)cancel confirmAction:(void (^)(void))act;
+(void)initWithMessage:(NSString*)message;
+(void)initWithTitleandMessage:(NSString*)title withMessage:(NSString*)message;
+(void)initWithArguments:(NSString*)title withMessage:(NSString*)message delegate:(id)sender buttonName:(NSString*)btnName
			 buttonNames:(NSString*)other, ... NS_REQUIRES_NIL_TERMINATION;
-(void)ShowActivityIndicatorView:(NSString*)titile withMessage:(NSString*)message;
-(void)CloseAlterView;
- (NSMutableArray*)formatParams:(NSString *)format, ...;
-(void)alterLoginView;
@end
