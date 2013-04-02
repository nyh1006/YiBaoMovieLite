//
//  MovieCinemaViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 13-2-17.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import "MovieCinemaViewController.h"
#import "MovieConstants.h"
#import "GDataXMLNode.h"
#import "MovieItem.h"
#import "CinemaItem.h"
#import "CMovieViewController.h"
#import "LoginViewController.h"
#import "DropDownTableViewCell.h"
#import "CityItem.h"
#import "MBProgressHUD.h"

@interface MovieCinemaViewController ()
@property (retain, nonatomic) NSMutableArray *cinemaItems;
@property (retain, nonatomic) UIBarButtonItem *refreshButton;
@property (retain, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (retain, nonatomic) UIBarButtonItem *activityIndicatorItem;
@property (retain, nonatomic) UITableView *cinemaItemTable;
@property (retain, nonatomic) UIButton *titleButton;
@property (retain, nonatomic) QuitController *quitController;
@property (retain, nonatomic) RequestCityController *cityRequester;
@property (retain, nonatomic) NSMutableArray *cityList;
@property (retain, nonatomic) NSMutableOrderedSet *districts;
@property (retain, nonatomic) NSMutableArray *packUpOpens;
@property (retain, nonatomic) NSMutableDictionary *allCinemas;
@property (retain, nonatomic) UIRefreshControl *cinemaRefreshControl;
@property (retain, nonatomic) UILabel *refreshingLabel;
@property (retain, nonatomic) UIImage *placeholderImage;
@property (retain, nonatomic) DownLoadController *downLoader;
@property (retain, nonatomic) MBProgressHUD *hud;
@property (retain, nonatomic) NSMutableData *responseData;
@end

@implementation MovieCinemaViewController
{
    //    BOOL isCinemaScrollToTop;
    NSUInteger isCinemaRefreshing;
}
@synthesize cinemaItems = _cinemaItems;
@synthesize refreshButton = _refreshButton;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize activityIndicatorItem = _activityIndicatorItem;
@synthesize cinemaItemTable = _cinemaItemTable;
@synthesize titleButton = _titleButton;
@synthesize quitController = _quitController;
@synthesize cityRequester = _cityRequester;
@synthesize cityList = _cityList;
@synthesize districts = _districts;
@synthesize packUpOpens = _packUpOpens;
@synthesize allCinemas = _allCinemas;
@synthesize cinemaRefreshControl = _cinemaRefreshControl;
@synthesize refreshingLabel = _refreshingLabel;
@synthesize placeholderImage = _placeholderImage;
@synthesize downLoader = _downLoader;
@synthesize hud = _hud;
@synthesize responseData = _responseData;

- (void)dealloc
{
    [_cinemaItems release];
    [_refreshButton release];
    [_activityIndicatorView release];
    [_activityIndicatorItem release];
    [_cinemaItemTable release];
    [_titleButton release];
    [_quitController release];
    [_cityRequester release];
    [_cityList release];
    [_districts release];
    [_packUpOpens release];
    [_allCinemas release];
    [_cinemaRefreshControl release];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"电影票" style:UIBarButtonItemStylePlain target:self action:nil];
//    self.navigationItem.backBarButtonItem = backButton;
//    [backButton release];
    
    UIButton *titleButton= [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0.0, 0.0, 220.0, 35.0);
    CityItem *sharedCity = [CityItem sharedCity];
//    if (sharedCity) {
//        self.lastCity = sharedCity.cityName;
//        self.currentCity = sharedCity.cityName;
//    }
//    else {
//        self.lastCity = @"北京";
//        self.currentCity = @"北京";
//    }
    if (self.currentCity) {
        self.lastCity = [NSString stringWithString:self.currentCity];
    }
    else {
        self.lastCity = @"北京";
        self.currentCity = @"北京";
    }
    NSString *title = @"电影票 - ";
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
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshCinemaView)];
    self.refreshButton = refreshButton;
    self.navigationItem.rightBarButtonItem = refreshButton;
    [refreshButton release];
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicatorView = activityIndicatorView;
    [activityIndicatorView release];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
    self.activityIndicatorItem = rightBarButtonItem;
    [rightBarButtonItem release];
    
    UITableView *cinemaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, [[UIScreen mainScreen] bounds].size.height-113.0) style:UITableViewStyleGrouped];
    cinemaTableView.backgroundView = nil;
    cinemaTableView.backgroundColor = [UIColor blackColor];
    cinemaTableView.delegate = self;
    cinemaTableView.dataSource = self;
    self.cinemaItemTable = cinemaTableView;
    [self.view addSubview:cinemaTableView];
    
    //if 6.0
    if (NSClassFromString(@"UIRefreshControl")) {
        UIRefreshControl *refreshControl1 = [[NSClassFromString(@"UIRefreshControl") alloc] init];
        [refreshControl1 addTarget:self action:@selector(refreshCinemaInfo) forControlEvents:UIControlEventValueChanged];
        self.cinemaRefreshControl = refreshControl1;
        [self.cinemaItemTable addSubview:refreshControl1];
        [refreshControl1 release];
    }//if 5.0
    else{
        UILabel *refreshLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, -50.0, 320.0, 50.0)];
        refreshLabel1.text = @"下拉刷新列表";
        refreshLabel1.backgroundColor = [UIColor clearColor];
        refreshLabel1.textAlignment = NSTextAlignmentCenter;
        refreshLabel1.textColor = [UIColor blackColor];
        refreshLabel1.font = [UIFont systemFontOfSize:20.0];
        [self.cinemaItemTable addSubview:refreshLabel1];
        self.refreshingLabel = refreshLabel1;
        [refreshLabel1 release];
    }
    
    //place this image hold the imageView before the image
    self.placeholderImage = [UIImage imageNamed:@"loading_image.png"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *cityList = [defaults objectForKey:@"citys"];
    if (!cityList) {
//        self.cityRequester.delegate = nil;
        RequestCityController *cityRequester = [[RequestCityController alloc] init];
//        cityRequester.delegate = self;
        self.cityRequester = cityRequester;
        [cityRequester requestCitys];
        [cityRequester release];
    }
    
    isCinemaRefreshing = 0;
    [self refreshCinemaView];
    
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
    
    [self.cinemaItemTable deselectRowAtIndexPath:[self.cinemaItemTable indexPathForSelectedRow] animated:NO];
    
    if (![self.currentCity isEqualToString:self.lastCity])
    {
        if (isCinemaRefreshing>0) {
            self.downLoader.delegate = nil;
            isCinemaRefreshing--;
        }
        [self refreshCinemaInfo];
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
    isCinemaRefreshing--;
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
        citySelectVC.selectedCity = self.currentCity;
        
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:citySelectVC];
        [citySelectVC release];
        
        [self presentViewController:navigation animated:YES completion:^{}];
        [navigation release];
    }
}

//refresh cinema list
- (void)refreshCinemaView
{
    if (isCinemaRefreshing == 0) {
        [self refreshCinemaInfo];
    }
}

- (void)refreshCinemaInfo
{
    isCinemaRefreshing++;
    NSString *requestString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"request-cinema" ofType:@"xml"] encoding:NSUTF8StringEncoding error:NULL];
    requestString = [[requestString stringByReplacingOccurrencesOfString:@"$_CITYNAME" withString:self.currentCity] stringByReplacingOccurrencesOfString:@"$_MOVIEID" withString:@""];
    
    NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kMovieAPILocation]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = requestData;
    
    DownLoadController *downLoadController = [[DownLoadController alloc] initWithRequest:request];
    downLoadController.delegate = self;
    self.downLoader = downLoadController;
    [downLoadController beginAsyncRequest];
    [downLoadController release];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"刷新中...";
    self.hud = hud;
    
    self.navigationItem.rightBarButtonItem = self.activityIndicatorItem;
    [self.activityIndicatorView startAnimating];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (cinemaScrollToTop>0 && scrollView.isDecelerating) {
//        scrollView.contentInset = UIEdgeInsetsMake(70.0, 0.0, 0.0, 0.0);
//    }
    if (!NSClassFromString(@"UIRefreshControl")) {
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
            
            [self refreshCinemaView];
        }
    }
}

- (void)downLoadFinish
{
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.responseData options:0 error:nil];
    NSString *commandId = [[[[document nodesForXPath:@"//root//head" error:nil] lastObject] attributeForName:@"cid"] stringValue];
    NSLog(@"%@",commandId);
    if ([commandId isEqualToString:@"08000001"])
    {
        //if 6.0,结束下拉刷新
        if (NSClassFromString(@"UIRefreshControl"))
        {
            [self.cinemaRefreshControl performSelector:@selector(endRefreshing)];
        }
        else{
            //if 5.0
            self.refreshingLabel.text = @"下拉刷新列表";
            SEL theSelector = NSSelectorFromString(@"setContentInset:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UITableView instanceMethodSignatureForSelector:theSelector]];
            invocation.target = self.cinemaItemTable;
            invocation.selector = theSelector;
            UIEdgeInsets insets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            [invocation setArgument:&insets atIndex:2];
            [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:NO];
        }
        NSArray *cinemaNodes = [document nodesForXPath:@"//root//body//rows//wp_cinema" error:nil];
        if (cinemaNodes && [cinemaNodes count]>0)
        {
            self.cinemaItems = [NSMutableArray array];
            for (GDataXMLElement *cinemaNode in cinemaNodes)
            {
                CinemaItem *cinemaItem = [[CinemaItem alloc] init];
                cinemaItem.cinemaId = [[cinemaNode attributeForName:@"id"] stringValue];
                cinemaItem.cinemaName = [[cinemaNode attributeForName:@"name"] stringValue];
                cinemaItem.cinemaLocation = [[cinemaNode attributeForName:@"location"] stringValue];
                cinemaItem.cinemaHallcount = [[[cinemaNode attributeForName:@"hallcount"] stringValue] intValue];
                cinemaItem.cinemaAddress = [[cinemaNode attributeForName:@"address"] stringValue];
                cinemaItem.cinemaBusline = [[cinemaNode attributeForName:@"busline"] stringValue];
                cinemaItem.cinemaDescription = [[cinemaNode attributeForName:@"desc"] stringValue];
                cinemaItem.cinemaPhoto = [[cinemaNode attributeForName:@"photo"] stringValue];
                cinemaItem.cinemaCityId = [[[cinemaNode attributeForName:@"cityid"] stringValue] intValue];
                cinemaItem.cinemaDistrictId = [[[cinemaNode attributeForName:@"districtid"] stringValue] intValue];
                cinemaItem.cinemaDistrictName = [[cinemaNode attributeForName:@"districtname"] stringValue];
                cinemaItem.cinemaFilmShowCount = [[[cinemaNode attributeForName:@"showcount"] stringValue] intValue];
                cinemaItem.cinemaMapLocation = [[cinemaNode attributeForName:@"map"] stringValue];
                [self.cinemaItems addObject:cinemaItem];
                [cinemaItem release];
            }
            if (self.cinemaItems && [self.cinemaItems count]>0) {
                self.districts = [NSMutableOrderedSet orderedSet];
                NSSortDescriptor *descriptor = [[[NSSortDescriptor alloc] initWithKey:@"cinemaDistrictId" ascending:YES] autorelease];
                NSArray *descriptors = [NSArray arrayWithObject:descriptor];
                NSArray *sortedCinemas= [self.cinemaItems sortedArrayUsingDescriptors:descriptors];
                for (int i=0; i<sortedCinemas.count; i++) {
                    [self.districts addObject:[[sortedCinemas objectAtIndex:i] cinemaDistrictName]];
                }
                
                self.packUpOpens = [NSMutableArray array];
                for (int i=0; i<self.districts.count; i++) {
                    NSNumber *number = [NSNumber numberWithBool:YES];
                    [self.packUpOpens addObject:number];
                }
                
                self.allCinemas = [NSMutableDictionary dictionary];
                for (int i=0; i<self.districts.count; i++) {
                    NSString *districtName = [self.districts objectAtIndex:i];
                    NSMutableArray *cinemas = [NSMutableArray array];
                    for (int j=0; j<self.cinemaItems.count; j++) {
                        CinemaItem *cinemaItem = [self.cinemaItems objectAtIndex:j];
                        if ([districtName isEqualToString:[cinemaItem cinemaDistrictName]]) {
                            [cinemas addObject:cinemaItem];
                        }
                    }
                    if (cinemas && cinemas.count>0) {
                        [self.allCinemas setObject:cinemas forKey:districtName];
                    }
                }
            }
        }
        else {
            self.cinemaItems = [NSArray array];
        }
        if (![self.lastCity isEqualToString:self.currentCity]) {
            self.lastCity = self.currentCity;
            [self refreshTitleView];
        }
        [self.cinemaItemTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        if (isCinemaRefreshing>0) {
            if (self.cinemaItemTable.contentOffset.y>0) {
                [self performSelectorOnMainThread:@selector(setCinemaToTop) withObject:nil waitUntilDone:NO];
            }
            //            isCinemaScrollToTop = NO;
            isCinemaRefreshing--;
        }
    }
    [document release];
    
    //dismiss wait view
    [self.hud hide:YES];
    self.navigationItem.rightBarButtonItem = self.refreshButton;
}

- (void)setCinemaToTop
{
    [self.cinemaItemTable setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.cinemaItems && self.cinemaItems.count>0) {
        return self.districts.count;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.cinemaItems && [self.cinemaItems count]>0) {
        if ([[self.packUpOpens objectAtIndex:section] boolValue]) {
            return 1;
        }
        else {
            NSString *district = [self.districts objectAtIndex:section];
            NSArray *cinemasAtDistrict = [self.allCinemas objectForKey:district];
            return cinemasAtDistrict.count+1;
        }
    }
    else {
        return 1;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cinemaItems && [self.cinemaItems count]>0) {
        if (indexPath.row == 0) {
            return 36.0;
        }
        else {
            return 80.0;
        }
    }
    else{
        return [[UIScreen mainScreen] applicationFrame].size.height-113.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cinemaItems && [self.cinemaItems count]>0) {
        switch (indexPath.row) {
            case 0:
            {
                static NSString *cellIdentifier = @"DropDownCell";
                DropDownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[[DropDownTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
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
                static NSString *cellIdentifier = @"CinemaCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
                }
                cell.backgroundColor = [UIColor darkGrayColor];
                cell.textLabel.text = [[[self.allCinemas objectForKey:[self.districts objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row-1] cinemaName];
                cell.textLabel.font = [UIFont systemFontOfSize:18.0];
                cell.textLabel.numberOfLines = 2;
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.detailTextLabel.text = [[[[self.allCinemas objectForKey:[self.districts objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row-1] cinemaAddress] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@" 　"]]];
                cell.detailTextLabel.numberOfLines = 2;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
                cell.detailTextLabel.textColor = [UIColor orangeColor];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                return cell;
                break;
            }
        }
    }
    else{
        static NSString *cellIdentifier = @"cinemaCellNone";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.textLabel.text = @"无影院信息";
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
            NSArray *cinemasAtDistrict = [self.allCinemas objectForKey:district];
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (int i=1; i<=cinemasAtDistrict.count; i++) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row+i inSection:indexPath.section];
                [indexPaths addObject:path];
            }
            DropDownTableViewCell *cell = (DropDownTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            NSNumber *number = [self.packUpOpens objectAtIndex:indexPath.section];
            if (![number boolValue]) {
                [cell setClose];
                [self.packUpOpens replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:YES]];
                [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            }
            else {
                [cell setOpen];
                [self.packUpOpens replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
                [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            }
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        else {
            CMovieViewController *cinemaMovieVC = [[CMovieViewController alloc] init];
            cinemaMovieVC.backButtonTitle = @"电影票";
            cinemaMovieVC.currentCity = self.lastCity;
            cinemaMovieVC.cinemaItem = [[self.allCinemas objectForKey:[self.districts objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row-1];
            [self.navigationController pushViewController:cinemaMovieVC animated:YES];
            [cinemaMovieVC release];
        }
    }

}

@end
