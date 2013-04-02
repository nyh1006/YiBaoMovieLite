//
//  DownLoadController.h
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-19.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResponseReceived<NSObject>
@optional
- (void)responseReceived:(NSMutableData *)responseData;
- (void)responseConnection:(NSURLConnection *)connection Received:(NSMutableData *)responseData;
- (void)refreshFail:(NSURLConnection *)connection;
@end

@interface DownLoadController : NSObject<NSURLConnectionDataDelegate>
@property (retain, nonatomic) NSURLConnection *connection;
@property (assign, nonatomic) id<ResponseReceived> delegate;
@property (retain, nonatomic) NSMutableURLRequest *request;

- (id)initWithRequest:(NSMutableURLRequest *)request;
- (void)beginAsyncRequest;
@end
