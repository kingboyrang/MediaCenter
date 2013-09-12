//
//  MovieScroll.m
//  MediaCenter
//
//  Created by aJia on 12/11/16.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "MovieScroll.h"

@interface MovieScroll ()
-(void)loadYouTuBeMoive:(NSInteger)index;
@end

@implementation MovieScroll
@synthesize scrollView,listData,delegate;
@synthesize youtubeList=_youtubeList;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadConfigure:frame];
        if (!_webView) {
            _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        }
        
    }
    return self;
}
-(id)initWithData:(NSArray*)arr frame:(CGRect)frame{
    self.listData=arr;
    return [self initWithFrame:frame];
}
-(void)loadConfigure:(CGRect)frame{
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
    
	//設定ScrollView捲動區域
    //通常必需大於ScrollerView的顯示區域
    //這樣才需要在ScrollerView中捲動圖片
    [self.scrollView setContentSize:CGSizeMake(frame.size.width * [self.listData count], frame.size.height)];
	//開啟捲動分頁功能，如果不需要這個功能關閉即可
    [self.scrollView setPagingEnabled:YES];
    
    //隐藏横向與縱向的捲軸
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
    //在本類別中繼承scrollView的整體事件
    [self.scrollView setDelegate:self];
    
    moviePlayer=[[MPMoviePlayerViewController alloc] init];
    
    MPMoviePlayerController *player = [moviePlayer moviePlayer];
    
    //player=[[MPMoviePlayerController alloc] init];
    
    player.shouldAutoplay=NO;
    player.controlStyle=MPMovieControlStyleDefault;//显示播放/暂停、音量和时间控制
    player.scalingMode=MPMovieScalingModeAspectFit;
    //MPMovieControlStyleEmbedded;
    //MPMovieControlStyleDefault
    [player setFullscreen:YES animated:YES];//设置可以全屏
    //设定播放器大小
    player.view.frame=CGRectMake(0, 0, frame.size.width,frame.size.height);
    
    //如果在播放就先停止
    if (player.playbackState==MPMoviePlaybackStatePlaying) {
        [player stop];
    }
    //设置影片url并缓存
    if ([self.listData count]>0) {
         player.contentURL=[NSURL URLWithString:[self.listData objectAtIndex:0]];
        [player prepareToPlay];
    }
    /**
    if (i==0) {
        player.contentURL=[NSURL fileURLWithPath:[self.listData objectAtIndex:i]];
    }else{
        player.contentURL=[NSURL URLWithString:[self.listData objectAtIndex:i]];
    }
     **/
    
    
    //播放影片
    //[player play];
    //影片播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [self.scrollView addSubview:player.view];

    
    [self addSubview:self.scrollView];
    curPage=0;
}
//开始播放影片
-(void)preStartMovie{
   MPMoviePlayerController *player = [moviePlayer moviePlayer];
    //如果在播放就先停止
    if (player.playbackState==MPMoviePlaybackStatePlaying) {
        [player stop];
    }
   [player prepareToPlay];
    
}
//影片播放完成操作
- (void)movieFinishedCallback:(NSNotification*) aNotification{
	MPMoviePlayerController *Movieplayer = [aNotification object];
    [Movieplayer stop];//停止播放影片
    //设定影片url,并影片缓存
	[Movieplayer prepareToPlay];
   	
}
-(void)startMovie:(int)page{
    
     MPMoviePlayerController *player = [moviePlayer moviePlayer];
    //如果在播放就先停止
    if (player.playbackState==MPMoviePlaybackStatePlaying) {
        [player stop];
    }
    player.contentURL=[NSURL URLWithString:[self.listData objectAtIndex:page]];
    [player prepareToPlay];
    CGRect rect=player.view.frame;
    rect.origin.x=rect.size.width*page;
    player.view.frame=rect;
    [self.scrollView setContentOffset:CGPointMake(rect.origin.x, 0) animated:YES];
    

    
    
   
}
#pragma -
#pragma UIScrollView delegate Methods
//手指離開螢幕後ScrollView還會繼續捲動一段時間直到停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	//NSLog(@"捲動結束後，緩衝捲動徹底完結時呼叫");
    [self startMovie:curPage];
    [self.delegate stopMovieScroll:curPage];
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
//前一张影片
-(void)loadPrevMovie{
    if(curPage!=0){
        curPage--;
        if (curPage<=0) {
            curPage=0;
        }
        [self startMovie:curPage];
    }
}
//后一张影片
-(void)loadNextMovie{
    if(curPage!=[self.listData count]-1){
        curPage++;
        if (curPage>=[self.listData count]-1) {
            curPage=[self.listData count]-1;
        }
        [self startMovie:curPage];
    }
}
#pragma mark private methods
-(void)loadYouTuBeMoive:(NSInteger)index{
    if ([self.youtubeList count]>0) {
        
    }
}
-(void)dealloc{
    [super dealloc];
    [scrollView release];
    [listData release];
    //[player release];
    [moviePlayer release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_webView) {
        [_webView release],_webView=nil;
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

@end
