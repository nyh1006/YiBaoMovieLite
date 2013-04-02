//
//  AppDelegate.h
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-11.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestCityController.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) UITabBarController *tabBarController;
@property (retain, nonatomic) UIView *imageView;
@property (retain, nonatomic) RequestCityController *cityRequester;

@end
