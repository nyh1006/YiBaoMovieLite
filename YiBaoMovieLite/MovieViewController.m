//
//  MovieViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-11.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieConstants.h"
#import "GDataXMLNode.h"
#import "MovieItem.h"
#import "CinemaItem.h"
#import "CinemaViewController.h"
#import "CMovieViewController.h"
#import "LoginViewController.h"
#import "DropDownTableViewCell.h"
#import "CityItem.h"
#import "MBProgressHUD.h"

@interface MovieViewController ()
@property (retain, nonatomic) NSArray *movieItems;
@property (retain, nonatomic) UIBarButtonItem *refreshButton;
@property (retain, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (retain, nonatomic) UIBarButtonItem *activityIndicatorItem;
@property (retain, nonatomic) UITableView *movieItemTable;
@property (retain, nonatomic) UIButton *titleButton;
@property (retain, nonatomic) QuitController *quitController;
@property (retain, nonatomic) UIRefreshControl *movieRefreshControl;
@property (retain, nonatomic) UILabel *refreshingLabel;
@property (retain, nonatomic) UIImage *placeholderImage;
@property (retain, nonatomic) DownLoadController *downLoader;
@property (retain, nonatomic) MBProgressHUD *hud;
@property (retain, nonatomic) NSMutableData *responseData;
@end

@implementation MovieViewController
{
    NSUInteger isMovieRefreshing;
}
@synthesize movieItems = _movieItems;
@synthesize refreshButton = _refreshButton;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize activityIndicatorItem = _activityIndicatorItem;
@synthesize movieItemTable = _movieItemTable;
@synthesize titleButton = _titleButton;
@synthesize currentCity = _currentCity;
@synthesize lastCity = _lastCity;
@synthesize quitController = _quitController;
@synthesize movieRefreshControl = _movieRefreshControl;
@synthesize refreshingLabel = _refreshingLabel;
@synthesize placeholderImage = _placeholderImage;
@synthesize downLoader = _downLoader;
@synthesize hud = _hud;
@synthesize responseData = _responseData;

- (void)dealloc
{
    [_movieItems release];
    [_refreshButton release];
    [_activityIndicatorView release];
    [_activityIndicatorItem release];
    [_movieItemTable release];
    [_titleButton release];
    [_currentCity release];
    [_lastCity release];
    [_quitController release];
    [_movieRefreshControl release];
    [_refreshingLabel release];
    [_placeholderImage release];
    [_downLoader release];
    [_hud release];
    [_responseData release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"电影票" style:UIBarButtonItemStylePlain target:self action:nil];
//    self.navigationItem.backBarButtonItem = backButton;
//    [backButton release];
    
//    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backview.jpg"]];
    imageView.frame = CGRectMake(0.0, 0.0, 320.0, [[UIScreen mainScreen] applicationFrame].size.height-93.0);
    [self.view addSubview:imageView];
    [imageView release];
    
    UIButton *titleButton= [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0.0, 0.0, 220.0, 35.0);
    self.lastCity = @"北京";
    NSString *title = @"电影票 - ";
    self.currentCity = @"北京";
    if ([self.currentCity rangeOfString:@"市"].location != NSNotFound) {
        title = [[title stringByAppendingString:self.currentCity] stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }
    else{
        title = [title stringByAppendingString:self.currentCity];
    }

    [titleButton setTitle:title forState:UIControlStateNormal];
//    [titleButton addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    self.titleButton = titleButton;
    
    UIImageView *moreView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more@2x"]];
    moreView.frame = CGRectMake(170.0, 7.0, 20.0, 20.0);
    [self.titleButton addSubview:moreView];
    [moreView release];
    self.navigationItem.titleView = self.titleButton;
    
    UIBarButtonItem *cityButton = [[UIBarButtonItem alloc] initWithTitle:@"城市" style:UIBarButtonSystemItemRewind target:self action:@selector(selectCity)];
    self.navigationItem.leftBarButtonItem = cityButton;
    [cityButton release];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshMovieView)];
    self.refreshButton = refreshButton;
    self.navigationItem.rightBarButtonItem = refreshButton;
    [refreshButton release];
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicatorView = activityIndicatorView;
    [activityIndicatorView release];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
    self.activityIndicatorItem = rightBarButtonItem;
    [rightBarButtonItem release];
    
    UITableView *movieTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, [[UIScreen mainScreen] bounds].size.height-113.0) style:UITableViewStylePlain];
    movieTableView.backgroundColor = [UIColor clearColor];
    movieTableView.delegate = self;
    movieTableView.dataSource = self;
    movieTableView.hidden = NO;
    movieTableView.tag = 0;
    self.movieItemTable = movieTableView;
    [self.view addSubview:movieTableView];
    
    //if 6.0
    if (NSClassFromString(@"UIRefreshControl")) {
        UIRefreshControl *refreshControl1 = [[NSClassFromString(@"UIRefreshControl") alloc] init];
        [refreshControl1 addTarget:self action:@selector(refreshMovieInfo) forControlEvents:UIControlEventValueChanged];
        self.movieRefreshControl = refreshControl1;
        [self.movieItemTable addSubview:refreshControl1];
        [refreshControl1 release];
    }//if 5.0
    else{
        UILabel *refreshLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, -50.0, 320.0, 50.0)];
        refreshLabel1.text = @"下拉刷新列表";
        refreshLabel1.backgroundColor = [UIColor clearColor];
        refreshLabel1.textAlignment = NSTextAlignmentCenter;
        refreshLabel1.textColor = [UIColor blackColor];
        refreshLabel1.font = [UIFont systemFontOfSize:20.0];
        [self.movieItemTable addSubview:refreshLabel1];
        self.refreshingLabel = refreshLabel1;
        [refreshLabel1 release];
    }
    
    //place this image hold the imageView before the image
    self.placeholderImage = [UIImage imageNamed:@"loading_image.png"];
    
    isMovieRefreshing = 0;
    [self refreshMovieView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callBackCity:) name:@"SelectCityNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.movieItemTable deselectRowAtIndexPath:[self.movieItemTable indexPathForSelectedRow] animated:NO];
    
    if (![self.currentCity isEqualToString:self.lastCity])
    {
        if (isMovieRefreshing>0) {
            self.downLoader.delegate = nil;
            isMovieRefreshing--;
        }
        [self refreshMovieInfo];
    }
}

- (void)login
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [loginVC release];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self presentViewController:navigation animated:YES completion:^{}];
    [navigation release];
}

- (void)callBackCity:(id)sender
{
//    CityItem *sharedCity = [CityItem sharedCity];
//    self.currentCity = sharedCity.cityName;
    NSNotification *notification =  (NSNotification *) sender;
    self.currentCity = [notification.userInfo objectForKey:@"city"];
    if (![self.currentCity isEqualToString:self.lastCity]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)responseReceived:(NSMutableData *)responseData
{
    self.responseData = responseData;
    [self downLoadFinish];
}

- (void)refreshFail:(NSURLConnection *)connection
{
    isMovieRefreshing --;
    [self.hud hide:YES];
}

- (void)refreshTitleView
{
    NSString *title = @"电影票 - ";
    
    if ([self.currentCity rangeOfString:@"市"].location != NSNotFound) {
        title = [[title stringByAppendingString:self.currentCity] stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }
    else{
        title = [title stringByAppendingString:self.currentCity];
    }
    
    [self.titleButton setTitle:title forState:UIControlStateNormal];
}

- (void)selectCity
{    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *cityList = [defaults objectForKey:@"citys"];
    if (cityList) {
        CitySelectViewController *citySelectVC = [[CitySelectViewController alloc] init];
        citySelectVC.navigationItem.title = @"城市选择";
//        citySelectVC.delegate = self;
        citySelectVC.selectedCity = self.currentCity;
        
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:citySelectVC];
        [citySelectVC release];
        
        [self presentViewController:navigation animated:YES completion:^{}];
        [navigation release];
    }
}

//refresh movie list
- (void)refreshMovieView
{
    if (isMovieRefreshing == 0) {
        [self refreshMovieInfo];
    }
}

- (void)refreshMovieInfo
{
    isMovieRefreshing ++;
    NSString *requestString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"request" ofType:@"xml"] encoding:NSUTF8StringEncoding error:NULL];
    requestString = [[requestString stringByReplacingOccurrencesOfString:@"$_CITYNAME" withString:self.currentCity] stringByReplacingOccurrencesOfString:@"$_MOVIEID" withString:@""];
    
    NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kMovieAPILocation]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = requestData;
    
    DownLoadController *downloader = [[DownLoadController alloc] initWithRequest:request];
    downloader.delegate = self;
    self.downLoader = downloader;
    [downloader beginAsyncRequest];
    [downloader release];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"刷新中..."];
    self.hud = hud;
    
    self.navigationItem.rightBarButtonItem = self.activityIndicatorItem;
    [self.activityIndicatorView startAnimating];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!NSClassFromString(@"UIRefreshControl")) {
//        if (movieScrollToTop>0 && scrollView.isDecelerating) {
//            scrollView.contentInset = UIEdgeInsetsMake(70.0f, 0.0f, 0.0f, 0.0f);
//        }
        if (scrollView.contentOffset.y<-70.0 && !scrollView.decelerating) {
            self.refreshingLabel.text = @"松开刷新列表";
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!NSClassFromString(@"UIRefreshControl")) {
        if (scrollView.contentOffset.y<-70.0 && decelerate)
        {
            [scrollView setContentInset:UIEdgeInsetsMake(70.0, 0.0, 0.0, 0.0)];
           
            self.refreshingLabel.text = @"刷新中";
            
            [self refreshMovieView];
        }
    }
}

//load the image
- (void)loadImageForVisibleRows
{
    if (self.movieItems.count > 0) {
        NSArray *indexPaths = [self.movieItemTable indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in indexPaths) {
            UITableViewCell *cell = [self.movieItemTable cellForRowAtIndexPath:indexPath];
            MovieItem *movieItem = [self.movieItems objectAtIndex:indexPath.row];
            if (movieItem.thumbnail && cell.imageView.image == self.placeholderImage) {
                [self.movieItemTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
}

- (void)downLoadFinish
{
    NSLog(@"%@",[[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] autorelease]);
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.responseData options:0 error:nil];
    NSString *commandId = [[[[document nodesForXPath:@"//root//head" error:nil] lastObject] attributeForName:@"cid"] stringValue];
    NSLog(@"%@",commandId);
    if ([commandId isEqualToString:@"08000003"]) {
        //if 6.0,结束下拉刷新
        if (NSClassFromString(@"UIRefreshControl"))
        {
            [self.movieRefreshControl performSelector:@selector(endRefreshing)];
        }
        else
        {
            //if 5.0
            self.refreshingLabel.text = @"下拉刷新列表";
            SEL theSelector = NSSelectorFromString(@"setContentInset:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UITableView instanceMethodSignatureForSelector:theSelector]];
            invocation.target = self.movieItemTable;
            invocation.selector = theSelector;
            UIEdgeInsets insets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            [invocation setArgument:&insets atIndex:2];
            [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:NO];
        }
        NSArray *movieNodes = [document nodesForXPath:@"//root//body//rows//wp_film" error:nil];
        if (movieNodes && [movieNodes count]>0) {
            NSMutableArray *unsortedMovies = [NSMutableArray array];
            for (GDataXMLElement *movieNode in movieNodes) {
                MovieItem *movieItem = [[MovieItem alloc] init];
                movieItem.movieId = [[movieNode attributeForName:@"id"] stringValue];
                movieItem.movieName = [[movieNode attributeForName:@"name"] stringValue];
                movieItem.duration = [[[movieNode attributeForName:@"duration"] stringValue] intValue];
                movieItem.director = [[movieNode attributeForName:@"director"] stringValue];
                movieItem.cast = [[movieNode attributeForName:@"cast"] stringValue];
                movieItem.thumbnailString = [[movieNode attributeForName:@"thumbnail"] stringValue];
                movieItem.poster = [[movieNode attributeForName:@"poster"] stringValue];
                movieItem.movieDate = [[movieNode attributeForName:@"filmdate"] stringValue];
                movieItem.movieClass = [[movieNode attributeForName:@"filmclass"] stringValue];
                movieItem.movieArea = [[movieNode attributeForName:@"filmarea"] stringValue];
                movieItem.movieDescription = [[movieNode attributeForName:@"description"] stringValue];
                movieItem.showCount = [[[movieNode attributeForName:@"showcount"] stringValue] intValue];
                
                movieItem.trailerURL = [[movieNode attributeForName:@"trailer"] stringValue];
                
                [unsortedMovies addObject:movieItem];
                [movieItem release];
            }
            if (unsortedMovies && [unsortedMovies count]>0)
            {
                NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"showCount" ascending:NO] autorelease];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                self.movieItems = [unsortedMovies sortedArrayUsingDescriptors:sortDescriptors];
            }
        }
        else {
            self.movieItems = [NSArray array];
        }
        if (![self.lastCity isEqualToString:self.currentCity]) {
            self.lastCity = self.currentCity;
            [self refreshTitleView];
        }
        [self.movieItemTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        if (isMovieRefreshing>0) {
            if (self.movieItemTable.contentOffset.y>0) {
                [self performSelectorOnMainThread:@selector(setMovieToTop) withObject:nil waitUntilDone:NO];
            }
            //            isMovieScrollToTop = NO;
            isMovieRefreshing--;
        }
    }
    [document release];
    //dismiss wait view
    [self.hud hide:YES];
    [self.activityIndicatorView stopAnimating];
    self.navigationItem.rightBarButtonItem = self.refreshButton;
}

- (void)setMovieToTop
{
    [self.movieItemTable setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.movieItems && [self.movieItems count]>0) {
        return 80.0;
    }
    else{
        return [[UIScreen mainScreen] applicationFrame].size.height-93.0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.movieItems && [self.movieItems count]>0) {
        return [self.movieItems count];
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.movieItems && [self.movieItems count]>0) {
        static NSString *cellIdentifier = @"movieCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
        }
        MovieItem *movieItem = [self.movieItems objectAtIndex:indexPath.row];
        if (movieItem.thumbnail) {
            cell.imageView.image = movieItem.thumbnail;
        }
        else {
            cell.imageView.image = self.placeholderImage;
            //Grand Central Dispatch
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:movieItem.thumbnailString]];
                movieItem.thumbnail = [UIImage imageWithData:imageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadImageForVisibleRows];
                });
            });
        }
        cell.textLabel.text = movieItem.movieName;
        cell.textLabel.font = [UIFont systemFontOfSize:18.0];
        cell.textLabel.textColor = [UIColor whiteColor];
        NSMutableString *detailText = [NSMutableString string];
        [detailText appendString:@"类别："];
        [detailText appendString:movieItem.movieClass];
        [detailText appendString:@"\n"];
        [detailText appendString:@"上映日期："];
        [detailText appendString:[movieItem.movieDate substringToIndex:9]];
        cell.detailTextLabel.text = detailText;
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.textColor = [UIColor orangeColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else{
        static NSString *cellIdentifier = @"movieCellNone";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        cell.textLabel.text = @"无影片信息";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:20.0];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.movieItems && self.movieItems.count>0) {
        CinemaViewController *cinemaVC = [[CinemaViewController alloc] initWithStyle:UITableViewStyleGrouped];
        cinemaVC.backButtonTitle = @"电影票";
        cinemaVC.movieItem = [self.movieItems objectAtIndex:indexPath.row];
        cinemaVC.currentCity = self.lastCity;
        [self.navigationController pushViewController:cinemaVC animated:YES];
        [cinemaVC release];
    }
}

@end

