//
//  MovieViewController.h
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-11.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestCityController.h"
#import "CitySelectViewController.h"
#import "DownLoadController.h"
#import "UserItem.h"
#import "QuitController.h"
#import <QuartzCore/QuartzCore.h>

@interface MovieViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ResponseReceived>
@property (retain, nonatomic) NSString *currentCity;
@property (retain, nonatomic) NSString *lastCity;

@end
