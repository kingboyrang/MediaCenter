//
//  MediaViewController.h
//  MediaCenter
//
//  Created by aJia on 12/11/6.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowMetaDataCell.h"
#import "ServiceHelper.h"
#import "BasicViewController.h"
@interface MediaViewController : BasicViewController<ServiceHelperDelegate,UITableViewDataSource,UITableViewDelegate,ShowMetaDataDelegate,UISearchBarDelegate>{
    NSString *currentTitle;
    ServiceHelper *helper;
    int curPage;
    int maxPage;
    

    BOOL isFirstLoad;
    
    int chooseImg;
}
@property (retain, nonatomic) IBOutlet UITableView *tabView;
@property(nonatomic,retain) NSMutableArray *sourceData;
@property(nonatomic,retain) NSMutableArray *listData;
@property(nonatomic,retain) NSMutableArray *heightData;
@property(nonatomic,retain) NSString *KeyWord;


- (IBAction)buttonSearchMovie:(id)sender;
-(void)clearChildsView;
-(void)startLoadData;
-(void)defaultLoadData;



@end
