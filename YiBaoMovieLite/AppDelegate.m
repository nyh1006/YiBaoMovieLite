//
//  AppDelegate.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-11.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "AppDelegate.h"
#import "MovieViewController.h"
#import "MovieCinemaViewController.h"
#import "UserInfoViewController.h"
#import "AboutViewController.h"
#import "LoginViewController.h"

@implementation AppDelegate
{
    NSInteger index;
}
@synthesize tabBarController = _tabBarController;
@synthesize imageView = _imageView;
@synthesize cityRequester = _cityRequester;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [_imageView release];
    [_cityRequester release];
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    MovieViewController *movieViewController = [[MovieViewController alloc] init];
    UINavigationController *movieNavigation = [[UINavigationController alloc] initWithRootViewController:movieViewController];
    [movieViewController release];
    movieNavigation.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"影片" image:[UIImage imageNamed:@"recommendation1.png"] tag:0] autorelease];
    
    MovieCinemaViewController *movieCinemaViewController = [[MovieCinemaViewController alloc] init];
    UINavigationController *cinemaNavigation = [[UINavigationController alloc] initWithRootViewController:movieCinemaViewController];
    [movieCinemaViewController release];
    cinemaNavigation.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"影院" image:[UIImage imageNamed:@"recommendation3.png"] tag:1] autorelease];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *userInfoNavigation = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [loginVC release];
    userInfoNavigation.tabBarItem.title = @"空间";
    userInfoNavigation.tabBarItem.image = [UIImage imageNamed:@"user.png"];
    userInfoNavigation.tabBarItem.tag = 2;
    
    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
    UINavigationController *aboutNavigation = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
    [aboutViewController release];
    aboutNavigation.tabBarItem.title = @"更多";
    aboutNavigation.tabBarItem.image = [UIImage imageNamed:@"moreIcon.png"];
    aboutNavigation.tabBarItem.tag = 3;
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController addChildViewController:movieNavigation];
    [tabBarController addChildViewController:cinemaNavigation];
    [tabBarController addChildViewController:userInfoNavigation];
    [tabBarController addChildViewController:aboutNavigation];
    [movieNavigation release];
    [cinemaNavigation release];
    [userInfoNavigation release];
    [aboutNavigation release];
    tabBarController.delegate = self;
    self.tabBarController = tabBarController;

    
    self.window.rootViewController = tabBarController;
    [tabBarController release];
    
    index = 0;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *cityList = [defaults objectForKey:@"citys"];
    if (!cityList) {
        RequestCityController *cityRequester = [[RequestCityController alloc] init];
        self.cityRequester = cityRequester;
        [cityRequester requestCitys];
        [cityRequester release];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

/*
 该方法用于控制TabBarItem能不能选中，返回NO，将禁止用户点击某一个TabBarItem被选中。但是程序内部还是可以通过直接setSelectedIndex选中该TabBarItem。
 */
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController.tabBarItem.tag == tabBarController.selectedIndex) {
        return NO;
    }
    return YES;
}

//当点击tabBarItem时触发该操作 
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    if(viewController.tabBarItem.tag == 0 || viewController.tabBarItem.tag == 1)
//    {
//        if (tabBarController.selectedIndex == index) {
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        }
//        else {
//            index = tabBarController.selectedIndex;
//        }
//    }
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    tabBarController.navigationController
//}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
