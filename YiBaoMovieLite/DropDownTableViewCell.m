//
//  DropDownTableViewCell.m
//  YiBaoMovieLite
//
//  Created by MaKai on 13-2-1.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import "DropDownTableViewCell.h"

@implementation DropDownTableViewCell
{
    UIImageView *arrowDown;
    UIImageView *arrowUp;
}
@synthesize isOpen = _isOpen;

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        arrowDown = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowDown.png"]];
        arrowDown.frame = CGRectMake(270.0, 3.0, 30.0, 30.0);
        [self addSubview:arrowDown];
        [arrowDown release];
        
        arrowUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowUp.png"]];
        arrowUp.frame = CGRectMake(270.0, 3.0, 30.0, 30.0);
        arrowUp.hidden = YES;
        [self addSubview:arrowUp];
        [arrowUp release];
    }
    return self;
}

- (void)setOpen
{
    self.isOpen = YES;
    arrowDown.hidden = YES;
    arrowUp.hidden = NO;
}

- (void)setClose
{
    self.isOpen = NO;
    arrowDown.hidden = NO;
    arrowUp.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
