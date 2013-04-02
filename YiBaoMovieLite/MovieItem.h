//
//  MovieItem.h
//  OnlineTicket
//
//  Created by MaKai on 12-11-19.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieItem : NSObject
//影片信息
@property (retain, nonatomic) NSString *movieId;                  //影片编号
@property (retain, nonatomic) NSString *movieName;                //影片名称
@property (assign, nonatomic) NSInteger duration;                 //放映时长
@property (retain, nonatomic) NSString *director;                 //导演
@property (retain, nonatomic) NSString *cast;                     //主演
@property (retain, nonatomic) NSString *thumbnailString;          //小图
@property (retain, nonatomic) UIImage *thumbnail;                 //缓存小图
@property (retain, nonatomic) NSString *poster;                   //大图
@property (retain, nonatomic) NSString *movieDate;                //上映时间
@property (retain, nonatomic) NSString *movieClass;               //影片类型
@property (retain, nonatomic) NSString *movieArea;                //影片地区
@property (retain, nonatomic) NSString *movieDescription;         //影片描述
@property (assign, nonatomic) NSInteger showCount;                //本日上映场次数
@property (retain, nonatomic) NSString *trailerURL;               //预告片地址

@end
