//
//  OrgenMovieViewController.h
//  MediaCenter
//
//  Created by aJia on 12/11/28.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "BasicTableViewController.h"
@interface OrgenMovieViewController : BasicTableViewController<ServiceHelperDelegate>{
    int selectRow;
    ServiceHelper  *helper;
    
    int chooseImg;
}

@property(nonatomic,retain) NSDictionary *ItemData;
@property(nonatomic,retain) NSMutableArray *listData;
@end
