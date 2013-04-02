//
//  CMovieViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-13.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "CMovieViewController.h"
#import "LoginViewController.h"
#import "GDataXMLNode.h"
#import "CinemaItem.h"
#import "InfoViewController.h"
#import "string.h"
#import "MovieItem.h"
#import "CinemaIntroduceViewController.h"
#import "UserItem.h"
#import "MBProgressHUD.h"


@interface CMovieViewController ()
@property (retain, nonatomic) UITableView *movieTableView;
@property (retain, nonatomic) QuitController *quitController;
@property (retain, nonatomic) DownLoadController *downloader;
@property (retain,nonatomic) NSMutableData *responseData;
@property (retain,nonatomic) NSArray *movieItems;
@property (retain, nonatomic) UIImage *placeholderImage;
@property (retain, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation CMovieViewController
@synthesize backButtonTitle = _backButtonTitle;
@synthesize currentCity = _currentCity;
@synthesize cinemaItem = _cinemaItem;
@synthesize movieTableView = _movieTableView;
@synthesize quitController = _quitController;
@synthesize downloader = _downloader;
@synthesize responseData = _responseData;
@synthesize movieItems = _movieItems;
@synthesize placeholderImage = _placeholderImage;
@synthesize activityIndicatorView = _activityIndicatorView;

- (void)dealloc
{
    [_backButtonTitle release];
    [_currentCity release];
    [_cinemaItem release];
    [_movieTableView release];
    [_quitController release];
    [_downloader release];
    [_responseData release];
    [_movieItems release];
    [_placeholderImage release];
    [_activityIndicatorView release];
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"影片列表";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UIButton *backButton = [UIButton buttonWithType:101];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:self.backButtonTitle forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 36.0)];
    headerView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:headerView];
    [headerView release];
    
    UILabel *cinemaNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 3.0, 250.0, 30.0)];
    cinemaNameLabel.text = self.cinemaItem.cinemaName;
    cinemaNameLabel.backgroundColor = [UIColor clearColor];
    cinemaNameLabel.textAlignment = NSTextAlignmentCenter;
    cinemaNameLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:cinemaNameLabel];
    [cinemaNameLabel release];
    
    UIButton *cinemaInfoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cinemaInfoButton.frame = CGRectMake(250.0, 8.0, 50.0, 20.0);
    cinemaInfoButton.layer.cornerRadius = 8;
    cinemaInfoButton.layer.masksToBounds = YES;
    [cinemaInfoButton setBackgroundImage:[UIImage imageNamed:@"orange.jpg"] forState:UIControlStateNormal];
    [cinemaInfoButton setTitle:@"详情" forState:UIControlStateNormal];
    [cinemaInfoButton addTarget:self action:@selector(displayCinemaInfo) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cinemaInfoButton];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 36.0, 320.0, [[UIScreen mainScreen] applicationFrame].size.height-44.0-49.0-36.0) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.movieTableView = tableView;
    [self.view addSubview:tableView];
    [tableView release];
    
    UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backview.jpg"]];
    self.movieTableView.backgroundView = backView;
    [backView release];
    
    self.placeholderImage = [UIImage imageNamed:@"loading_image.png"];
    
    [self refreshMovieView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.movieTableView deselectRowAtIndexPath:[self.movieTableView indexPathForSelectedRow] animated:NO];
}

- (void)goBack
{
    self.downloader.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)responseQuit
{
    self.navigationItem.rightBarButtonItem.title = @"登录";
    self.navigationItem.rightBarButtonItem.action = @selector(login);
}


- (void)refreshMovieView
{
    NSString *fullpath = [[NSBundle mainBundle] pathForResource:@"request-cinemamovie" ofType:@"xml"];
    NSString *requestString = [NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil];
    
    requestString = [requestString stringByReplacingOccurrencesOfString:@"$_CINEMAID" withString:self.cinemaItem.cinemaId];
    
    NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://tm.mbpay.cn:8082"]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = requestData;
    
    self.downloader.delegate = nil;
    DownLoadController *downloader = [[DownLoadController alloc] initWithRequest:request];
    downloader.delegate = self;
    self.downloader = downloader;
    [downloader beginAsyncRequest];
    [downloader release];
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicatorView = activityIndicatorView;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
    [activityIndicatorView release];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [rightBarButtonItem release];
    [activityIndicatorView startAnimating];
}

- (void)displayCinemaInfo
{
    CinemaIntroduceViewController *cinemaIntroduceVC = [[CinemaIntroduceViewController alloc] init];
    cinemaIntroduceVC.cinemaItem = self.cinemaItem;
    cinemaIntroduceVC.backButtonTitle = self.navigationItem.title;
    [self.navigationController pushViewController:cinemaIntroduceVC animated:YES];
    [cinemaIntroduceVC release];
}

- (void)loadImageForVisibleRows
{
    if (self.movieItems.count > 0) {
        NSArray *indexPaths = [self.movieTableView indexPathsForVisibleRows];
        
        for (NSIndexPath *indexPath in indexPaths) {
            MovieItem *movieItem = [self.movieItems objectAtIndex:indexPath.row];
            UITableViewCell *cell = [self.movieTableView cellForRowAtIndexPath:indexPath];
            
            if (movieItem && movieItem.thumbnail != self.placeholderImage && cell.imageView.image == self.placeholderImage){
                [self.movieTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
}

- (void)responseReceived:(NSMutableData *)responseData
{
    self.responseData = responseData;
    [self downLoadFinish];
}

- (void)refreshFail:(NSURLConnection *)connection
{
    [self.activityIndicatorView stopAnimating];
}

- (void)downLoadFinish
{
    NSLog(@"%@",[[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] autorelease]);
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.responseData options:0 error:nil];
    
    NSString *commandId = [[[[document nodesForXPath:@"//root//head" error:nil] lastObject] attributeForName:@"cid"] stringValue];
    NSLog(@"%@",commandId);
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
            
            NSLog(@"%@",movieItem.movieName);
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
    [self.movieTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [document release];
    
    //dismiss wait view
    [self.activityIndicatorView stopAnimating];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.movieItems && self.movieItems.count>0) {
        return [self.movieItems count];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.movieItems && self.movieItems.count>0){
        return 80.0;
    }
    return [UIScreen mainScreen].applicationFrame.size.height-129.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.movieItems!=nil && self.movieItems.count>0) {
        static NSString *CellIdentifier = @"MovieCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }
        MovieItem *movieItem = [self.movieItems objectAtIndex:indexPath.row];
        if (movieItem.thumbnail) {
            cell.imageView.image = movieItem.thumbnail;
        }
        else {
            //Grand Central Dispatch
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:movieItem.thumbnailString]];
                movieItem.thumbnail = [UIImage imageWithData:imageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadImageForVisibleRows];
                });
            });
            cell.imageView.image = self.placeholderImage;
        }
        cell.textLabel.text = [[self.movieItems objectAtIndex:indexPath.row] movieName];
        cell.textLabel.font = [UIFont systemFontOfSize:18.0];
        cell.textLabel.textColor = [UIColor whiteColor];
        
//        NSMutableString *detailText = [NSMutableString string];
//        [detailText appendString:@"今日上映场次："];
//        [detailText appendString:[NSString stringWithFormat:@"%d",[[self.movieItems objectAtIndex:indexPath.row] showCount]]];
//        [detailText appendString:@"\n"];
//        [detailText appendString:@"简介："];
//        [detailText appendString:[[[self.movieItems objectAtIndex:indexPath.row] movieDescription] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" 　"]]];
        NSMutableString *detailText = [NSMutableString string];
        [detailText appendString:@"类别："];
        [detailText appendString:movieItem.movieClass];
        [detailText appendString:@"\n"];
        [detailText appendString:@"上映日期："];
        [detailText appendString:[movieItem.movieDate substringToIndex:9]];
        cell.detailTextLabel.text = detailText;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.numberOfLines = 3;
        cell.detailTextLabel.textColor = [UIColor orangeColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"MovieCellNone";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = @"暂无影片信息";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:20.0];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.movieItems.count>0) {
        InfoViewController *infoViewController = [[InfoViewController alloc] init];
        infoViewController.backButtonTitle = self.navigationItem.title;
        infoViewController.currentCity = self.currentCity;
        infoViewController.cinemaItem = self.cinemaItem;
        infoViewController.movieItem = [self.movieItems objectAtIndex:indexPath.row];
        
        [self.navigationController pushViewController:infoViewController animated:YES];
        [infoViewController release];
    }
}

@end
