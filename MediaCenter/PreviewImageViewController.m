//
//  PreviewImageViewController.m
//  MediaCenter
//
//  Created by aJia on 13/1/3.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "PreviewImageViewController.h"
#import "UIImageView+DispatchLoad.h"
@interface PreviewImageViewController ()

@end

@implementation PreviewImageViewController
@synthesize scrollView,listData,curPage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CGFloat w=self.scrollView.frame.size.width;
    CGFloat h=self.scrollView.frame.size.height;
    //self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, w,h)];
    
    //設定ScrollView捲動區域
    //通常必需大於ScrollerView的顯示區域
    //這樣才需要在ScrollerView中捲動圖片
    [self.scrollView setContentSize:CGSizeMake(w * [self.listData count], h)];
	
    //[self.scrollView setContentSize:CGSizeMake(frame.size.width * [self.listData count], frame.size.height)];
	//開啟捲動分頁功能，如果不需要這個功能關閉即可
    [self.scrollView setPagingEnabled:YES];
    
    //隐藏横向與縱向的捲軸
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
    //在本類別中繼承scrollView的整體事件
    [self.scrollView setDelegate:self];
    
    [self reloadScrollView];//加载图片
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
      self.scrollView.backgroundColor=[UIColor grayColor];
    //self.curPage=0;
    [self.barbuttonBg titleViewBackground];
    // Do any additional setup after loading the view from its nib.
}
-(void)reloadScrollView{
    CGFloat w=self.view.frame.size.width,h=self.view.frame.size.height-44*2;
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)){
        w=self.view.frame.size.height;
        h=self.view.frame.size.width-44*2;
    }

    for (int i=0;i<[self.listData count];i++) {
        UIView *contentImage=[[UIView alloc] initWithFrame:CGRectMake(i*w, 0, w,h)];
        contentImage.backgroundColor=[UIColor clearColor];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, w,h)];
        imageView.tag=100+i;
        [imageView setImageFromUrl:[self.listData objectAtIndex:i]];
        [contentImage addSubview:imageView];
        [imageView release];
        
        [self.scrollView addSubview:contentImage];
        [contentImage release];
    }
    [UIView animateWithDuration:0.5f animations:^(){
        [self.scrollView setContentOffset:CGPointMake(self.curPage*w, 0) animated:NO];
    }];

    //[self.view addSubview:self.scrollView];
}
-(void)resetLocation{    
    CGFloat w=self.view.frame.size.width,h=self.view.frame.size.height-44*2;
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)){
        w=self.view.frame.size.height;
        h=self.view.frame.size.width-44*2;
    }
    for (int i=0; i<[self.listData count]; i++) {
        UIImageView *imageView=(UIImageView*)[self.scrollView viewWithTag:100+i];
        if (imageView) {
            UIView *v=[imageView superview];
            v.frame=CGRectMake(i*w, 0, w, h);
            
            [self resetImageLocation:i];
        }
    }
}
-(void)resetImageLocation:(int)curImg{
    int pos=100+curImg;
    UIImageView *imageView=(UIImageView*)[self.scrollView viewWithTag:pos];
    if (imageView) {
        UIView *v=[imageView superview];
        
        UIImage *orginImage=imageView.image;
        UIImage *handler=[self autoImageSize:orginImage];
        
        imageView.frame=CGRectMake((v.frame.size.width-handler.size.width)/2, (v.frame.size.height-handler.size.height)/2, handler.size.width, handler.size.height);
    }
}

//图片等比缩放
-(UIImage*)autoImageSize:(UIImage*)img{
    CGFloat w=self.view.frame.size.width,h=self.view.frame.size.height-44*2;
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)){
        w=self.view.frame.size.height;
        h=self.view.frame.size.width-44*2;
    }

    CGSize defaultSize=CGSizeMake(w, h);
    CGFloat rotioW=img.size.width/defaultSize.width;
    CGFloat rotioH=img.size.height/defaultSize.height;
    CGSize newSize=img.size;
    if (img.size.width > defaultSize.width|| img.size.height > defaultSize.height){
        if (rotioW>rotioH) {
            newSize.width=defaultSize.width;
            newSize.height=img.size.height/rotioW;
        }else{
            newSize.width=img.size.width/rotioH;
            newSize.height=defaultSize.height;
        }
    }
    return [img imageByScalingToSize:newSize];
}
#pragma -
#pragma UIScrollView delegate Methods
//手指離開螢幕後ScrollView還會繼續捲動一段時間直到停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	//NSLog(@"捲動結束後，緩衝捲動徹底完結時呼叫");
    //[self startMovie:curPage];
    //滚动完成之后执行的事件
    if (self.curPage>=[self.listData count]-1) {
        self.curPage=[self.listData count]-1;
    }
    if (self.curPage<=0) {
        self.curPage=0;
    }
    
    
    //[self.delegate stopImageScroll:curPage];
}

-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
	
	//NSLog(@"捲動結束後，開始緩衝捲動時呼叫");
}

-(void)scrollViewDidScroll:(UIScrollView*)sv
{
	self.curPage=fabs(sv.contentOffset.x/sv.frame.size.width);//取得目前頁面
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    //NSLog(@"捲動圖片開始捲動，它只呼叫一次");
}

-(void)scrollViewDidEndDragging:(UIScrollView*)sv willDecelerate:(BOOL)decelerate
{
	
	//NSLog(@"捲動圖片結束捲動，它只呼叫一次");
	
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonCloseView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//前一张
- (IBAction)buttonPrevImage:(id)sender {
    CGFloat w=self.view.frame.size.width;
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)){
        w=self.view.frame.size.height;
    }

    if (self.curPage!=0) {
        self.curPage--;
        if (self.curPage<=0) {
            self.curPage=0;
        }
       
        [UIView animateWithDuration:0.5f animations:^(){
           [self.scrollView setContentOffset:CGPointMake(self.curPage*w, 0) animated:NO];
        }];
    }

}
//下一张
- (IBAction)buttonNextImage:(id)sender {
    CGFloat w=self.view.frame.size.width;
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)){
        w=self.view.frame.size.height;
    }
    if (self.curPage!=[self.listData count]-1) {
        self.curPage++;
        if (self.curPage>=[self.listData count]-1) {
            self.curPage=[self.listData count]-1;
        }
        [UIView animateWithDuration:0.5f animations:^(){
           [self.scrollView setContentOffset:CGPointMake(self.curPage*w, 0) animated:NO];
        }];
    }
}
//一般用来禁用某些控件或者停止某些正在进行的活动，比如停止视频播放
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    lastCurPage=self.curPage;
}
//一般用来定制翻转后各个控件的位置、大小等
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    CGFloat w=self.view.frame.size.width,h=self.view.frame.size.height-44*2;
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)){
        w=self.view.frame.size.height;
        h=self.view.frame.size.width-44*2;
    }
    
    self.scrollView.frame=CGRectMake(0, 44,w,h);
    [self.scrollView setContentSize:CGSizeMake(w * [self.listData count], h)];
    
    [self resetLocation];
    self.curPage=lastCurPage;
    
    //NSLog(@"UIDeviceOrientationIsLandscapecurPage=%d\n",self.curPage);
        
}
//整个翻转完成之后。一般用来重新启用某些控件或者继续翻转之前被暂停的活动，比如继续视频播放
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    CGFloat w=self.view.frame.size.width;
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)){
        w=self.view.frame.size.height;
    }
    
    
    [UIView animateWithDuration:0.5f animations:^(){
        [self.scrollView setContentOffset:CGPointMake(self.curPage*w, 0) animated:NO];
    }];

}

//for iOS4,iOS5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation!=UIInterfaceOrientationMaskPortraitUpsideDown);
}
/****
//for iOS6
- (BOOL)shouldAutorotate
{
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations{
    //return UIInterfaceOrientationMaskLandscape;
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscape;
}
 ***/
- (void)dealloc {
    [listData release];
    [scrollView release];
    [_barbuttonBg release];
    [super dealloc];
}
@end
