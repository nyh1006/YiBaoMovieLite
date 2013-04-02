//
//  CinemaViewController.h
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-13.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieItem.h"
#import "DownLoadController.h"
#import "QuitController.h"
#import <QuartzCore/QuartzCore.h>

@interface CinemaViewController : UITableViewController<ResponseReceived>
@property (retain, nonatomic) NSString *backButtonTitle;
@property (retain, nonatomic) MovieItem *movieItem;
@property (retain, nonatomic) NSString *currentCity; 
@end
