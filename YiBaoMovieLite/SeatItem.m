//
//  SeatItem.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-18.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "SeatItem.h"

@implementation SeatItem
@synthesize cinemaId = _cinemaId;
@synthesize hallId = _hallId;
@synthesize rowId = _rowId;
@synthesize rowDesc = _rowDesc;
@synthesize columnId = _columnId;
@synthesize columnDesc = _columnDesc;
@synthesize seatType = _seatType;
@synthesize damaged = _damaged;
@synthesize status = _status;

- (void)dealloc
{
    [_cinemaId release];
    [_hallId release];
    [_rowId release];
    [_rowDesc release];
    [_columnId release];
    [_columnDesc release];
    [_seatType release];
    [_damaged release];
    
    [super dealloc];
}
@end
