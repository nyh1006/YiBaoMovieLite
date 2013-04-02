//
//  UITabBarController+Portrait.m
//  YiBaoMovieLite
//
//  Created by MaKai on 13-3-11.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import "UITabBarController+Portrait.h"

@implementation UITabBarController (Portrait)
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationPortrait;
}
@end
