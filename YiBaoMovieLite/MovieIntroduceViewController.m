//
//  MovieIntroduceViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-13.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "MovieIntroduceViewController.h"
#import "VideoItemViewController.h"

@interface MovieIntroduceViewController ()

@end

@implementation MovieIntroduceViewController
@synthesize backButtonTitle = _backButtonTitle;
@synthesize movieItem = _movieItem;
@synthesize mpv = _mpv;

- (void)dealloc
{
    [_backButtonTitle release];
    [_movieItem release];
    [_mpv release];
    
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"影片详情";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
//    UIButton *backButton = [UIButton buttonWithType:101];
//    [backButton setTitle:self.backButtonTitle forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;
//    [backButtonItem release];
    
//    UIBarButtonItem *videoButton = [[UIBarButtonItem alloc] initWithTitle:@"预告片放映" style:UIBarButtonItemStyleBordered target:self action:@selector(broadcast)];
//    self.navigationItem.rightBarButtonItem = videoButton;
//    [videoButton release];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0,320.0, [UIScreen mainScreen].bounds.size.height-110.0)];
    [self.view addSubview:scrollView];
    [scrollView release];
    
    UIImageView *movieImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0,  100.0, 135.0)];
    movieImageView.image = [UIImage imageNamed:@"loading_image@2x.png"];
    [scrollView addSubview:movieImageView];
    [movieImageView release];
    
    // load image using GCD
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获取图片
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.movieItem.poster]];
        UIImage *image= [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // reload image
            movieImageView.image = image;
        });
    });
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 10.0, 170.0, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.movieItem.movieName;
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.textColor = [UIColor whiteColor];
    [scrollView addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *durationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 38.0, 60.0, 20.0)];
    durationNameLabel.backgroundColor = [UIColor clearColor];
    durationNameLabel.text = @"时长：";
    durationNameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    durationNameLabel.textColor = [UIColor whiteColor];
    [scrollView addSubview:durationNameLabel];
    [durationNameLabel release];
    
    UILabel *durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(190.0, 38.0, 110.0, 20.0)];
    durationLabel.backgroundColor = [UIColor clearColor];
    durationLabel.text = [NSString stringWithFormat:@"%d分钟",self.movieItem.duration];
    durationLabel.font = [UIFont systemFontOfSize:15.0];
    durationLabel.textColor = [UIColor whiteColor];
    [scrollView addSubview:durationLabel];
    [durationLabel release];
    
    UILabel *dateNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 66.0, 80.0, 20.0)];
    dateNameLabel.backgroundColor = [UIColor clearColor];
    dateNameLabel.text = @"上映日期：";
    dateNameLabel.font = [UIFont systemFontOfSize:15.0];
    dateNameLabel.textColor = [UIColor whiteColor];
    [scrollView addSubview:dateNameLabel];
    [dateNameLabel release];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(210.0, 66.0, 90.0, 20.0)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.text = [self.movieItem.movieDate substringToIndex:9];
    dateLabel.font = [UIFont systemFontOfSize:15.0];
    dateLabel.textColor = [UIColor whiteColor];
    [scrollView addSubview:dateLabel];
    [dateLabel release];
    
    UILabel *areaNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 92.0, 60.0, 20.0)];
    areaNameLabel.backgroundColor = [UIColor clearColor];
    areaNameLabel.text = @"产地：";
    areaNameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    areaNameLabel.textColor = [UIColor whiteColor];
    [scrollView addSubview:areaNameLabel];
    [areaNameLabel release];
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(190.0, 92.0, 60.0, 20.0)];
    areaLabel.backgroundColor = [UIColor clearColor];
    areaLabel.text = self.movieItem.movieArea;
    areaLabel.font = [UIFont systemFontOfSize:15.0];
    areaLabel.textColor = [UIColor whiteColor];
    [scrollView addSubview:areaLabel];
    [areaLabel release];
    
    UILabel *classNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 120.0, 60.0, 20.0)];
    classNameLabel.backgroundColor = [UIColor clearColor];
    classNameLabel.text = @"类别：";
    classNameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    classNameLabel.textColor = [UIColor whiteColor];
    [scrollView addSubview:classNameLabel];
    [classNameLabel release];
    UILabel *classLabel = [[UILabel alloc] initWithFrame:CGRectMake(190.0, 120.0, 110.0, 20.0)];
    classLabel.backgroundColor = [UIColor clearColor];
    classLabel.text = self.movieItem.movieClass;
    classLabel.font = [UIFont systemFontOfSize:15.0];
    classLabel.textColor = [UIColor whiteColor];
    [scrollView addSubview:classLabel];
    [classLabel release];
    
    UILabel *directorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 160.0, 60.0, 20.0)];
    directorNameLabel.backgroundColor = [UIColor clearColor];
    directorNameLabel.text = @"导演:";
    directorNameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    directorNameLabel.textColor = [UIColor whiteColor];
    [scrollView addSubview:directorNameLabel];
    [directorNameLabel release];
    UILabel *directorLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 160.0, 230.0, 20.0)];
    directorLabel.backgroundColor = [UIColor clearColor];
    NSString *director = self.movieItem.director;
    directorLabel.text = director;
    directorLabel.font = [UIFont systemFontOfSize:15.0];
    directorLabel.textColor = [UIColor whiteColor];
    [scrollView addSubview:directorLabel];
    [directorLabel release];
    
    UILabel *castNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 190.0, 60.0, 20.0)];
    castNameLabel.backgroundColor = [UIColor clearColor];
    castNameLabel.text = @"演员：";
    castNameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    castNameLabel.textColor = [UIColor whiteColor];
    [scrollView addSubview:castNameLabel];
    [castNameLabel release];
    
    UILabel *castLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 215.0, 300.0, 0.0)];
    castLabel.backgroundColor = [UIColor clearColor];
    castLabel.text = self.movieItem.cast;
    castLabel.font = [UIFont systemFontOfSize:15.0];
    castLabel.textColor = [UIColor whiteColor];
    castLabel.numberOfLines = 0;
    CGSize castSize = CGSizeMake(300.0, 10000.0);
    CGSize castLabelSize = [castLabel.text sizeWithFont:castLabel.font constrainedToSize:castSize];
    [castLabel setFrame:CGRectMake(10.0, 215.0, 300.0, castLabelSize.height)];
    [scrollView addSubview:castLabel];
    [castLabel release];
    
    
    UILabel *seperator = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 225.0+castLabelSize.height, 320.0, 20.0)];
    seperator.backgroundColor = [UIColor lightGrayColor];
    seperator.text = @"  简介";
    seperator.font = [UIFont boldSystemFontOfSize:15.0];
//    seperator.textColor = [UIColor colorWithRed:0.6 green:0.9 blue:0.9 alpha:1.0];
    [scrollView addSubview:seperator];
    [seperator release];
    
    UILabel *discriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 250.0+castLabelSize.height, 300.0, 0.0)];
    discriptionLabel.backgroundColor = [UIColor clearColor];
    NSString *description = [self.movieItem.movieDescription stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"　 "]];
    if ([description isEqualToString:@""]||!description) {
        description = @"暂无";
    }
    discriptionLabel.text = description;
    discriptionLabel.font = [UIFont systemFontOfSize:15.0];
    discriptionLabel.textColor = [UIColor whiteColor];
    discriptionLabel.numberOfLines = 0;
    CGSize size = CGSizeMake(300.0, 10000.0);
    CGSize labelSize = [discriptionLabel.text sizeWithFont:discriptionLabel.font constrainedToSize:size];
    [discriptionLabel setFrame:CGRectMake(10.0, 250.0+castLabelSize.height, 300.0, labelSize.height)];
    [scrollView addSubview:discriptionLabel];
    [discriptionLabel release];
    
    scrollView.contentSize = CGSizeMake(320.0, 255.0+castLabelSize.height+labelSize.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)broadcast
{
    NSLog(@"---%@---",self.movieItem.trailerURL);
//    NSRange range = [self.movieItem.trailerURL rangeOfString:@"http://"];
//    if (range.location != NSNotFound)
//    {
//        NSString *trailer = [self.movieItem.trailerURL substringFromIndex:range.location];
//        NSRange toRange = [trailer rangeOfString:@".swf"];
//        NSString *trailerURL = [trailer substringToIndex:toRange.location+4];
    
//        VideoItemViewController *videoItemVC = [[VideoItemViewController alloc] init];
//        videoItemVC.trailerURL = trailerURL;
//        [self.navigationController pushViewController:videoItemVC animated:YES];
//        [videoItemVC release];
        
        //创建视频播放ViewController
//        MPMoviePlayerViewController *mpv = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:trailerURL]];
//        self.mpv = mpv;
//        [mpv release];
//        
//        //监听播放状态通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPlaying) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
//        
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//        
//        [self.mpv.moviePlayer prepareToPlay];
        
        
//    }
//    else {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无预告片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//        [alertView release];
//    }
}

- (void)startPlaying
{
    //注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //判断预加载状态
    if (self.mpv.moviePlayer.loadState != MPMovieLoadStateUnknown) {
        [self presentMoviePlayerViewControllerAnimated:self.mpv];
    }
}
@end
