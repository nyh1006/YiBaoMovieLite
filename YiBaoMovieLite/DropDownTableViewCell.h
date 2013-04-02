//
//  DropDownTableViewCell.h
//  YiBaoMovieLite
//
//  Created by MaKai on 13-2-1.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownTableViewCell : UITableViewCell
@property (assign, nonatomic) BOOL isOpen;

- (void)setOpen;
- (void)setClose;
@end
