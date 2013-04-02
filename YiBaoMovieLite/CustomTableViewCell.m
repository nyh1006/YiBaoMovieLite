//
//  CustomTableViewCell.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-28.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell
@synthesize titleLabel = _titleLabel;
@synthesize contentField = _contentField;

- (void)dealloc
{
    [_titleLabel release];
    [_contentField release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(20.0, 5.0, 60.0, 30.0)];
        titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        [titleLabel release];
        
        UITextField *contentField = [[UITextField alloc] initWithFrame:CGRectMake(80.0, 7.0, 120.0, 30.0)];
        contentField.font = [UIFont systemFontOfSize:14.0];
        self.contentField = contentField;
        [self addSubview:contentField];
        [contentField release];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
