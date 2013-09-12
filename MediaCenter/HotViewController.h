//
//  HotViewController.h
//  MediaCenter
//
//  Created by aJia on 12/11/22.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "BasicTableViewController.h"
@interface HotViewController : BasicTableViewController<UISearchBarDelegate,ServiceHelperDelegate>{
    ServiceHelper *helper;
    //热门影音
    int hotCurPage;
    int hotPageSize;
    int hotMaxPage;
    BOOL isFirstLoadHot;
    
    //传值处理
    int selectRow;

}
@property(nonatomic,retain) NSString *KeyWord;
@property(nonatomic,retain) NSMutableArray *listData;
- (IBAction)btnSearchClick:(id)sender;
-(void)clearChildsView;
//开始查询
-(void)startSearch;
@end
