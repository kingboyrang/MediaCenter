//
//  ShowMetaDataCell.h
//  MediaCenter
//
//  Created by aJia on 12/11/21.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomizeImageView.h"
@protocol ShowMetaDataDelegate <NSObject>
-(void)ShowMetaDataDetail:(NSSet *)touches withEvent:(UIEvent *)event whichView:(id)which;
@end

@interface ShowMetaDataCell : UIView<ImageViewDelegate>
/**
@property(nonatomic,retain) NSString *DEPT_NAME;
@property(nonatomic,retain) NSString *REG_DATE;
@property(nonatomic,retain) NSString *FilePath;
@property(nonatomic,retain) NSString *C_NAME;
 **/
@property(nonatomic,assign) id<ShowMetaDataDelegate> delegate;
@property(nonatomic,retain) NSDictionary *listData;
-(id)initWithData:(NSDictionary*)dic withFrame:(CGRect)frame;
-(void)loadConfigure:(CGRect)frame;
@end

