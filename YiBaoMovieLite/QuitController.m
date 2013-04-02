//
//  QuitController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 13-1-8.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import "QuitController.h"
#import "UserItem.h"
#import "MovieConstants.h"
#import "GDataXMLNode.h"

@implementation QuitController
@synthesize downloader = _downloader;
@synthesize responseData = _responseData;
@synthesize responseMessage = _responseMessage;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_downloader release];
    [_responseData release];
    [_responseMessage release];
    
    [super dealloc];
}

- (void)requestQuit
{
    UserItem *userItem = [UserItem sharedUser];
    NSString *fullpath = [[NSBundle mainBundle] pathForResource:@"request-quit" ofType:@"xml"];
    NSString *requestString = [[[NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"$_USERNAME" withString:userItem.userName] stringByReplacingOccurrencesOfString:@"$_PASSWORD" withString:userItem.password];
    NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kMovieAPILocation]];
    request.HTTPBody = requestData;
    request.HTTPMethod = @"POST";
    
    self.downloader.delegate = nil;
    DownLoadController *downloader = [[DownLoadController alloc] initWithRequest:request];
    downloader.delegate = self;
    self.downloader = downloader;
    [downloader beginAsyncRequest];
    [downloader release];
}

- (void)responseReceived:(NSMutableData *)responseData
{
    self.responseData = responseData;
    [self downLoadFinish];
}

- (void)refreshFail:(NSURLConnection *)connection
{
    [self.delegate responseFail];
}

- (void)downLoadFinish
{
    NSLog(@"%@",[[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] autorelease]);
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.responseData options:0 error:nil];
    NSString *responseCd = [[[document nodesForXPath:@"//root//rtn//rcd" error:nil] lastObject] stringValue];
    if ([responseCd isEqualToString:@"00"]) {
        [UserItem setSharedUser:nil];
    }
    
    [self.delegate responseQuit];
    [document release];
    
//    [UserItem isQuit:YES];
//    NSNotification *notification = [NSNotification notificationWithName:@"setQuitOk" object:self];
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
