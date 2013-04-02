//
//  CinemaItem.h
//  OnlineTicket
//
//  Created by MaKai on 12-11-20.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CinemaItem : NSObject
//影院信息
@property (retain, nonatomic) NSString *cinemaId;                //影院编号
@property (retain, nonatomic) NSString *cinemaName;              //影院名称
@property (retain, nonatomic) NSString *cinemaLocation;          //城市名称
@property (assign, nonatomic) NSInteger cinemaHallcount;         //厅个数
@property (retain, nonatomic) NSString *cinemaAddress;           //地址
@property (retain, nonatomic) NSString *cinemaBusline;           //乘车路线
@property (retain, nonatomic) NSString *cinemaDescription;       //描述
@property (retain, nonatomic) NSString *cinemaPhoto;             //图片地址
@property (assign, nonatomic) NSInteger cinemaCityId;            //城市编号
@property (assign, nonatomic) NSInteger cinemaDistrictId;        //地区编号
@property (retain, nonatomic) NSString *cinemaDistrictName;      //地区名称
@property (assign, nonatomic) NSInteger cinemaFilmShowCount;     //影片剩余场次数
@property (retain, nonatomic) NSString *cinemaMapLocation;       //地图坐标

@end
