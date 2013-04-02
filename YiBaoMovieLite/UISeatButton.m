//
//  UISeatButton.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-21.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "UISeatButton.h"

@implementation UISeatButton
@synthesize rowId = _rowId;
@synthesize columnId = _columnId;
@synthesize position = _position;

- (void)dealloc
{
    [_rowId release];
    [_columnId release];
    
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
