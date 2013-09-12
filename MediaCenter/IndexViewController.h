//
//  IndexViewController.h
//  MediaCenter
//
//  Created by aJia on 12/12/1.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HappyTypeViewController.h"
#import "ASIHTTPRequest.h"
#import "BasicViewController.h"
@interface IndexViewController : BasicViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    //最新影音
    int curPage;
    int commonPageSize;
    int maxPage;
    BOOL isFirst;
    
    
   //机关类别
    BOOL isorginFirst;
    
    //热门影音
    int hotCurPage;
    int hotMaxPage;
    BOOL ishotFirst;
    BOOL isFirstLoadHot;
    
    //传值处理
    int selectRow;
    int segmentSelect;
}
@property(nonatomic,retain) ASIHTTPRequest *httpRequest;
//幸福宜蘭
@property (retain, nonatomic) IBOutlet UISegmentedControl *SegmentSwitch;
@property(retain,nonatomic) NSMutableArray *typeListData;//happlyListData
@property(retain,nonatomic) UITableView *typeTableView;//happlyTableView
//机关类别
@property(retain,nonatomic) UITableView *orginTableView;
@property(nonatomic,retain) NSMutableArray *orginListData;
//最新影音
@property(retain,nonatomic) UITableView *movieTableView;
@property(nonatomic,retain) NSMutableArray *movieListData;
//热们影音
@property(retain,nonatomic) UITableView *hotTableView;
@property(nonatomic,retain) NSMutableArray *hotListData;
//关键字查询
@property(nonatomic,retain) NSString *KeyWord;
//点击查询按钮时，出现查询对话框
- (IBAction)btnSearchclick:(id)sender;
//点击标签时切换
- (IBAction)SegmentSwitchView:(id)sender;
//请求webservice的方法
-(void)loadMovieData:(NSString*)methodName SoapMessage:(NSString*)soap RequestName:(NSString*)name;
//最新影音
-(void)handlerNewMovie:(NSString*)xml;
//热门影音
-(void)handlerHotMovie:(NSString*)xml;
//幸福宜蘭
-(void)handlerHapplyMovie:(NSString*)xml;
//清除搜寻框
-(void)clearChildsView;
//切换不同的标签
-(void)switchSegmentShow:(int)index;
@end
