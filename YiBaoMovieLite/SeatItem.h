//
//  SeatItem.h
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-18.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeatItem : NSObject
@property (retain, nonatomic) NSString *cinemaId;           //影院编号
@property (retain, nonatomic) NSString *hallId;             //影厅编号
@property (retain, nonatomic) NSString *rowId;              //行编号
@property (retain, nonatomic) NSString *rowDesc;            //行说明
@property (retain, nonatomic) NSString *columnId;           //列编号
@property (retain, nonatomic) NSString *columnDesc;         //列说明
@property (retain, nonatomic) NSString *seatType;           //座位类型
@property (retain, nonatomic) NSString *damaged;            //损坏标识
@property (assign, nonatomic) NSInteger status;             //是否已售出
@end
