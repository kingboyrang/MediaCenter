//
//  WebVideoViewController.m
//  MediaCenter
//
//  Created by aJia on 13/9/13.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "WebVideoViewController.h"

@interface WebVideoViewController (){
  UIWebView *_webView;
}

@end

@implementation WebVideoViewController
-(void)dealloc{
    [super dealloc];
    [_webView stopLoading];
    [_webView reload],_webView=nil;
}
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
    
    /***
    NSString *htmlString = @"<html><head>\
    <meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = \"100%%\"\"/></head>\
    <body style=\"background:#000;margin-top:0px;margin-left:0px\">\
    <iframe id=\"ytplayer\" type=\"text/html\" width=\"100%%\" height=\"%d\"\
    src=\"http://www.youtube.com/embed/%@?autoplay=1\"\
    frameborder=\"0\"/>\
    </body></html>";
    
    htmlString = [NSString stringWithFormat:htmlString,320, @"72UA4GWMaoo"];
    NSLog(@"%@",htmlString);
    
    [_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://www.youtube.com"]];
     ***/
    
    /***
    NSString *path=[[NSBundle mainBundle] pathForResource:@"youtube" ofType:@"html"];
    NSString *htmlString=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    htmlString = [NSString stringWithFormat:htmlString,@"100%",320, @"72UA4GWMaoo"];
    NSLog(@"%@",htmlString);
    [_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://www.youtube.com"]];
     **/
     NSString *path=[[NSBundle mainBundle] pathForResource:@"youtube" ofType:@"html"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 320)];
    _webView.autoresizesSubviews=YES;
    _webView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //_webView.delegate=self;
    [self.view addSubview:_webView];
    
   
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
