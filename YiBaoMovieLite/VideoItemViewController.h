//
//  VideoItemViewController.h
//  YiBaoMovieLite
//
//  Created by MaKai on 13-1-15.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoItemViewController : UIViewController<UIWebViewDelegate>
@property (retain, nonatomic) NSString *trailerURL;
@property (retain, nonatomic) UIWebView *webView;
@property (retain, nonatomic) MPMoviePlayerViewController *mpv;
@end
