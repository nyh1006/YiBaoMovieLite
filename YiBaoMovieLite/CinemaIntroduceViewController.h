//
//  CinemaIntroduceViewController.h
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-13.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CinemaItem.h"
#import "DownLoadController.h"

@interface CinemaIntroduceViewController : UITableViewController<UIScrollViewDelegate, ResponseReceived>
@property (retain, nonatomic) CinemaItem *cinemaItem;
@property (retain, nonatomic) NSString *backButtonTitle;
@end
