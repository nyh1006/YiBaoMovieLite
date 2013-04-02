//
//  SimpleDateUtil.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-11.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "SimpleDateUtil.h"

@implementation SimpleDateUtil

+ (NSString *)getCurrentDate
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)getTomorrowDate
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:3600*24]];
}

+ (NSString *)getCurrentDateOtherFormat
{
    NSCalendar *cal = [[[NSCalendar alloc] init] autorelease];
    unsigned int unitFlags = NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *dc = [cal components:unitFlags fromDate:[NSDate date]];
    int month = [dc month];
    int day = [dc day];
    
    return [NSString stringWithFormat:@"%d月%d日",month,day];
}

+ (NSString *)getTomorrowDateOtherFormat
{
    NSCalendar *cal = [[[NSCalendar alloc] init] autorelease];
    unsigned int unitFlags = NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *dc = [cal components:unitFlags fromDate:[[NSDate date] dateByAddingTimeInterval:3600*24]];
    int month = [dc month];
    int day = [dc day];
    return [NSString stringWithFormat:@"%d月%d日",month,day];
}

+ (NSString *)getCurrentTime
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)splitContinuedTimeString:(NSString *)timeString
{
    NSMutableString *finalTimeString = [[[NSMutableString alloc] initWithString:timeString] autorelease];
    if (timeString.length == 4) {
        [finalTimeString insertString:@":" atIndex:2];
    }
    else if (timeString.length == 6){
        [finalTimeString insertString:@":" atIndex:2];
        [finalTimeString insertString:@":" atIndex:4];
    }
    else{
        finalTimeString = nil;
    }
    return finalTimeString;
}
@end
