//
//  SimpleDateUtil.h
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-11.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

@interface SimpleDateUtil : NSObject
+ (NSString *)getCurrentDate;
+ (NSString *)getTomorrowDate;
+ (NSString *)getCurrentDateOtherFormat;
+ (NSString *)getTomorrowDateOtherFormat;
+ (NSString *)getCurrentTime;
+ (NSString *)splitContinuedTimeString:(NSString *)timeString;
@end
