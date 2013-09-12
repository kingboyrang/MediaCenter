//
//  OpenHttpFileViewController.m
//  MediaCenter
//
//  Created by aJia on 13/1/24.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "OpenHttpFileViewController.h"
#import "ImageScroll.h"
#import "MovieScroll.h"
#import "PreviewFileManager.h"
#import "AlterMessage.h"
#import "UIImageView+DispatchLoad.h"
@interface OpenHttpFileViewController ()

@end

@implementation OpenHttpFileViewController
@synthesize fileUrl,fileType,docInteractionController;
@synthesize fileDownLoadName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithURL:(NSURL *)aURL{
    if (self=[super init]) {
        _isShowing = NO;
        _docURL = [aURL retain];
    }
    return self;
}
-(void)showFile{
    if (_docURL) {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:_docURL];
        self.docInteractionController.delegate = self;
        //[self.docInteractionController setName:@"aa"];
        if (![self.docInteractionController presentPreviewAnimated:YES]){
        }
        
        
    }
}
-(void)openWinPreview:(NSString*)filePath{
    _isShowing = NO;
    _docURL = [[NSURL fileURLWithPath:filePath] retain];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.fileType isEqualToString:@"4"]){//档案
    if (!_isShowing) {
        [self showFile];
    }else{
        //[self dismissViewControllerAnimated:NO completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
   }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    _isShowing=NO;
    CGFloat topY=self.view.frame.size.height;
    if (self.navigationController) {
        topY-=self.navigationController.navigationBar.frame.size.height;
    }
    if (self.tabBarController) {
        topY-=self.tabBarController.tabBar.frame.size.height;
    }

    if ([self.fileType isEqualToString:@"4"]) {//档案 
        DownLoadArgs *args=[[[DownLoadArgs alloc] init] autorelease];
        args.downloadUrl=self.fileUrl;
        args.downloadFileName=self.fileDownLoadName;
        args.fileSavePath=[args defaultCacheSavePath];
        if (args.isExistsFileDownload) {//文件已下载
            [self openWinPreview:args.fullSaveFilePath];
        }else{
            __block UIProgressView *_progress=nil;
            __block UILabel *_labTitle=nil;
            if (!_progress) {
                _progress=[[UIProgressView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, (topY-9)/2, 300, 9)];
                CGRect orginRect=_progress.frame;
                NSString *memo=@"正在下載...";
                CGSize textSize=[memo CalculateStringSize:[UIFont boldSystemFontOfSize:17] with:300];
                _labTitle=[[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-textSize.width)/2, orginRect.origin.y-2-textSize.height, textSize.width, textSize.height)];
                _labTitle.text=memo;
                _labTitle.font=[UIFont boldSystemFontOfSize:17];
                _labTitle.textColor=[UIColor whiteColor];
                _labTitle.backgroundColor=[UIColor clearColor];
                
                [self.view addSubview:_progress];
                [self.view addSubview:_labTitle];
            }
            [[PreviewFileManager sharedInstance] startBlockDownLoadFile:args progress:^(ASIHTTPRequest *request){
                [request setShowAccurateProgress:YES];
                [request setDownloadProgressDelegate:_progress];
                
            } finishDownload:^(NSString *filePath){
                [_progress removeFromSuperview];
                _progress=nil;
                [_labTitle removeFromSuperview];
                _labTitle=nil;
                
                [AppHelper addNoBackupAttribute:[NSURL fileURLWithPath:filePath]];
                
                [self openWinPreview:filePath];
                [self showFile];
                
            } failedDownload:^(NSError *error){
                [_progress removeFromSuperview];
                _progress=nil;
                [_labTitle removeFromSuperview];
                _labTitle=nil;
                [AlterMessage initWithMessage:@"檔案加載失敗!"];
            }];
        }
    }else{
        self.view.backgroundColor=[UIColor blackColor];
        
        CGRect scrollframe=CGRectMake(0, 0, self.view.frame.size.width, topY);
        // NSMutableArray *sourceArr=[NSMutableArray arrayWithObjects:self.fileUrl, nil];
        
        if ([self.fileType isEqualToString:@"1"]) {//图片
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:scrollframe];
            [imageView setImageFromUrl:self.fileUrl];
            [self.view addSubview:imageView];
            [imageView release];
            
        }else{//影音
             /***
               CGFloat h=(self.view.frame.size.height*2)/3;
            MoviePlay *player=[[MoviePlay alloc] initWithMovieURL:[NSURL URLWithString:self.fileUrl] withFrame:CGRectMake(0,(topY-h)/2, self.view.frame.size.width, h)];
            [self.view addSubview:player];
            [player release];
           ***/
             MovieScroll *movieScroll=[[MovieScroll alloc] initWithData:[NSMutableArray arrayWithObjects:self.fileUrl, nil] frame:CGRectMake(0,0, self.view.frame.size.width, topY)];
             [self.view addSubview:movieScroll];
             [movieScroll release];
             
        }
    }
    
	// Do any additional setup after loading the view.
}
#pragma mark -
#pragma mark UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller{
    return self.view;
}

- (BOOL)documentInteractionController:(UIDocumentInteractionController *)controller canPerformAction:(SEL)action{
    BOOL canPerform = NO;
    if (action == @selector(copy:))
        canPerform = YES;
    return canPerform;
}

- (BOOL)documentInteractionController:(UIDocumentInteractionController *)controller performAction:(SEL)action{
    BOOL handled = NO;
    if (action == @selector(copy:)){
        handled = YES;
    }
    return handled;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller{
    return self.view.frame;
}

- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller{
    _isShowing = YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft
        || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }else {
        return NO;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [fileUrl release];
    [fileType release];
    [docInteractionController release];
    [_docURL release];
    [fileDownLoadName release];
    
    [super dealloc];
}
@end
