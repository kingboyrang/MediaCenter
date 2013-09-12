//
//  CommonMetaDetailViewController.m
//  MediaCenter
//
//  Created by aJia on 12/12/18.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "CommonMetaDetailViewController.h"
#import "MediaSoapMessage.h"
#import "SoapXmlParseHelper.h"
#import "ImageScroll.h"
#import "MovieScroll.h"
#import "SearchMetaData.h"
#import "AlterMessage.h"
#import "FileHelper.h"
#import "PreviewImageViewController.h"
#import "FileDownloadManager.h"
@interface CommonMetaDetailViewController ()

@end

@implementation CommonMetaDetailViewController
@synthesize itemMetaData,listData,currentMetaData;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     MovieScroll *movie=(MovieScroll*)[self.view viewWithTag:600];
    if (movie) {
        [movie preStartMovie];//重新准备开始播放
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    //设置logo图标
    [self.navigationItem titleViewBackground];
    //返回
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    [backButton release];
    
    fileHttpRequest=[[FileHttpRequest alloc] initWithDelegate:self];
    
    helper=[[ServiceHelper alloc] initWithDelegate:self];
    self.currentMetaData=[NSMutableDictionary dictionary];
    self.listData=[NSMutableArray array];
    
    changePage=0;
    if (!self.hasNetwork) {
        [self showNoNetworkNotice:nil];
    }else{
      [self showLoadingAnimated:YES];
      NSString  *soapMsg=[MediaSoapMessage SubMetaListSoap:[self.itemMetaData objectForKey:@"META_PK"]];
      [helper AsyServiceMethod:@"GetSubMetaList" SoapMessage:soapMsg];
    }
}
-(void)autoCellWorp:(UITableViewCell*)cell withText:(NSString*)txt{
    cell.detailTextLabel.numberOfLines=0;
    cell.detailTextLabel.lineBreakMode=NSLineBreakByWordWrapping;
    cell.detailTextLabel.text=txt;
}
//重新加载TableView数据
-(void)reloadBindData{
    if ([self.currentMetaData count]>0) {
        
        [self autoCellWorp:self.cellDate withText:[AppHelper formatShowDate:[self.currentMetaData objectForKey:@"REG_DATE"]]];
        [self autoCellWorp:self.cellCName withText:[self.currentMetaData objectForKey:@"C_NAME"]];
        
        [self autoCellWorp:self.cellDtype withText:[DataType DataTypeName:[self.itemMetaData objectForKey:@"DTYPE"]]];
       
        
        NSString *filetype=@"";
        if ([self.itemMetaData objectForKey:@"CATEGORY_NAME"]!=nil){
            filetype=[self.itemMetaData objectForKey:@"CATEGORY_NAME"];
        }
        [self autoCellWorp:self.cellFileType withText:filetype];
       
        NSString *memo=@"";
        if ([self.currentMetaData objectForKey:@"SUB_DESCRIPTION"]!=nil) {
            memo=[self.currentMetaData objectForKey:@"SUB_DESCRIPTION"];
        }
        if ([memo length]<=50) {
            [self autoCellWorp:self.cellMemo withText:memo];
            self.cellExplain.frame=CGRectMake(0, 0, self.view.frame.size.width, 0);
            NSIndexPath *indexPath=[self.tableView indexPathForCell:self.cellExplain];
            [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:indexPath];
        }else{
            self.cellExplain.textLabel.font=[UIFont boldSystemFontOfSize:15];
            self.cellExplain.textLabel.numberOfLines=0;
            self.cellExplain.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
            self.cellExplain.textLabel.text=memo;
        }
    
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -
#pragma MovieScroll delegate Methods
-(void)stopMovieScroll:(int)curMovie{
    if ([self.listData count]>0) {
        selectRow=curMovie;
        [self.currentMetaData removeAllObjects];
        [self.currentMetaData addEntriesFromDictionary:[self.listData objectAtIndex:curMovie]];
        [self reloadBindData];//重新加载TableView数据
    }
}
#pragma -
#pragma ImageScroll delegate Methods
-(void)stopImageScroll:(int)curImg{
    if ([self.listData count]>0) {
        selectRow=curImg;
        [self.currentMetaData removeAllObjects];
        [self.currentMetaData addEntriesFromDictionary:[self.listData objectAtIndex:curImg]];
        [self reloadBindData];//重新加载TableView数据
    }
}
-(void)currentClickImage:(int)curImg{
    ImageScroll *scroll=(ImageScroll*)[self.view viewWithTag:500];
    if(scroll){
        UIStoryboard *sotryboard=self.storyboard;
        PreviewImageViewController *preview=[sotryboard instantiateViewControllerWithIdentifier:@"PreviewImageViewController"];
        preview.listData=scroll.listData;
        preview.curPage=curImg;
        [self presentViewController:preview animated:YES completion:nil];
        
    }
}
#pragma -
#pragma servicehelper delegate Methods
-(void)finishSuccessRequest:(NSString*)responseText responseData:(NSData*)requestData{
    //NSLog(@"xml=\n%@\n",responseText);
    self.listData=[SoapXmlParseHelper DataTableToArray:responseText];
    [self.currentMetaData removeAllObjects];
    if ([self.listData count]>0) {
        NSDictionary *dic=[self.listData objectAtIndex:0];
        [self.currentMetaData addEntriesFromDictionary:dic];
    }
    CGFloat h=196;
    if ([AppHelper isIPad]) {
        h=395;
    }
    //資料別 1:圖片； 2：影音；3：聲音；4：檔案
    int type=[[self.itemMetaData objectForKey:@"DTYPE"] intValue];
    if (type==1) {//图片
        NSMutableArray *imageArr=[NSMutableArray array];
        for (NSDictionary *dic in self.listData) {
            NSString *imgUrl=[SearchMetaData formatImageUrl:[dic objectForKey:@"ImgPath"]];
            [imageArr addObject:imgUrl];
        }
        //NSLog(@"img=%@\n",imageArr);
        ImageScroll *imageScroll=[[ImageScroll alloc] initWithData:imageArr frame:CGRectMake(5,5, self.view.frame.size.width-10, h)];
        imageScroll.tag=500;
        imageScroll.backgroundColor=[UIColor grayColor];
        imageScroll.delegate=self;
        //[self.view addSubview:imageScroll];
        [self.cellShowImg.contentView addSubview:imageScroll];
        [imageScroll release];
    }else if(type==2||type==3){//影音,声音
        NSMutableArray *movieArr=[NSMutableArray array];
        NSMutableArray *youtubeArr=[NSMutableArray array];
        int index=0;
        for (NSDictionary *dic in self.listData) {
            if (type==2) {//影音
                if ([dic objectForKey:@"YoutubeVideo"]!=nil&&[[dic objectForKey:@"YoutubeVideo"] length]>0) {
                    [youtubeArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"YoutubeVideo"],@"value",[NSString stringWithFormat:@"%d",index],@"key", nil]];
                }
                [movieArr addObject:[SearchMetaData formatImageUrl:[dic objectForKey:@"MP4Path"]]];
            }else{//声音
                [movieArr addObject:[SearchMetaData formatImageUrl:[dic objectForKey:@"DownLoadPath"]]];
            }
            index++;
            
        }
        //NSLog(@"youtubeArr=%@\n",youtubeArr);
        //MovieScroll *movieScroll=[[MovieScroll alloc] initWithData:movieArr frame:CGRectMake(0, 0, self.view.frame.size.width, h)];
       MovieScroll *movieScroll=[[MovieScroll alloc] initWithData:movieArr youtube:youtubeArr frame:CGRectMake(0, 0, self.view.frame.size.width, h)];
        movieScroll.tag=600;
        movieScroll.delegate=self;
        //[self.view addSubview:movieScroll];
        [self.cellShowImg.contentView addSubview:movieScroll];
        [movieScroll release];
        
    }else{//档案
        self.cellShowImg.frame=CGRectMake(0, 0, self.view.frame.size.height, 0);
        NSIndexPath *indexPath=[self.tableView indexPathForCell:self.cellShowImg];
        [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:indexPath];
    }
    [self reloadBindData];//重新加载TableView数据
    [self hideLoadingViewAnimated:YES];
}
-(void)finishFailRequest:(NSError*)error{
    [self hideLoadingViewAnimated:YES completed:^(AnimateLoadView *hideView) {
        [hideView.activityIndicatorView stopAnimating];
        [self showErrorNoticeWithTitle:@"沒有返回數據" message:@"加載失敗!" dismiss:nil];
    }];
}
#pragma mark - Table view delegate
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
 return cell.frame.size.height;
 }
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//档案下载
- (IBAction)segmentChange:(id)sender {
    //NSLog(@"dic=%@\n",self.currentMetaData);
    UISegmentedControl *segment=(UISegmentedControl*)sender;
    if (segment.selectedSegmentIndex==1) {
        if ([self.currentMetaData count]>0){
            //資料別 1:圖片； 2：影音；3：聲音；4：檔案 DownLoadPath
            int type=[[self.itemMetaData objectForKey:@"DTYPE"] intValue];
            NSString *movieUrl=[self.currentMetaData objectForKey:@"DownLoadPath"];
            if (type==2) {
                movieUrl=[self.currentMetaData objectForKey:@"MP4Path"];
            }
            
            NSString *customFileName=[NSString stringWithFormat:@"%@_%d",[self.currentMetaData objectForKey:@"C_NAME"],selectRow];
            fileHttpRequest.customDownloadFileName=customFileName;
            fileHttpRequest.movieType=[self.itemMetaData objectForKey:@"DTYPE"];
            [fileHttpRequest startFileRequest:movieUrl];
            
        }
        segment.selectedSegmentIndex=0;
    }
}
#pragma mark -
#pragma mark 档案下载请求
-(void)startFileDownload:(NSString*)url withFileName:(NSString*)fileName{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if ([self.itemMetaData objectForKey:@"DEPT_NAME"]!=nil) {
         [dic setObject:[self.itemMetaData objectForKey:@"DEPT_NAME"] forKey:@"dept"];
    }else{
         [dic setObject:@"" forKey:@"dept"];
    }
    [dic setObject:[NSString NewGuid] forKey:@"guid"];
    //資料別 1:圖片； 2：影音；3：聲音；4：檔案
    if ([self.itemMetaData objectForKey:@"DTYPE"]!=nil) {
        [dic setObject:[self.itemMetaData objectForKey:@"DTYPE"] forKey:@"DTYPE"];
    }
    
    //开始下载
    [[FileDownloadManager shareInitialization] downloadFile:url withFileName:fileName withData:dic];

}
- (IBAction)btnPrevClick:(id)sender {
    ImageScroll *scroll=(ImageScroll*)[self.view viewWithTag:500];
    MovieScroll *movie=(MovieScroll*)[self.view viewWithTag:600];
    if (scroll!=nil) {//图片
        [scroll buttonPrevImg];
    }
    if (movie!=nil) {//影音，声音
        [movie loadPrevMovie];
    }
    if (scroll==nil&&movie==nil) {//档案
        if (changePage!=0) {
            changePage--;
            if (changePage<=0) {
                changePage=0;
            }
            selectRow=changePage;
            [self.currentMetaData removeAllObjects];
            [self.currentMetaData addEntriesFromDictionary:[self.listData objectAtIndex:changePage]];
            [self reloadBindData];//重新加载TableView数据
        }
    }
}
- (IBAction)btnNextClick:(id)sender {
    ImageScroll *scroll=(ImageScroll*)[self.view viewWithTag:500];
    MovieScroll *movie=(MovieScroll*)[self.view viewWithTag:600];
    if (scroll!=nil) {//图片
        [scroll buttonNextImg];
    }
    if (movie!=nil) {//影音，声音
        [movie loadNextMovie];
    }
    if (scroll==nil&&movie==nil) {//档案
        if (changePage!=[self.listData count]-1) {
            changePage++;
            if (changePage>=[self.listData count]-1) {
                changePage=[self.listData count]-1;
            }
            selectRow=changePage;
            [self.currentMetaData removeAllObjects];
            [self.currentMetaData addEntriesFromDictionary:[self.listData objectAtIndex:changePage]];
            [self reloadBindData];//重新加载TableView数据
        }
    }

}
//ios 6以下旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    
}
//ios 6旋转
- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    //return UIInterfaceOrientationMaskLandscape;
    //return UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationMaskLandscapeLeft;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //return UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationMaskLandscapeLeft;
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (void)dealloc {
    [_cellShowImg release];
    [_cellDate release];
    [_cellCName release];
    [_cellDtype release];
    [_cellFileType release];
    [_cellMemo release];
    [listData release];
    [itemMetaData release];
    [currentMetaData release];
    [helper release];
    [fileHttpRequest release];
    [_cellExplain release];
    [_barbuttonPrev release];
    [_barbuttonNext release];
    [super dealloc];
}
@end
