//
//  CinemaItem.m
//  OnlineTicket
//
//  Created by MaKai on 12-11-20.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "CinemaItem.h"

@implementation CinemaItem
@synthesize cinemaId = _cinemaId;
@synthesize cinemaName = _cinemaName;
@synthesize cinemaLocation = _cinemaLocation;
@synthesize cinemaHallcount = _cinemaHallcount;
@synthesize cinemaAddress = _cinemaAddress;
@synthesize cinemaBusline = _cinemaBusline;
@synthesize cinemaDescription = _cinemaDescription;
@synthesize cinemaPhoto = _cinemaPhoto;
@synthesize cinemaCityId = _cinemaCityId;
@synthesize cinemaDistrictId = _cinemaDistrictId;
@synthesize cinemaDistrictName = _cinemaDistrictName;
@synthesize cinemaFilmShowCount = _cinemaFilmShowCount;
@synthesize cinemaMapLocation = _cinemaMapLocation;

- (void)dealloc
{
    [_cinemaId release];
    [_cinemaName release];
    [_cinemaLocation release];
    [_cinemaAddress release];
    [_cinemaBusline release];
    [_cinemaDescription release];
    [_cinemaPhoto release];
    [_cinemaDistrictName release];
    [_cinemaMapLocation release];
    
    [super dealloc];
}

@end
