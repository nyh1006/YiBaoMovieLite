//
//  InfoViewController.m
//  OnlineTicket
//
//  Created by MaKai on 12-11-19.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "InfoViewController.h"
#import "LoginViewController.h"
#import "GDataXMLNode.h"
#import "InfoItem.h"
#import "MovieIntroduceViewController.h"
#import "CinemaIntroduceViewController.h"
#import "SeatSelectViewController.h"
#import "UserItem.h"
#import "MBProgressHUD.h"

@interface InfoViewController ()
@property (retain, nonatomic) UIBarButtonItem *rightBarButtonItem;
@property (retain, nonatomic) QuitController *quitController;
@property (retain, nonatomic) UIScrollView *scrollView;
@property (retain, nonatomic) UISegmentedControl *buttonSegmentedControl;
@property (retain, nonatomic) UISegmentedControl *segmentedControl;
@property (retain, nonatomic) UIView *tableDisplayView;
@property (retain, nonatomic) UITableView *todayItemTable;
@property (retain, nonatomic) UITableView *tomorrowItemTable;
@property (retain, nonatomic) UIRefreshControl *todayRefreshControl;
@property (retain, nonatomic) UIRefreshControl *tomorrowRefreshControl;
@property (retain, nonatomic) UILabel *todayRefreshLabel;
@property (retain, nonatomic) UILabel *tomorrowRefreshLabel;
@property (retain, nonatomic) UIView *headerView;
@property (retain, nonatomic) UIImageView *imageView;
@property (retain, nonatomic) NSURLConnection *todayConnection;
@property (retain, nonatomic) NSURLConnection *tomorrowConnection;
@property (retain, nonatomic) DownLoadController *todayDownloader;
@property (retain, nonatomic) DownLoadController *tomorrowDownloader;
@property (retain, nonatomic) MBProgressHUD *todayHud;
@property (retain, nonatomic) MBProgressHUD *tomorrowHud;
@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSArray *todayInfos;
@property (retain, nonatomic) NSArray *tomorrowInfos;
@end

@implementation InfoViewController
{
    BOOL isTomorrowRefresh;
//    BOOL isTodayScrollToTop;
//    BOOL isTomorrowScrollToTop;
    NSUInteger isTodayRefreshing;
    NSUInteger isTomorrowRefreshing;
}
@synthesize backButtonTitle = _backButtonTitle;
@synthesize movieItem = _movieItem;
@synthesize cinemaItem = _cinemaItem;
@synthesize rightBarButtonItem = _rightBarButtonItem;
@synthesize quitController = _quitController;
@synthesize scrollView = _scrollView;
@synthesize buttonSegmentedControl = _buttonSegmentedControl;
@synthesize segmentedControl = _segmentedControl;
@synthesize tableDisplayView = _tableDisplayView;
@synthesize todayItemTable = _todayItemTable;
@synthesize tomorrowItemTable = _tomorrowItemTable;
@synthesize todayRefreshControl = _todayRefreshControl;
@synthesize tomorrowRefreshControl = _tomorrowRefreshControl;
@synthesize todayRefreshLabel = _todayRefreshLabel;
@synthesize tomorrowRefreshLabel = _tomorrowRefreshLabel;
@synthesize headerView = _headerView;
@synthesize imageView = _imageView;
@synthesize todayConnection = _todayConnection;
@synthesize tomorrowConnection = _tomorrowConnection;
@synthesize todayDownloader = _todayDownloader;
@synthesize tomorrowDownloader = _tomorrowDownloader;
@synthesize todayHud = _todayHud;
@synthesize tomorrowHud = _tomorrowHud;
@synthesize responseData = _responseData;
@synthesize todayInfos = _todayInfos;
@synthesize tomorrowInfos = _tomorrowInfos;

- (void)dealloc
{
    [_backButtonTitle release];
    [_cinemaItem release];
    [_movieItem release];
    [_rightBarButtonItem release];
    [_quitController release];
    [_scrollView release];
    [_buttonSegmentedControl release];
    [_segmentedControl release];
    [_tableDisplayView release];
    [_todayItemTable release];
    [_tomorrowItemTable release];
    [_todayRefreshControl release];
    [_tomorrowRefreshControl release];
    [_todayRefreshLabel release];
    [_tomorrowRefreshLabel release];
    [_headerView release];
    [_imageView release];
    [_todayConnection release];
    [_tomorrowConnection release];
    [_todayDownloader release];
    [_tomorrowDownloader release];
    [_todayHud release];
    [_tomorrowHud release];
    [_responseData release];
    [_todayInfos release];
    [_tomorrowInfos release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"选择场次";
    self.view.backgroundColor = [UIColor colorWithWhite:249.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UIButton *backButton = [UIButton buttonWithType:101];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:self.backButtonTitle forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshViews)];
    self.rightBarButtonItem = refreshButton;
    refreshButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = refreshButton;
    [refreshButton release];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backview.jpg"]];
    imageView.frame = CGRectMake(0.0, 0.0, 320.0, [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0);
    [self.view addSubview:imageView];
    [imageView release];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0)];
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    [scrollView release];
    
//    self.scrollView.contentSize = CGSizeMake(320.0, ([[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0)*2);

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, ([[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0))];
    self.headerView = headerView;
    [self.scrollView addSubview:headerView];
    [headerView release];
    
    UIImageView *movieImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, 10.0,  100.0, 135.0)];
    movieImageView.image = [UIImage imageNamed:@"loading_image@2x.png"];
    self.imageView = movieImageView;
    [self.headerView addSubview:movieImageView];
    [movieImageView release];
    
    // load image using GCD
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获取图片
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.movieItem.poster]];
        UIImage *image= [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // reload image
            self.imageView.image = image;
        });
    });
    
    UILabel *movieNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 25.0, 150.0, 30.0)];
    movieNameLabel.backgroundColor = [UIColor clearColor];
    movieNameLabel.text = self.movieItem.movieName;
    movieNameLabel.textColor = [UIColor whiteColor];
    movieNameLabel.font = [UIFont systemFontOfSize:15.0];
    movieNameLabel.numberOfLines = 2;
    [self.headerView addSubview:movieNameLabel];
    [movieNameLabel release];
    
    UILabel *movieDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 65.0, 150.0, 15.0)];
    movieDateLabel.backgroundColor = [UIColor clearColor];
    NSString *date = [NSString stringWithFormat:@"上映日期：%@",[self.movieItem.movieDate substringToIndex:9]];
    movieDateLabel.text = date;
    movieDateLabel.font = [UIFont systemFontOfSize:13.0];
    movieDateLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:movieDateLabel];
    [movieDateLabel release];
    
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 88.0, 150.0, 15.0)];
    areaLabel.backgroundColor = [UIColor clearColor];
    NSString *area = [NSString stringWithFormat:@"地区：%@",self.movieItem.movieArea];
    areaLabel.text = area;
    areaLabel.font = [UIFont systemFontOfSize:13.0];
    areaLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:areaLabel];
    [areaLabel release];
    
    UILabel *movieClassLabel = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 111.0, 150.0, 15.0)];
    movieClassLabel.backgroundColor = [UIColor clearColor];
    movieClassLabel.text = [NSString stringWithFormat:@"类别：%@",self.movieItem.movieClass];
    movieClassLabel.textColor = [UIColor whiteColor];
    movieClassLabel.numberOfLines = 0;
    CGSize maxSize = CGSizeMake(150.0, 30.0);
    movieClassLabel.font = [UIFont systemFontOfSize:13.0];
    CGSize movieClassSize = [movieClassLabel.text sizeWithFont:movieClassLabel.font constrainedToSize:maxSize];
    [movieClassLabel setFrame:CGRectMake(150.0, 111.0, 150.0, movieClassSize.height)];
    [self.headerView addSubview:movieClassLabel];
    [movieClassLabel release];
    
    UILabel *cinemaNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 155.0, 280.0, 15.0)];
    cinemaNameLabel.backgroundColor = [UIColor clearColor];
    cinemaNameLabel.text = @"影院:";
    cinemaNameLabel.font = [UIFont systemFontOfSize:13.0];
    cinemaNameLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:cinemaNameLabel];
    [cinemaNameLabel release];
    
    UILabel *cinemaLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 175.0, 280.0, 15.0)];
    cinemaLabel.backgroundColor = [UIColor clearColor];
    cinemaLabel.text = self.cinemaItem.cinemaName;
    cinemaLabel.font = [UIFont systemFontOfSize:13.0];
    cinemaLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:cinemaLabel];
    [cinemaLabel release];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 200.0, 280.0, 15.0)];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.text = @"简介:";
    descriptionLabel.font = [UIFont systemFontOfSize:13.0];
    descriptionLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:descriptionLabel];
    [descriptionLabel release];
    
    UITextView *descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(15.0, 220.0, 290.0, [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0-75.0-220.0)];
    descriptionView.backgroundColor = [UIColor clearColor];
    NSString *description = [self.movieItem.movieDescription stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"　 "]];
    if ([description isEqualToString:@""]||!description) {
        description = @"暂无";
    }
    descriptionView.text = description;
    descriptionView.textColor = [UIColor whiteColor];
    descriptionView.font = [UIFont systemFontOfSize:13.0];
    descriptionView.editable = NO;
    [self.headerView addSubview:descriptionView];
    [descriptionView release];
    
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0-65.0, 280.0, 15.0)];
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.text = @"欢迎使用易购影票，快去查看场次吧！";
    welcomeLabel.textColor = [UIColor orangeColor];
    welcomeLabel.font = [UIFont systemFontOfSize:13.0];
    [self.headerView addSubview:welcomeLabel];
    [welcomeLabel release];
    
//    UILabel *
    
//    UILabel *castLabel = [[UILabel alloc] initWithFrame:CGRectMake(185.0, [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0-260.0, 130.0, 15.0)];
//    castLabel.backgroundColor = [UIColor clearColor];
//    NSString *cast = [NSString stringWithFormat:@"演员：%@",self.movieItem.cast];
//    castLabel.text = cast;
//    
//    castLabel.textColor = [UIColor whiteColor];
//    castLabel.numberOfLines = 0;
//    CGSize castSize = CGSizeMake(130.0, 100.0);
//    castLabel.font = [UIFont systemFontOfSize:15.0];
//    CGSize castLabelSize = [castLabel.text sizeWithFont:castLabel.font constrainedToSize:castSize];
//    [castLabel setFrame:CGRectMake(185.0, 110.0, 130.0, castLabelSize.height)];
//    [self.headerView addSubview:castLabel];
//    [castLabel release];
    
    
//    UIButton *movieButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    movieButton.frame = CGRectMake(0.0, [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0-75.0, 160.0, 40.0);
//    [movieButton setBackgroundImage:[UIImage imageNamed:@"lightOrange.jpg"] forState:UIControlStateNormal];
////    movieButton.backgroundColor = [UIColor clearColor];
//    [movieButton setTitle:@"影片详情" forState:UIControlStateNormal];
//    [movieButton addTarget:self action:@selector(movieInfo) forControlEvents:UIControlEventTouchUpInside];
//    [self.headerView addSubview:movieButton];
//    
//    UIButton *cinemaButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    cinemaButton.frame = CGRectMake(160.0, [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0-75.0, 160.0, 40.0);
//    [cinemaButton setBackgroundImage:[UIImage imageNamed:@"lightOrange.jpg"] forState:UIControlStateNormal];
////    cinemaButton.backgroundColor = [UIColor clearColor];
//    [cinemaButton setTitle:@"影院详情" forState:UIControlStateNormal];
//    [cinemaButton addTarget:self action:@selector(cinemaInfo) forControlEvents:UIControlEventTouchUpInside];
//    [self.headerView addSubview:cinemaButton];
    NSArray *items = [NSArray arrayWithObjects:@"影片详情", @"查看场次", @"影院详情", nil];
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:items];
    segmentControl.frame = CGRectMake(20.0, [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0-40.0, 280.0, 30.0);
    segmentControl.selected = NO;
    segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
//    segmentControl.tintColor = [UIColor blackColor];
    segmentControl.layer.cornerRadius = 8;
    segmentControl.layer.masksToBounds = YES;
    segmentControl.momentary = YES;
    [segmentControl setBackgroundImage:[UIImage imageNamed:@"orange.jpg"] forState:UIControlStateNormal barMetrics:nil];
    [segmentControl addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventValueChanged];
    self.buttonSegmentedControl = segmentControl;
    [self.headerView addSubview:segmentControl];
    [segmentControl release];
    
//    UIButton *displayButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    displayButton.frame = CGRectMake(0.0, [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0-35.0, 320.0, 35.0);
//    [displayButton setTitle:@"点击查看场次" forState:UIControlStateNormal];
//    [displayButton setBackgroundImage:[UIImage imageNamed:@"orange.jpg"] forState:UIControlStateNormal];
//    [displayButton addTarget:self action:@selector(displayInfo) forControlEvents:UIControlEventTouchUpInside];
//    [self.headerView addSubview:displayButton];
    
    UIButton *backInfoButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backInfoButton.frame = CGRectMake(0.0, [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0, 320.0, 30.0);
    [backInfoButton setTitle:@"返回上页" forState:UIControlStateNormal];
    [backInfoButton setBackgroundImage:[UIImage imageNamed:@"orange.jpg"] forState:UIControlStateNormal];
    [backInfoButton addTarget:self action:@selector(displayIntroduction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:backInfoButton];

    NSArray *itemArray = [NSArray arrayWithObjects:@"当日信息", @"次日信息", nil];
    self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:itemArray] autorelease];
    self.segmentedControl.frame = CGRectMake(0.0, [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0+30.0, 320.0, 50.0);
    self.segmentedControl.tintColor = [UIColor blackColor];
    self.segmentedControl.segmentedControlStyle = UISegmentedControlNoSegment;
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(toggleSegment:) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.segmentedControl];
    
    UIView *tableDisplayView = [[UIView alloc] initWithFrame:CGRectMake(0.0, [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0+80.0, 320.0, [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0-80.0)];
    tableDisplayView.backgroundColor = [UIColor clearColor];
    self.tableDisplayView = tableDisplayView;
    [self.scrollView addSubview:tableDisplayView];
    [tableDisplayView release];
    
//    UITableView *todayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0+80.0, 320.0, [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0-80.0) style:UITableViewStyleGrouped];
    UITableView *todayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0-80.0) style:UITableViewStyleGrouped];
    todayTableView.backgroundView = nil;
//    todayTableView.backgroundColor = [UIColor blackColor];
    todayTableView.delegate = self;
    todayTableView.dataSource = self;
    todayTableView.hidden = NO;
    todayTableView.tag = 0;
    self.todayItemTable = todayTableView;
    [self.tableDisplayView addSubview:todayTableView];
    [todayTableView release];
    
    UITableView *tomorrowTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0-80.0) style:UITableViewStyleGrouped];
    tomorrowTableView.backgroundView = nil;
//    tomorrowTableView.backgroundColor = [UIColor blackColor];
    tomorrowTableView.delegate = self;
    tomorrowTableView.dataSource = self;
    tomorrowTableView.hidden = YES;
    tomorrowTableView.tag = 1;
    self.tomorrowItemTable = tomorrowTableView;
    [self.tableDisplayView addSubview:tomorrowTableView];
    [tomorrowTableView release];
    
    //if 6.0
    if (NSClassFromString(@"UIRefreshControl")) {
        UIRefreshControl *refreshControl1 = [[NSClassFromString(@"UIRefreshControl") alloc] init];
        [refreshControl1 addTarget:self action:@selector(refreshTodayView) forControlEvents:UIControlEventValueChanged];
        self.todayRefreshControl = refreshControl1;
        [self.todayItemTable addSubview:refreshControl1];
        [refreshControl1 release];
        
        UIRefreshControl *refreshControl2 = [[NSClassFromString(@"UIRefreshControl") alloc]     init];
        [refreshControl2 addTarget:self action:@selector(refreshTomorrowView) forControlEvents:UIControlEventValueChanged];
        self.tomorrowRefreshControl = refreshControl2;
        [self.tomorrowItemTable addSubview:refreshControl2];
        [refreshControl2 release];
    }//if 5.0
    else {
        UILabel *refreshLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, -50.0, 320.0, 50.0)];
        refreshLabel1.text = @"下拉刷新列表";
        refreshLabel1.backgroundColor = [UIColor clearColor];
        refreshLabel1.textAlignment = NSTextAlignmentCenter;
        refreshLabel1.textColor = [UIColor blackColor];
        refreshLabel1.font = [UIFont systemFontOfSize:20.0];
        [self.todayItemTable addSubview:refreshLabel1];
        self.todayRefreshLabel = refreshLabel1;
        [refreshLabel1 release];
        
        UILabel *refreshLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, -50.0, 320.0, 50.0)];
        refreshLabel2.text = @"下拉刷新列表";
        refreshLabel2.backgroundColor = [UIColor clearColor];
        refreshLabel2.textAlignment = NSTextAlignmentCenter;
        refreshLabel2.textColor = [UIColor blackColor];
        refreshLabel2.font = [UIFont systemFontOfSize:20.0];
        [self.tomorrowItemTable addSubview:refreshLabel2];
        self.tomorrowRefreshLabel = refreshLabel2;
        [refreshLabel2 release];
    }
    
    isTodayRefreshing = 0;
    isTomorrowRefreshing = 0;
    isTomorrowRefresh = NO;
    [self refreshTodayInfo];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.scrollView.contentOffset.y != [UIScreen mainScreen].applicationFrame.size.height-44.0-49.0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    if (self.todayItemTable.hidden == NO) {
        [self.todayItemTable deselectRowAtIndexPath:[self.todayItemTable indexPathForSelectedRow] animated:YES];
    }
    else if (self.tomorrowItemTable.hidden == NO) {
        [self.tomorrowItemTable deselectRowAtIndexPath:[self.tomorrowItemTable indexPathForSelectedRow] animated:YES];
    }
}

- (void)goBack
{
    self.todayDownloader.delegate = nil;
    self.tomorrowDownloader.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)responseQuit
{
    self.rightBarButtonItem.title = @"登录";
    self.rightBarButtonItem.action = @selector(login);
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
}

- (void)responseConnection:(NSURLConnection *)connection Received:(NSMutableData *)responseData
{
    self.responseData = responseData;
    [self downLoadFinish:connection];
}

- (void)refreshFail:(NSURLConnection *)connection
{
    if (connection == self.todayConnection) {
        isTodayRefreshing --;
        [self.todayHud hide:YES];
    }
    else if (connection == self.tomorrowConnection) {
        isTomorrowRefreshing --;
        [self.tomorrowHud hide:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!NSClassFromString(@"UIRefreshControl")) {
        if (scrollView == self.todayItemTable) {
            if (scrollView.contentOffset.y<-70.0 && !scrollView.decelerating)
            {
                self.todayRefreshLabel.text = @"松开刷新列表";
            }
        }
        else if (scrollView == self.tomorrowItemTable) {
            if (scrollView.contentOffset.y<-70.0 && !scrollView.decelerating) {
                self.tomorrowRefreshLabel.text = @"松开刷新列表";
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!NSClassFromString(@"UIRefreshControl")) {
        if (scrollView == self.todayItemTable) {
            if (scrollView.contentOffset.y<-70.0 && decelerate) {
                [scrollView setContentInset:UIEdgeInsetsMake(70.0, 0.0, 0.0, 0.0)];
                self.todayRefreshLabel.text = @"刷新中...";
                [self refreshTodayView];
            }
        }
        else if (scrollView == self.tomorrowItemTable) {
            if (scrollView.contentOffset.y<-70.0 && decelerate) {
                [scrollView setContentInset:UIEdgeInsetsMake(70.0, 0.0, 0.0, 0.0)];
                self.tomorrowRefreshLabel.text = @"刷新中...";
                [self refreshTodayView];
            }
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        if (scrollView.contentOffset.y == [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0) {
            self.scrollView.contentInset = UIEdgeInsetsMake(-([[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0), 0.0, 0, 0);
        }
        else if (scrollView.contentOffset.y == 0.0) {
            self.scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)displayInfo
{
    [self.scrollView setContentOffset:CGPointMake(0.0, [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0) animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)displayIntroduction
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)movieInfo
{
    MovieIntroduceViewController *movieIntroduceVC = [[MovieIntroduceViewController alloc] init];
    movieIntroduceVC.movieItem = self.movieItem;
    movieIntroduceVC.backButtonTitle = self.navigationItem.title;
    [self.navigationController pushViewController:movieIntroduceVC animated:YES];
    [movieIntroduceVC release];
}

- (void)cinemaInfo
{
    CinemaIntroduceViewController *cinemaIntroduceVC = [[CinemaIntroduceViewController alloc] init];
    cinemaIntroduceVC.cinemaItem = self.cinemaItem;
    cinemaIntroduceVC.backButtonTitle = self.navigationItem.title;
    [self.navigationController pushViewController:cinemaIntroduceVC animated:YES];
    [cinemaIntroduceVC release];
}

- (void)refreshViews
{
    if (self.todayItemTable.hidden == NO) {
        [self refreshTodayView];
    }
    else if (self.tomorrowItemTable.hidden == NO) {
        [self refreshTomorrowView];
    }
}

- (void)toggleButton:(UISegmentedControl *)segmentedControl
{
    NSInteger index = segmentedControl.selectedSegmentIndex;
    if (index == 0) {
        [self movieInfo];
    }
    else if (index == 1){
        [self displayInfo];
    }
    else {
        [self cinemaInfo];
    }
}

- (void)toggleSegment:(UISegmentedControl *)segmentedControl
{
    NSInteger index = segmentedControl.selectedSegmentIndex;
    if (index == 0)
    {
        self.todayItemTable.hidden = NO;
        self.todayHud.hidden = NO;
        self.tomorrowItemTable.hidden = YES;
        self.tomorrowHud.hidden = YES;
        if (isTodayRefreshing == 0) {
            [self.todayItemTable setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
        }
    }
    else if (index == 1)
    {
        self.todayItemTable.hidden = YES;
        self.todayHud.hidden = YES;
        self.tomorrowItemTable.hidden = NO;
        self.tomorrowHud.hidden = NO;
        if (!isTomorrowRefresh) {
            isTomorrowRefresh = YES;
            [self refreshTomorrowView];
        }
        else {
            if (isTomorrowRefreshing == 0) {
                [self.tomorrowItemTable setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
            }
        }
    }
}

- (void)refreshTodayView
{
    if (isTodayRefreshing == 0) {
        [self refreshTodayInfo];
    }
}

- (void)refreshTodayInfo
{
    isTodayRefreshing++;
    NSString *fullpath = [[NSBundle mainBundle] pathForResource:@"request-showtime" ofType:@"xml"];
    NSString *requestString = [NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *todayDateString = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    
    requestString = [[[requestString stringByReplacingOccurrencesOfString:@"$_CINEMAID" withString:self.cinemaItem.cinemaId] stringByReplacingOccurrencesOfString:@"$_MOVIEID" withString:self.movieItem.movieId] stringByReplacingOccurrencesOfString:@"$_DATETIME" withString:todayDateString];
    
    NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://tm.mbpay.cn:8082"]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = requestData;
    
    DownLoadController *downLoadController = [[DownLoadController alloc] initWithRequest:request];
    self.todayConnection = [NSURLConnection connectionWithRequest:request delegate:downLoadController];
    downLoadController.connection = self.todayConnection;
    downLoadController.delegate = self;
    self.todayDownloader = downLoadController;
    [downLoadController beginAsyncRequest];
    [downLoadController release];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableDisplayView animated:YES];
    hud.labelText = @"刷新中...";
    self.todayHud = hud;
}

- (void)refreshTomorrowView
{
    if (isTomorrowRefreshing == 0) {
        [self refreshTomorrowInfo];
    }
}

- (void)refreshTomorrowInfo
{
    isTomorrowRefreshing++;
    NSString *fullpath = [[NSBundle mainBundle] pathForResource:@"request-showtime" ofType:@"xml"];
    NSString *requestString = [NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *tomorrowDateString = [dateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:3600*24]];
    [dateFormatter release];
    
    requestString = [[[requestString stringByReplacingOccurrencesOfString:@"$_CINEMAID" withString:self.cinemaItem.cinemaId] stringByReplacingOccurrencesOfString:@"$_MOVIEID" withString:self.movieItem.movieId] stringByReplacingOccurrencesOfString:@"$_DATETIME" withString:tomorrowDateString];
    
    NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://tm.mbpay.cn:8082"]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = requestData;
    
    DownLoadController *downLoadController = [[DownLoadController alloc] initWithRequest:request];
    self.tomorrowConnection = [NSURLConnection connectionWithRequest:request delegate:downLoadController];
    downLoadController.connection = self.tomorrowConnection;
    downLoadController.delegate = self;
    self.tomorrowDownloader = downLoadController;
    [downLoadController beginAsyncRequest];
    [downLoadController release];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableDisplayView animated:YES];
    hud.labelText = @"刷新中...";
    self.tomorrowHud = hud;
}

- (void)downLoadFinish:(NSURLConnection *)connection
{
    NSLog(@"%@",[[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] autorelease]);
    if (connection == self.todayConnection) {
        if (NSClassFromString(@"UIRefreshControl")) {
            [self.todayRefreshControl performSelector:@selector(endRefreshing)];
        }
        else {
            //5.0
            self.todayRefreshLabel.text = @"下拉刷新列表";
            SEL theSelector = NSSelectorFromString(@"setContentInset:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[NSMethodSignature instanceMethodSignatureForSelector:theSelector]];
            invocation.target = self.todayItemTable;
            invocation.selector = theSelector;
            UIEdgeInsets insets = UIEdgeInsetsMake(-50.0, 0.0, 0.0, 0.0);
            [invocation setArgument:&insets atIndex:2];
            [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:NO];
        }
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.responseData options:0 error:nil];
        NSArray *infoNodes = [document nodesForXPath:@"//root//body//rows//wp_show" error:nil];
        if (infoNodes && [infoNodes count]>0)
        {
            NSMutableArray *unsortedInfos = [NSMutableArray array];
            for(GDataXMLElement *infoNode in infoNodes)
            {
                InfoItem *infoItem = [[InfoItem alloc] init];
                infoItem.showID = [[infoNode attributeForName:@"id"] stringValue];
                infoItem.showDate = [[infoNode attributeForName:@"showdate"] stringValue];
//                infoItem.hallID = [[[infoNode attributeForName:@"hallid"] stringValue] intValue];
                infoItem.hallID = [[infoNode attributeForName:@"hallid"] stringValue];
                infoItem.hallName = [[infoNode attributeForName:@"hallname"] stringValue];
                infoItem.cinemaID = [[infoNode attributeForName:@"cinemaid"] stringValue];
                infoItem.movieID = [[infoNode attributeForName:@"filmid"] stringValue];
                infoItem.movieName = [[infoNode attributeForName:@"filmname"] stringValue];
                infoItem.movieLanguage = [[infoNode attributeForName:@"filmlanguage"] stringValue];
                infoItem.movieTime = [[[[infoNode attributeForName:@"filmtime"] stringValue] substringFromIndex:11] substringToIndex:5];
                infoItem.movieStatus = [[[infoNode attributeForName:@"filmstatus"] stringValue] intValue];
                infoItem.price = [[[infoNode attributeForName:@"price"] stringValue] doubleValue];
                infoItem.vipPrice = [[[infoNode attributeForName:@"vipprice"] stringValue] doubleValue];
                
                [unsortedInfos addObject:infoItem];
                [infoItem release];
            }
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"movieTime" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            self.todayInfos = [unsortedInfos sortedArrayUsingDescriptors:sortDescriptors];
            [sortDescriptor release];
        }
        else {
            self.todayInfos = [NSArray array];
        }
        [document release];
        
        [self.todayItemTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        if (isTodayRefreshing>0) {
            if (self.todayItemTable.contentOffset.y>0) {
//                [self.todayItemTable setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
                [self performSelectorOnMainThread:@selector(setTodayToTop) withObject:nil waitUntilDone:NO];
            }
            isTodayRefreshing--;
        }
        [self.todayHud hide:YES];
    }
    else if(connection == self.tomorrowConnection) {
        if (NSClassFromString(@"UIRefreshControl")) {
            [self.tomorrowRefreshControl performSelector:@selector(endRefreshing) withObject:nil];
        }
        else {
            //5.0
            self.tomorrowRefreshLabel.text = @"下拉刷新列表";
            SEL theSelector = NSSelectorFromString(@"setContentInset:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[NSMethodSignature instanceMethodSignatureForSelector:theSelector]];
            invocation.target = self;
            invocation.selector = theSelector;
            UIEdgeInsets insets = UIEdgeInsetsMake(-50.0, 0.0, 0.0, 0.0);
            [invocation setArgument:&insets atIndex:2];
            [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:NO];
        }
        
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.responseData options:0 error:nil];
        NSArray *infoNodes = [document nodesForXPath:@"//root//body//rows//wp_show" error:nil];
        if (infoNodes && [infoNodes count]>0)
        {
            NSMutableArray *unsortedInfos = [NSMutableArray array];
            for(GDataXMLElement *infoNode in infoNodes)
            {
                InfoItem *infoItem = [[InfoItem alloc] init];
                infoItem.showID = [[infoNode attributeForName:@"id"] stringValue];
                infoItem.showDate = [[infoNode attributeForName:@"showdate"] stringValue];
                infoItem.hallID = [[infoNode attributeForName:@"hallid"] stringValue];
                infoItem.hallName = [[infoNode attributeForName:@"hallname"] stringValue];
                infoItem.cinemaID = [[infoNode attributeForName:@"cinemaid"] stringValue];
                infoItem.movieID = [[infoNode attributeForName:@"filmid"] stringValue];
                infoItem.movieName = [[infoNode attributeForName:@"filmname"] stringValue];
                infoItem.movieLanguage = [[infoNode attributeForName:@"filmlanguage"] stringValue];
                infoItem.movieTime = [[[[infoNode attributeForName:@"filmtime"] stringValue] substringFromIndex:11] substringToIndex:5];
                infoItem.movieStatus = [[[infoNode attributeForName:@"filmstatus"] stringValue] intValue];
                infoItem.price = [[[infoNode attributeForName:@"price"] stringValue] doubleValue];
                infoItem.vipPrice = [[[infoNode attributeForName:@"vipprice"] stringValue] doubleValue];
                
                [unsortedInfos addObject:infoItem];
                [infoItem release];
            }
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"movieTime" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            self.tomorrowInfos = [unsortedInfos sortedArrayUsingDescriptors:sortDescriptors];
            [sortDescriptor release];
        }
        else {
            self.tomorrowInfos = [NSArray array];
        }
        [document release];
        
        [self.tomorrowItemTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        if (isTomorrowRefreshing>0) {
            if (self.tomorrowItemTable.contentOffset.y>0) {
                [self performSelectorOnMainThread:@selector(setTomorrowToTop) withObject:nil waitUntilDone:NO];
            }
            isTomorrowRefreshing--;
        }
        //dismiss wait view
        [self.tomorrowHud hide:YES];
    }
}

- (void)setTodayToTop
{
    [self.todayItemTable setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
}

- (void)setTomorrowToTop
{
    [self.tomorrowItemTable setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView.tag == 0) {
        if (self.todayInfos && [self.todayInfos count]>0) {
            return [self.todayInfos count];
        }
        else{
            return 1;
        }
    }
    else {
        if (self.tomorrowInfos && [self.tomorrowInfos count]>0) {
            return [self.tomorrowInfos count];
        }
        else{
            return 1;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        if (self.todayInfos && [self.todayInfos count]>0) {
            return 60.0;
        }
        else {
            return [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0-80.0-20.0;
        }
    }
    else {
        if (self.tomorrowInfos && [self.tomorrowInfos count]>0) {
            return 60.0;
        }
        else {
            return [[UIScreen mainScreen] applicationFrame].size.height-49.0-44.0-80.0-20.0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        if (self.todayInfos && [self.todayInfos count]>0) {
            static NSString *CellIdentifier = @"InfoCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
            }
            cell.backgroundColor = [UIColor darkGrayColor];
            
            InfoItem *info = [self.todayInfos objectAtIndex:indexPath.row];
            NSMutableString *text = [NSMutableString string];
            [text appendString:info.movieTime];
            [text appendString:@"  "];
            [text appendString:info.movieLanguage];
            [text appendString:@"  "];
            NSString *priceString = [NSString stringWithFormat:@"%.1f",info.price/100];
            [text appendString:priceString];
            
            [text appendString:@"/"];
            NSString *vipPriceString = [NSString stringWithFormat:@"%.1f",info.vipPrice/100];
            [text appendString:vipPriceString];
            [text appendString:@"元"];
            
            cell.textLabel.text = text;
            //        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            cell.textLabel.numberOfLines = 1;
            cell.textLabel.textColor = [UIColor whiteColor];
            
            NSMutableString *detailText = [NSMutableString string];
            [detailText appendString:@"("];
            [detailText appendString:info.hallID];
//            [detailText appendString:info.hallID];
            [detailText appendString:@"号厅)"];
            cell.detailTextLabel.text = detailText;
            cell.detailTextLabel.textColor = [UIColor orangeColor];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
        else{
            static NSString *CellIdentifier = @"InfoCellNone";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.backgroundColor = [UIColor darkGrayColor];
            cell.textLabel.text = @"暂无场次信息";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:20.0];
            cell.textLabel.textColor = [UIColor whiteColor];
            return cell;
        }
    }
    else {
        if (self.tomorrowInfos && [self.tomorrowInfos count]>0) {
            static NSString *CellIdentifier = @"InfoCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
            }
            cell.backgroundColor = [UIColor darkGrayColor];
            InfoItem *info = [self.tomorrowInfos objectAtIndex:indexPath.row];
            
            NSMutableString *text = [NSMutableString string];
            [text appendString:info.movieTime];
            [text appendString:@"  "];
            [text appendString:info.movieLanguage];
            [text appendString:@"  "];
            NSString *priceString = [NSString stringWithFormat:@"%.1f",info.price/100];
            [text appendString:priceString];
            
            [text appendString:@"/"];
            NSString *vipPriceString = [NSString stringWithFormat:@"%.1f",info.vipPrice/100];
            [text appendString:vipPriceString];
            [text appendString:@"元"];
            
            cell.textLabel.text = text;
            //        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            cell.textLabel.numberOfLines = 1;
            cell.textLabel.textColor = [UIColor whiteColor];
            
            NSMutableString *detailText = [NSMutableString string];
            [detailText appendString:@"("];
            [detailText appendString:info.hallID];
            [detailText appendString:@"号厅)"];
            cell.detailTextLabel.text = detailText;
            cell.detailTextLabel.textColor = [UIColor orangeColor];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
        else{
            static NSString *CellIdentifier = @"InfoCellNone";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            }
            cell.backgroundColor = [UIColor darkGrayColor];
            cell.textLabel.text = @"暂无场次信息";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:20.0];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        if (self.todayInfos && self.todayInfos.count>0) {
            SeatSelectViewController *seatSelectVC = [[SeatSelectViewController alloc] init];
            seatSelectVC.backButtonTitle = self.navigationItem.title;
            seatSelectVC.infoItem = [self.todayInfos objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:seatSelectVC animated:YES];
            [seatSelectVC release];
        }
    }
    else {
        if (self.tomorrowInfos && self.tomorrowInfos.count>0) {
            SeatSelectViewController *seatSelectVC = [[SeatSelectViewController alloc] init];
            seatSelectVC.backButtonTitle = self.navigationItem.title;
            seatSelectVC.infoItem = [self.tomorrowInfos objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:seatSelectVC animated:YES];
            [seatSelectVC release];
        }
    }
}
@end

