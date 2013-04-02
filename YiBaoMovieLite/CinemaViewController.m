//
//  CinemaViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-13.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "CinemaViewController.h"
#import "LoginViewController.h"
#import "GDataXMLNode.h"
#import "CinemaItem.h"
#import "InfoViewController.h"
#import "string.h"
#import "MovieIntroduceViewController.h"
#import "UserItem.h"
#import "DropDownTableViewCell.h"
#import "MBProgressHUD.h"

@interface CinemaViewController ()
@property (retain, nonatomic) QuitController *quitController;
@property (retain, nonatomic) UIImageView *imageView;
@property (retain, nonatomic) DownLoadController *downloader;
@property (retain,nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSMutableArray *sortedDistricts;
@property (retain,nonatomic) NSMutableArray *cinemaItems;
@property (retain,nonatomic) NSMutableDictionary *allCinemas;
@property (retain,nonatomic) NSMutableOrderedSet *districts;
@property (retain, nonatomic) NSMutableArray *packUpOpens;
@property (retain, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation CinemaViewController
@synthesize backButtonTitle = _backButtonTitle;
@synthesize movieItem = _movieItem;
@synthesize currentCity = _currentCity;
@synthesize quitController = _quitController;
@synthesize imageView = _imageView;
@synthesize downloader = _downloader;
@synthesize responseData = _responseData;
@synthesize sortedDistricts = _sortedDistricts;
@synthesize cinemaItems = _cinemaItems;
@synthesize districts = _districts;
@synthesize allCinemas = _allCinemas;
@synthesize packUpOpens = _packUpOpens;
@synthesize activityIndicatorView = _activityIndicatorView;

- (void)dealloc
{
    [_backButtonTitle release];
    [_movieItem release];
    [_currentCity release];
    [_quitController release];
    [_imageView release];
    [_downloader release];
    [_responseData release];
    [_sortedDistricts release];
    [_cinemaItems release];
    [_districts release];
    [_allCinemas release];
    [_packUpOpens release];
    [_activityIndicatorView release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"影院列表";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UIButton* backButton = [UIButton buttonWithType:101]; // left-pointing shape!
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:self.backButtonTitle forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor blackColor];
    
    //this is tableHeaderView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 180.0)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    [headerView release];
    
    UIImageView *movieImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 120.0, 160.0)];
    movieImageView.image = [UIImage imageNamed:@"loading_image.png"];
    self.imageView = movieImageView;
    [headerView addSubview:movieImageView];
    [movieImageView release];
    
    // load image using GCD
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获取图片
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.movieItem.poster]];
        UIImage *image= [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // reload image
            if (image) {
                self.imageView.image = image;
            }
        });
    });
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 20.0, 160.0, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.movieItem.movieName;
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *directorLabel = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 50.0, 160.0, 20.0)];
    directorLabel.backgroundColor = [UIColor clearColor];
    NSString *director = [NSString stringWithFormat:@"导演：%@",self.movieItem.director];
    directorLabel.text = director;
    directorLabel.font = [UIFont systemFontOfSize:15.0];
    directorLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:directorLabel];
    [directorLabel release];
    
    UILabel *castLabel = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 80.0, 160.0, 45.0)];
    castLabel.backgroundColor = [UIColor clearColor];
    NSString *cast = [NSString stringWithFormat:@"演员：%@",self.movieItem.cast];
    castLabel.text = cast;
    castLabel.font = [UIFont systemFontOfSize:15.0];
    castLabel.textColor = [UIColor whiteColor];
    castLabel.numberOfLines = 0;
    [headerView addSubview:castLabel];
    [castLabel release];
    
    UIButton *cinemaInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cinemaInfoButton.layer.cornerRadius = 8.0;
    cinemaInfoButton.layer.masksToBounds = YES;
    [cinemaInfoButton setBackgroundImage:[UIImage imageNamed:@"orange.jpg"] forState:UIControlStateNormal];
    cinemaInfoButton.frame = CGRectMake(200.0, 135.0, 60.0, 20.0);
    [cinemaInfoButton setTitle:@"详情" forState:UIControlStateNormal];
    [cinemaInfoButton addTarget:self action:@selector(displayMovieInfo) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cinemaInfoButton];

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

- (void)displayMovieInfo
{
    MovieIntroduceViewController *movieIntroduce = [[MovieIntroduceViewController alloc] init];
    movieIntroduce.movieItem = self.movieItem;
    movieIntroduce.backButtonTitle = self.navigationItem.title;
    [self.navigationController pushViewController:movieIntroduce animated:YES];
    [movieIntroduce release];
}

- (void)refreshMovieView
{
    NSString *fullpath = [[NSBundle mainBundle] pathForResource:@"request-cinema" ofType:@"xml"];
    NSString *requestString = [NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil];
    requestString = [[requestString stringByReplacingOccurrencesOfString:@"$_MOVIEID" withString:self.movieItem.movieId] stringByReplacingOccurrencesOfString:@"$_CITYNAME" withString:self.currentCity];
    
    NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://tm.mbpay.cn:8082"]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = requestData;
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.cinemaItems && self.cinemaItems.count>0) {
        return [self.districts count];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.cinemaItems && self.cinemaItems.count>0) {
        if ([[self.packUpOpens objectAtIndex:section] boolValue]) {
            return 1;
        }
        else {
            NSString *district = [self.districts objectAtIndex:section];
            NSArray *cinemaAtDistrict = [self.allCinemas objectForKey:district];
            return [cinemaAtDistrict count]+1;
        }
    }
    return 1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (self.cinemaItems && self.cinemaItems.count>0) {
//        return [self.districts objectAtIndex:section];
//    }
//    return [super tableView:tableView titleForHeaderInSection:section];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cinemaItems && self.cinemaItems.count>0) {
        if (indexPath.row == 0) {
            return 36.0;
        }
        else {
            return 80.0;
        }
    } 
    return [UIScreen mainScreen].applicationFrame.size.height-49.0-44.0-180.0-20.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cinemaItems && self.cinemaItems.count>0) {
        switch (indexPath.row) {
            case 0:
            {
                static NSString *CellIdentifier = @"DropDownCell";
                DropDownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[[DropDownTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                }
                NSNumber *number = [self.packUpOpens objectAtIndex:indexPath.section];
                if ([number boolValue]) {
                    [cell setClose];
                }
                else {
                    [cell setOpen];
                }
                cell.backgroundColor = [UIColor darkGrayColor];
                cell.textLabel.text = [self.districts objectAtIndex:indexPath.section];
                cell.textLabel.font = [UIFont systemFontOfSize:18.0];
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                
                return cell;
                break;
            }
            default:
            {
                static NSString *CellIdentifier = @"CinemaCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
                }
                cell.backgroundColor = [UIColor darkGrayColor];
                cell.textLabel.text = [[[self.allCinemas objectForKey:[self.districts objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row-1] cinemaName];
                cell.textLabel.font = [UIFont systemFontOfSize:18.0];
                cell.textLabel.numberOfLines = 2;
                cell.textLabel.textColor = [UIColor whiteColor];
    
                cell.detailTextLabel.text = [[[self.allCinemas objectForKey:[self.districts objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row-1] cinemaAddress];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
                cell.detailTextLabel.numberOfLines = 2;
                cell.detailTextLabel.textColor = [UIColor orangeColor];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                return cell;
                break;
            }
        }
    }
    else {
        static NSString *CellIdentifier = @"CinemaCellNone";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.textLabel.text = @"暂无影院信息";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:20.0];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cinemaItems && self.cinemaItems.count>0) {
        if (indexPath.row == 0) {
            NSString *district = [self.districts objectAtIndex:indexPath.section];
            NSArray *cinemaAtDistrict = [self.allCinemas objectForKey:district];
            NSMutableArray *indexPathArray = [NSMutableArray array];
            for (int i=1; i<=cinemaAtDistrict.count; i++) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row+i inSection:indexPath.section];
                [indexPathArray addObject:path];
            }
            DropDownTableViewCell *cell = (DropDownTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            NSNumber *number = [self.packUpOpens objectAtIndex:indexPath.section];
            if (![number boolValue]) {
                [cell setClose];
                [self.packUpOpens replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:YES]];
                [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
            }
            else {
                [cell setOpen];
                [self.packUpOpens replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
                [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
            }
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        else {
            InfoViewController *infoViewController = [[InfoViewController alloc] init];
            infoViewController.backButtonTitle = self.navigationItem.title;
            infoViewController.currentCity = self.currentCity;
            infoViewController.cinemaItem = [[self.allCinemas objectForKey:[self.districts objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row-1];
            infoViewController.movieItem = self.movieItem;
            
            [self.navigationController pushViewController:infoViewController animated:YES];
            [infoViewController release];
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
    NSArray *cinemaNodes = [document nodesForXPath:@"//root//body//rows//wp_cinema" error:nil];
    if (cinemaNodes && [cinemaNodes count]>0) {
        self.cinemaItems = [NSMutableArray array];
        
        for (GDataXMLElement *cinemaNode in cinemaNodes) {
            CinemaItem  *cinema = [[CinemaItem alloc] init];
            cinema.cinemaId = [[cinemaNode attributeForName:@"id"] stringValue];
            cinema.cinemaName = [[cinemaNode attributeForName:@"name"] stringValue];
            cinema.cinemaLocation = [[cinemaNode attributeForName:@"location"] stringValue];
            cinema.cinemaHallcount = [[[cinemaNode attributeForName:@"hallcount"] stringValue] intValue];
            cinema.cinemaAddress = [[cinemaNode attributeForName:@"address"] stringValue];
            cinema.cinemaBusline = [[cinemaNode attributeForName:@"busline"] stringValue];
            cinema.cinemaDescription = [[cinemaNode attributeForName:@"desc"] stringValue];
            cinema.cinemaPhoto = [[cinemaNode attributeForName:@"photo"] stringValue];
            cinema.cinemaCityId = [[[cinemaNode attributeForName:@"cityid"] stringValue] intValue];
            cinema.cinemaDistrictId = [[[cinemaNode attributeForName:@"districtid"] stringValue] intValue];
            cinema.cinemaDistrictName = [[cinemaNode attributeForName:@"districtname"] stringValue];
            cinema.cinemaFilmShowCount = [[[cinemaNode attributeForName:@"filmshowcount"] stringValue] intValue];
            cinema.cinemaMapLocation = [[cinemaNode attributeForName:@"map"] stringValue];
            
            [self.cinemaItems addObject:cinema];
            [cinema release];
        }
        
        //获得按照districtId渐增的district数组
        if (self.cinemaItems && [self.cinemaItems count]>0) {
            NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"cinemaDistrictId" ascending:YES] autorelease];
            NSArray *sortdescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *sortedCinemaItems = [self.cinemaItems sortedArrayUsingDescriptors:sortdescriptors];
            self.districts = [NSMutableOrderedSet orderedSet];
            for (int i=0; i<[sortedCinemaItems count]; i++) {
                [self.districts addObject:[[sortedCinemaItems objectAtIndex:i] cinemaDistrictName]];
            }
            
            self.packUpOpens = [NSMutableArray array];
            for (int i=0; i<self.districts.count; i++) {
                NSNumber *number = [NSNumber numberWithBool:YES];
                [self.packUpOpens addObject:number];
            }
            
            self.allCinemas = [NSMutableDictionary dictionary];
            //已经获取到所有城区，按照城区，将所有影院存放到字典中
            for (int i=0; i<[self.districts count]; i++) {
                NSMutableArray *cinemas = [NSMutableArray array];
                for (int j=0; j<[self.cinemaItems count]; j++) {
                    CinemaItem *nowCinema = [self.cinemaItems objectAtIndex:j];
                    if ([nowCinema.cinemaDistrictName isEqualToString:[self.districts objectAtIndex:i]]) {
                        [cinemas addObject:nowCinema];
                    }
                }
                if (cinemas && [cinemas count]>0) {
                    [self.allCinemas setObject:cinemas forKey:[self.districts objectAtIndex:i]];
                }
            }
        }

    }
    else{
        self.cinemaItems = [NSMutableArray array];
    }
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [document release];
    
    //dismiss wait view
    [self.activityIndicatorView stopAnimating];
}


@end
