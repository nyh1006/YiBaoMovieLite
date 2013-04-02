//
//  VideoItemViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 13-1-15.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import "VideoItemViewController.h"

@interface VideoItemViewController ()

@end

@implementation VideoItemViewController
@synthesize trailerURL = _trailerURL;
@synthesize webView = _webView;
@synthesize mpv = _mpv;

- (void)dealloc
{
    [_trailerURL release];
    [_webView release];
    [_mpv release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // web view
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 367.0)];
    NSLog(@"%@",self.trailerURL);
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.trailerURL]]];
    webView.delegate = self;
    self.webView = webView;
    [self.view addSubview:webView];
    [webView release];
    
    // unhide system toolbar
    self.navigationController.toolbarHidden = NO;
    
    // buttons
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self.webView action:@selector(goBack)];
    
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self.webView action:@selector(goForward)];
    
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self.webView action:@selector(stopLoading)];
    
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self.webView action:@selector(reload)];
    
    // seperator
    UIBarButtonItem *seperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolbarItems = [NSArray arrayWithObjects:seperator, backButton, seperator, forwardButton, seperator, stopButton, seperator, reloadButton, seperator, nil];
    
    [backButton release];
    [forwardButton release];
    [stopButton release];
    [reloadButton release];
    [seperator release];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
//    MPMoviePlayerViewController *mpv = [MPMoviePlayerViewController]
}
@end
