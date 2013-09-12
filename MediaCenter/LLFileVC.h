//
//  LLFileVC.h
//  DocumentPreview
//
//  Created by aJia on 13/1/24.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLFileVC : UIViewController<UIDocumentInteractionControllerDelegate>{
    BOOL        _isShowing;
    NSURL    *_docURL;
}
@property (nonatomic, retain) UIDocumentInteractionController *docInteractionController;
-(id)initWithURL:(NSURL*)aURL;
@end
