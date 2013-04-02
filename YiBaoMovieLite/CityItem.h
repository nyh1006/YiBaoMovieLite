//
//  CityItem.h
//  YiBaoMovieLite
//
//  Created by MaKai on 13-2-17.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityItem : NSObject
@property (retain, nonatomic) NSString *cityName;

+ (void)setSharedCity:(CityItem *)cityItem;
+ (CityItem *)sharedCity;
@end
