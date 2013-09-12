//
//  CommonMetaDetailViewController.h
//  MediaCenter
//
//  Created by aJia on 12/12/18.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "ImageScroll.h"
#import "MovieScroll.h"
#import "FileHttpRequest.h"
#import "BasicTableViewController.h"
@interface CommonMetaDetailViewController : BasicTableViewController<FileHttpRequestDelegate,MovieScrollDelegate,ImageScrollDelegate,ServiceHelperDelegate>{
    ServiceHelper *helper;
    int selectRow;
    int changePage;
    
    FileHttpRequest *fileHttpRequest;
}
@property (retain, nonatomic) IBOutlet UITableViewCell *cellShowImg;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellDate;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellCName;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellDtype;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellFileType;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellMemo;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellExplain;

@property (retain, nonatomic) IBOutlet UIBarButtonItem *barbuttonPrev;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *barbuttonNext;

@property(nonatomic,retain) NSDictionary *itemMetaData;
@property(nonatomic,retain) NSMutableArray *listData;
@property(nonatomic,retain) NSMutableDictionary *currentMetaData;

-(void)autoCellWorp:(UITableViewCell*)cell withText:(NSString*)txt;
//上一张图片
- (IBAction)btnPrevClick:(id)sender;
//下一张图片
- (IBAction)btnNextClick:(id)sender;


//切换
- (IBAction)segmentChange:(id)sender;
-(void)reloadBindData;

@end
