//
//  MovieFavoriteViewController.h
//  MediaCenter
//
//  Created by rang on 12-11-23.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "BasicTableViewController.h"
@interface MovieFavoriteViewController : BasicTableViewController<UIDocumentInteractionControllerDelegate,UIAlertViewDelegate>{
    int deleteRow;
    UIDocumentInteractionController *documentController;
}
- (IBAction)toggleEdit:(id)sender;

@property(nonatomic,retain) NSMutableArray *listData;
-(void)openDocumentUrl:(NSString*)fileUrl;
@end
