//
//  Info.h
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-13.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoItem : NSObject

// 放映场次信息
@property(nonatomic,retain)   NSString *showID;               // 放映流水号
@property(nonatomic,retain)   NSString *showDate;             // 放映日期
@property(nonatomic,retain)   NSString *showTime;             //放映时间
@property(nonatomic,retain)   NSString *hallID;               // 影厅编号
@property(nonatomic,retain)   NSString *hallName;             // 影厅名称
@property(nonatomic,retain)   NSString *cinemaID;             // 影院编号
@property(nonatomic,retain)   NSString *movieID;               // 影片ID
@property(nonatomic,retain)   NSString *movieName;             // 影片名称
@property(nonatomic,retain)   NSString *movieLanguage;         // 影片版本
@property(nonatomic,retain)   NSString *movieTime;             // 放映时间
@property(nonatomic,assign)   NSInteger movieStatus;           // 放映状态
@property(nonatomic,assign)   double price;                 // 价格
@property(nonatomic,assign)   double vipPrice;              // vip价格

@end

