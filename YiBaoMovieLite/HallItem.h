//
//  HallItem.h
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-22.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HallItem : NSObject
@property (retain, nonatomic) NSString *id;
@property (retain, nonatomic) NSString *hallName;
@property (assign, nonatomic) NSInteger seatCount;
@property (retain, nonatomic) NSString *hallId;
@property (retain, nonatomic) NSString *vip;
@property (assign, nonatomic) NSInteger valid;
@end
