//
//  CinemaHallViewController.h
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-17.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownLoadController.h"

@interface CinemaHallViewController : UITableViewController<NSURLConnectionDataDelegate,UIAlertViewDelegate,ResponseReceived>
@property (retain, nonatomic) NSString *backButtonTitle;
@property (retain,nonatomic) NSString *cinemaId;
@end
