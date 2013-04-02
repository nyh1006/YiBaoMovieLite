//
//  HallItem.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-22.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "HallItem.h"

@implementation HallItem
@synthesize id = _id;
@synthesize hallName = _hallName;
@synthesize seatCount = _seatCount;
@synthesize hallId = _hallId;
@synthesize vip = _vip;
@synthesize valid = _valid;

- (void)dealloc
{
    [_id release];
    [_hallName release];
    [_hallId release];
    [_vip release];
    
    [super dealloc];
}
@end
