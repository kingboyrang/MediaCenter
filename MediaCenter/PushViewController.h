//
//  PushViewController.h
//  MediaCenter
//
//  Created by aJia on 12/11/27.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushViewController : UITableViewController{
    int selectRow;
}
@property(nonatomic,retain) NSMutableArray *listData;
@end
