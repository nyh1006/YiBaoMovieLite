//
//  UINavigationController+Portrait.m
//  YiBaoMovieLite
//
//  Created by MaKai on 13-3-12.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import "UINavigationController+Portrait.h"

@implementation UINavigationController (Portrait)
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
