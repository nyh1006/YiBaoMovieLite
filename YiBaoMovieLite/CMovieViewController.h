//
//  CMovieViewController.h
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-13.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CinemaItem.h"
#import "DownLoadController.h"
#import "QuitController.h"
#import <QuartzCore/QuartzCore.h>

@interface CMovieViewController : UIViewController<ResponseReceived,UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) NSString *backButtonTitle;
@property (retain, nonatomic) NSString *currentCity;
@property (retain, nonatomic) CinemaItem *cinemaItem;
@end
