//
//  QuitController.h
//  YiBaoMovieLite
//
//  Created by MaKai on 13-1-8.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownLoadController.h"

@protocol ResponseQuit <NSObject>

- (void)responseQuit;
- (void)responseFail;

@end

@interface QuitController : NSObject<ResponseReceived>
@property (retain, nonatomic) DownLoadController *downloader;
@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSString *responseMessage;
@property (assign, nonatomic) id<ResponseQuit> delegate;

- (void)requestQuit;
@end
