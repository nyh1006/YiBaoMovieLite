//
//  CityItem.m
//  YiBaoMovieLite
//
//  Created by MaKai on 13-2-17.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import "CityItem.h"

@implementation CityItem
@synthesize cityName = _cityName;

- (void)dealloc
{
    [_cityName release];
    
    [super dealloc];
}

static CityItem *sharedCity = nil;
+ (void)setSharedCity:(CityItem *)cityItem
{
    sharedCity = cityItem;
}

+ (CityItem *)sharedCity
{
    return sharedCity;
}

@end
