//
//  ImageScroll.m
//  MediaCenter
//
//  Created by aJia on 12/11/21.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "ImageScroll.h"
#import "UIImageView+DispatchLoad.h"
@implementation ImageScroll
@synthesize scrollView,listData,delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadConfigure:frame];
    }
    return self;
}
-(id)initWithData:(NSArray*)arr frame:(CGRect)frame{
    self.listData=arr;
    return [self initWithFrame:frame];
}
-(void)loadConfigure:(CGRect)frame{
    curPage=0;
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
    //設定ScrollView捲動區域
    //通常必需大於ScrollerView的顯示區域
    //這樣才需要在ScrollerView中捲動圖片
    [self.scrollView setContentSize:CGSizeMake(self.frame.size.width * [self.listData count], self.frame.size.height)];
	
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
-(void)reloadScrollView{
    for (int i=0;i<[self.listData count];i++) {
        //NSURL *url=[NSURL URLWithString:[self.listData objectAtIndex:i]];
        //NSData *Imgdata=[NSData dataWithContentsOfURL:url];
        //UIImage *orginImage=[UIImage imageWithData:Imgdata];
        //UIImage *image=[self autoImageSize:orginImage];//图片等比缩放
        
        UIView *contentImage=[[UIView alloc] initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        contentImage.backgroundColor=[UIColor clearColor];
        //CustomizeImageView *imageView=[[CustomizeImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-image.size.width)/2,(self.frame.size.height-image.size.height)/2, image.size.width, image.size.height)];
        
         CustomizeImageView *imageView=[[CustomizeImageView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
        
        imageView.isGature=YES;
        imageView.delegate=self;
        [imageView setImageFromUrl:[self.listData objectAtIndex:i]];
        //[imageView setImage:image];
        [contentImage addSubview:imageView];
        [imageView release];
        
        [self.scrollView addSubview:contentImage];
        [contentImage release];
    }
    [self addSubview:self.scrollView];
}
//图片等比缩放
-(UIImage*)autoImageSize:(UIImage*)img{
    CGSize defaultSize=self.frame.size;
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
    if (curPage>=[self.listData count]-1) {
        curPage=[self.listData count]-1;
    }
    if (curPage<=0) {
        curPage=0;
    }
    [self.delegate stopImageScroll:curPage];
}

-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
	
	//NSLog(@"捲動結束後，開始緩衝捲動時呼叫");
}

-(void)scrollViewDidScroll:(UIScrollView*)sv
{
	curPage=fabs(sv.contentOffset.x/sv.frame.size.width);//取得目前頁面
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    //NSLog(@"捲動圖片開始捲動，它只呼叫一次");
}

-(void)scrollViewDidEndDragging:(UIScrollView*)sv willDecelerate:(BOOL)decelerate
{
	
	//NSLog(@"捲動圖片結束捲動，它只呼叫一次");
	
}
//前一张图片
-(void)buttonPrevImg{
    if (curPage!=0) {
        curPage--;
        if (curPage<=0) {
            curPage=0;
        }
        [self.scrollView setContentOffset:CGPointMake(curPage*self.frame.size.width, 0) animated:YES];
        [self.delegate stopImageScroll:curPage];
    }
}
//下一张图片
-(void)buttonNextImg{
    if (curPage!=[self.listData count]-1) {
        curPage++;
        if (curPage>=[self.listData count]-1) {
            curPage=[self.listData count]-1;
        }
        [self.scrollView setContentOffset:CGPointMake(curPage*self.frame.size.width, 0) animated:YES];
        [self.delegate stopImageScroll:curPage];
    }
}
#pragma mark -
#pragma mark ImageViewDelegate Methods
-(void)imageTouch:(NSSet *)touches withEvent:(UIEvent *)event whichView:(id)imageView{
    int total=[touches count];
    if (total==1) {
        [self.delegate currentClickImage:curPage];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)dealloc{
    [super dealloc];
    [scrollView release];
    [listData release];
}
@end
