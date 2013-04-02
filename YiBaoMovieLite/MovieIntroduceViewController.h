//
//  MovieIntroduceViewController.h
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-13.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieItem.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MovieIntroduceViewController : UIViewController
@property (retain, nonatomic) NSString *backButtonTitle;
@property (retain, nonatomic) MovieItem *movieItem;
@property (retain, nonatomic) MPMoviePlayerViewController *mpv;
@end
