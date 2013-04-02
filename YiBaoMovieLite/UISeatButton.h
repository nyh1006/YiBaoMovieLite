//
//  UISeatButton.h
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-21.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISeatButton : UIButton
@property (retain, nonatomic) NSString *rowId;
@property (retain, nonatomic) NSString *columnId;
@property (assign, nonatomic) NSInteger position;
@end
