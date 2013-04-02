//
//  Info.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-13.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "InfoItem.h"

@implementation InfoItem
@synthesize showID = _showID;
@synthesize showDate = _showDate;
@synthesize showTime = _showTime;
@synthesize hallID = _hallID;
@synthesize hallName = _hallName;
@synthesize cinemaID = _cinemaID;
@synthesize movieID = _movieID;
@synthesize movieName = _movieName;
@synthesize movieLanguage = _movieLanguage;
@synthesize movieTime = _movieTime;
@synthesize movieStatus = _movieStatus;
@synthesize price = _price;
@synthesize vipPrice = _vipPrice;

- (void)dealloc
{
    [_showID release];
    [_showDate release];
    [_showTime release];
    [_hallID release];
    [_hallName release];
    [_cinemaID release];
    [_movieID release];
    [_movieName release];
    [_movieLanguage release];
    [_movieTime release];
    
    [super dealloc];
}
@end
