//
//  requestCityController.h
//  YiBaoMovieLite
//
//  Created by MaKai on 13-1-5.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownLoadController.h"

@interface RequestCityController : NSObject<ResponseReceived>
@property (retain, nonatomic) DownLoadController *downloader;
@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSMutableArray *responseCitys;

- (void)requestCitys;
@end
