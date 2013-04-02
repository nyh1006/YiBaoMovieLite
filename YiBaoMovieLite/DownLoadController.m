//
//  DownLoadController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-19.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "DownloadController.h"
#import "UserItem.h"
#import "QuitController.h"

@interface DownLoadController ()
@property (retain, nonatomic) NSMutableData *responseData;
@end

@implementation DownLoadController
@synthesize connection = _connection;
@synthesize responseData = _responseData;
@synthesize delegate = _delegate;
@synthesize request = _request;

- (void)dealloc
{
    [_connection release];
    [_responseData release];
    [_request release];
    
    [super dealloc];
}

- (id)initWithRequest:(NSMutableURLRequest *)request
{
    self = [super init];
    if (self) {
        self.request = request;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestOver) name:@"DelegateNilNotification" object:nil];
    }
    return self;
}

- (void)beginAsyncRequest
{
    if (self.connection) {
        [self.connection start];
    }
    else {
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:self.request delegate:self];
        [connection start];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"无网络连接，请待会再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    
    if (self.connection) {
        [self.delegate refreshFail:connection];
    }
    else {
        [self.delegate refreshFail:nil];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.delegate) {
        if (self.connection) {
            [self.delegate responseConnection:self.connection Received:self.responseData];
        }
        else {
            [self.delegate responseReceived:self.responseData];
        }
    }
}
@end
