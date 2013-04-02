//
//  MovieCinemaViewController.h
//  YiBaoMovieLite
//
//  Created by MaKai on 13-2-17.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestCityController.h"
#import "CitySelectViewController.h"
#import "DownLoadController.h"
#import "UserItem.h"
#import "QuitController.h"
#import <QuartzCore/QuartzCore.h>

@interface MovieCinemaViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ResponseReceived>
@property (retain, nonatomic) NSString *currentCity;
@property (retain, nonatomic) NSString *lastCity;
@end
