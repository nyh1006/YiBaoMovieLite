//
//  InfoViewController.h
//  OnlineTicket
//
//  Created by MaKai on 12-11-19.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieItem.h"
#import "CinemaItem.h"
#import "DownLoadController.h"
#import "QuitController.h"

@interface InfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,ResponseReceived>
@property (retain, nonatomic) NSString *backButtonTitle;
@property (retain, nonatomic) NSString *currentCity;
@property (retain, nonatomic) MovieItem *movieItem;
@property (retain, nonatomic) CinemaItem *cinemaItem;

- (void)goBack;
@end
