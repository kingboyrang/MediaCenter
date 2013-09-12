//
//  HappyViewController.h
//  MediaCenter
//
//  Created by rang on 12-11-20.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "ShowMetaDataCell.h"
#import "BasicViewController.h"
@interface HappyViewController : BasicViewController<UISearchBarDelegate,ServiceHelperDelegate,UITableViewDataSource,UITableViewDelegate>{
    ServiceHelper *helper;
    int selectRow;
    
    int curPage;
    int commonPageSize;
    int maxPage;
     BOOL isFirstLoad;
}
//搜寻
- (IBAction)buttonSearchClick:(id)sender;

@property (retain, nonatomic) IBOutlet UITableView *tabView;
@property(nonatomic,retain) NSString *KeyWord;
@property(nonatomic,retain) NSString *CategoryCode;
@property(nonatomic,retain) NSMutableArray *listData;
-(void)clearChildsView;

//开始查询
-(void)startSearch;
@end
