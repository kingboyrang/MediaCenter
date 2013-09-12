//
//  FileHttpRequest.m
//  MediaCenter
//
//  Created by aJia on 13/1/3.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "FileHttpRequest.h"
#import "AlterMessage.h"
#import "FileHelper.h"
#import "PreviewDataSource.h"
#import "LLFileVC.h"
#import "OpenHttpFileViewController.h"
@implementation FileHttpRequest
@synthesize httpRequest,customDownloadFileName,movieDownloadUrl,movieDownloadName;
@synthesize delegate,movieType;
-(id)initWithDelegate:(id<FileHttpRequestDelegate>)theDelegate{
    if (self=[super init]) {
        self.delegate=theDelegate;
    }
    return self;
}
-(void)startFileRequest:(NSString*)url{
    self.movieDownloadUrl=url;
    [self.httpRequest setDelegate:nil];
    [self.httpRequest cancel];
    [self setHttpRequest:[ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]]];
    [self.httpRequest setDelegate:self];
    [self.httpRequest startAsynchronous];
}
-(NSString*)requestHeaderFileName:(NSString*)fileName{
    NSString *searchStr=@"filename=";
    NSRange r=[fileName rangeOfString:searchStr];
    if (r.location!=NSNotFound) {
        int pos=r.location;
        fileName=[fileName substringFromIndex:pos+[searchStr length]];
        return fileName;
    }
    return @"";
}
#pragma mark -
#pragma mark ASIHTTPRequest delegate Methods
//下载成功
- (void)requestFinished:(ASIHTTPRequest *)request
{
    //int statusCode = [request responseStatusCode];
	
}
//下载失败
- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.responseStatusCode==0) {
        [AlterMessage initWithMessage:@"無效的下載地址!"];
    }
    
}
//获取请求信息
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    //request.contentLength/1024
    if (request.contentLength<=0) {
        [request clearDelegatesAndCancel];//取消请求
        [AlterMessage initWithMessage:@"下載的檔案不存在!"];
        return;
    }
    NSString *fileName=@"";
    if ([responseHeaders objectForKey:@"Content-Disposition"]) {
        fileName=[self requestHeaderFileName:[responseHeaders objectForKey:@"Content-Disposition"]];
    }
    const unsigned int bytes = 1024;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"##0.00"];
    NSNumber *total = [NSNumber numberWithFloat:(request.contentLength / bytes)];
    NSString *fileSize=[NSString stringWithFormat:@"%@KB",[formatter stringFromNumber:total]];
    [formatter release];
    [request cancel];//取消请求
    //NSLog(@"fileName=%@\n",fileName);
    NSString *saveName=@"";
    if(self.customDownloadFileName!=nil){
        if ([fileName length]==0) {
            fileName=[self.movieDownloadUrl pathExtension];
            saveName=[NSString stringWithFormat:@"%@.%@",self.customDownloadFileName,fileName];
        }else{
            saveName=[NSString stringWithFormat:@"%@.%@",self.customDownloadFileName,[fileName pathExtension]];
        }
        
    }else{
        if ([fileName length]==0) {
            fileName=[self.movieDownloadUrl lastPathComponent];
        }
        saveName=fileName;
    }
    
    self.movieDownloadName=saveName;
    NSString *downPath=[DownFileFolderPath stringByAppendingPathComponent:saveName];
    if ([FileHelper isExistsFile:downPath]) {
        [AlterMessage showConfirmAndCancel:@"提示" withMessage:@"當前下載的檔案已存在,是否重新下載?" cancelMessage:@"開啟" confirmMessage:@"確定"
                              cancelAction:^(){//开启档案
                                  [self openFilePreviewUrl:downPath withFileName:saveName isLocationFile:NO];
                              } confirmAction:^(){//下载档案
                                  //开始下载档案
                                  [self startDownLoadHandler];
                              }];
        
        
        return;
    }else{
    [AlterMessage showConfirmAndCancel:@"提示" withMessage:[NSString stringWithFormat:@"是否直接開啟檔案,檔案大小為%@",fileSize] cancelMessage:@"否" confirmMessage:@"是" cancelAction:^(){
    
    
        [AlterMessage showConfirmAndCancel:@"提示" withMessage:@"是否下載檔案至影音收藏?" cancelMessage:@"否" confirmMessage:@"是" cancelAction:^(){} confirmAction:^(){
            
                       //开始下载档案
            [self startDownLoadHandler];
                  
        }];
        
    
    } confirmAction:^(){//直接开启档案
        [self openFilePreviewUrl:self.movieDownloadUrl withFileName:saveName isLocationFile:YES];
    }];
        
    }
   
}
//文件直接开启预览
-(void)openFilePreviewUrl:(NSString*)url withFileName:(NSString*)fileName isLocationFile:(BOOL)boo{
    UIApplication *app=[UIApplication sharedApplication];
    UIWindow *window=[app.delegate window];
    
    UITabBarController *rootController=(UITabBarController*)window.rootViewController;
    NSArray *arr=rootController.viewControllers;
    UINavigationController *nav=(UINavigationController*)[arr objectAtIndex:rootController.selectedIndex];
    
    if (boo) {
        OpenHttpFileViewController *openPreview=[[OpenHttpFileViewController alloc] init];
        openPreview.fileUrl=url;
        openPreview.fileDownLoadName=fileName;
        openPreview.fileType=self.movieType;
        openPreview.title=fileName;
        [nav pushViewController:openPreview animated:YES];
        [openPreview release];
        
    }else{
    
      LLFileVC *previewController=[[LLFileVC alloc] initWithURL:[NSURL fileURLWithPath:url]];
      [nav pushViewController:previewController animated:YES];
      [previewController release];
    }
}
//开始下载文件
-(void)startDownLoadHandler{
    NSString *strName=[DownFileFolderPath stringByAppendingPathComponent:self.movieDownloadName];
    [self.delegate startFileDownload:self.movieDownloadUrl withFileName:strName];
}
//档案下载
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSString *strName=[DownFileFolderPath stringByAppendingPathComponent:self.movieDownloadName];
        [self.delegate startFileDownload:self.movieDownloadUrl withFileName:strName];
    }
}

-(void)dealloc{
    [httpRequest setDelegate:nil];
    [httpRequest cancel];
    [httpRequest release];
    [customDownloadFileName release];
    [movieDownloadUrl release];
    [movieDownloadName release];
    [movieType release];
    [super dealloc];
}
@end
