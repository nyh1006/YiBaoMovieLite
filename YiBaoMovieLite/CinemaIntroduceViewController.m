//
//  CinemaIntroduceViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-13.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "CinemaIntroduceViewController.h"
#import "CinemaHallViewController.h"
#import "MapViewController.h"
#import "GDataXMLNode.h"
#import "MovieConstants.h"
#import "HallItem.h"
#import "UserItem.h"
#import "MBProgressHUD.h"

@interface CinemaIntroduceViewController ()
@property (retain, nonatomic) UIView *headerView;
@property (retain, nonatomic) NSMutableArray *pictures;
@property (retain, nonatomic) NSMutableArray *pictureViews;
@property (retain, nonatomic) UIScrollView *displayView;
@property (retain, nonatomic) UIPageControl *pageControl;
@property (retain, nonatomic) UITableView *hallTable;
@property (retain,nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSMutableArray *hallItems;
@property (retain, nonatomic) DownLoadController *downLoader;
@property (retain, nonatomic) MBProgressHUD *hud;
@property (retain, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation CinemaIntroduceViewController
{
    CGFloat headerSize;
}
@synthesize backButtonTitle = _backButtonTitle;
@synthesize headerView = _headerView;
@synthesize cinemaItem = _cinemaItem;
@synthesize pictures = _pictures;
@synthesize pictureViews = _pictureViews;
@synthesize displayView = _displayView;
@synthesize hallTable = _hallTable;
@synthesize responseData = _responseData;
@synthesize hallItems = _hallItems;
@synthesize downLoader = _downLoader;
@synthesize hud = _hud;
@synthesize activityIndicatorView = _activityIndicatorView;

- (void)dealloc
{
    [_cinemaItem release];
    [_backButtonTitle release];
    [_headerView release];
    [_pictures release];
    [_pictureViews release];
    [_displayView release];
    [_hallTable release];
    [_responseData release];
    [_hallItems release];
    [_downLoader release];
    [_hud release];
    [_activityIndicatorView release];
    
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
    self.navigationItem.title = @"影院详情";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UIButton *backButton = [UIButton buttonWithType:101];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:self.backButtonTitle forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];
    
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"位置" style:UIBarButtonItemStyleBordered target:self action:@selector(showLocation)];
    self.navigationItem.rightBarButtonItem = mapButton;
    [mapButton release];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, [UIScreen mainScreen].applicationFrame.size.height-44.0-49.0)];
    self.headerView = headerView;
    [headerView release];
    
    UIScrollView *displayView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 150.0)];
    displayView.showsHorizontalScrollIndicator = NO;
    displayView.delegate = self;
    self.displayView = displayView;
    [self.headerView addSubview:displayView];
    [displayView release];
    
    NSArray *pictures = [self.cinemaItem.cinemaPhoto componentsSeparatedByString:@"$$$"];
    
    if (pictures.count>=2) {
        self.pictures = [NSMutableArray array];
        [self.pictures addObject:[pictures objectAtIndex:0]];
        for (int i=1; i<pictures.count; i++) {
            NSString *picture = [@"http://www.wangpiao.com/wangp/UploadFiles/" stringByAppendingString:[pictures objectAtIndex:i]];
            [self.pictures addObject:picture];
        }
        NSLog(@"%d",self.pictures.count);
        
        self.pictureViews = [NSMutableArray array];
        for (int i=0; i<self.pictures.count+2; i++) {
            UIImageView *pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(320.0*i, 0.0, 320.0, 150.0)];
            pictureView.backgroundColor = [UIColor grayColor];
            pictureView.image = [UIImage imageNamed:@"loading_image@2x.png"];
            [displayView addSubview:pictureView];
            [self.pictureViews addObject:pictureView];
            [pictureView release];
        }
        
        for (int i=0; i<self.pictures.count; i++) {
            // load image using GCD
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 获取图片
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.pictures objectAtIndex:i]]];
                UIImage *image= [UIImage imageWithData:imageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // reload image
                    if (i == 0) {
                        UIImageView *pictureView1 = [self.pictureViews objectAtIndex:1];
                        pictureView1.image = image;
                        UIImageView *pictureView2 = [self.pictureViews objectAtIndex:self.pictures.count+1];
                        pictureView2.image = image;
                    }
                    else if (i == self.pictures.count-1) {
                        UIImageView *pictureView1 = [self.pictureViews objectAtIndex:0];
                        pictureView1.image = image;
                        UIImageView *pictureView2 = [self.pictureViews objectAtIndex:self.pictures.count];
                        pictureView2.image = image;
                    }
                    else {
                        UIImageView *pictureView = [self.pictureViews objectAtIndex:i+1];
                        pictureView.image = image;
                    }
                });
            });
        }
        
        displayView.contentSize = CGSizeMake(320.0*(self.pictures.count+2), 150.0);
        [displayView scrollRectToVisible:CGRectMake(320.0, 0.0, 320.0, 150.0) animated:NO];
        displayView.pagingEnabled = YES;
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0, 130.0, 320.0, 20.0)];
        pageControl.numberOfPages = self.pictures.count;
        pageControl.currentPage = 0;
        self.pageControl = pageControl;
        [self.headerView addSubview:pageControl];
        [pageControl release];
    }
    else {
        UIImageView *pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 150.0)];
        pictureView.backgroundColor = [UIColor grayColor];
        pictureView.image = [UIImage imageNamed:@"loading_image@2x.png"];
        [displayView addSubview:pictureView];
        [pictureView release];
        
        // load image using GCD
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 获取图片
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.cinemaItem.cinemaPhoto]];
            UIImage *image= [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                // reload image
                pictureView.image = image;
            });
        });
    }
    
    UILabel *titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 160.0, 80.0, 20.0)];
    titleNameLabel.backgroundColor = [UIColor clearColor];
    titleNameLabel.text = @"影院名称：";
    titleNameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    titleNameLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:titleNameLabel];
    [titleNameLabel release];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 160.0, 220.0, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.cinemaItem.cinemaName;
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *hallcountNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 190.0, 80.0, 15.0)];
    hallcountNameLabel.backgroundColor = [UIColor clearColor];
    hallcountNameLabel.text = @"影厅个数：";
    hallcountNameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    hallcountNameLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:hallcountNameLabel];
    [hallcountNameLabel release];

    UILabel *hallcountLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 190.0, 50.0, 15.0)];
    hallcountLabel.backgroundColor = [UIColor clearColor];
    hallcountLabel.text = [NSString stringWithFormat:@"%d",self.cinemaItem.cinemaHallcount];
    hallcountLabel.font = [UIFont systemFontOfSize:15.0];
    hallcountLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:hallcountLabel];
    [hallcountLabel release];

    UILabel *addressNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 215.0, 60.0, 20.0)];
    addressNameLabel.backgroundColor = [UIColor clearColor];
    NSString *address = @"地址：";
    addressNameLabel.text = address;
    addressNameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    addressNameLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:addressNameLabel];
    [addressNameLabel release];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 240.0, 300.0, 0.0)];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.text = self.cinemaItem.cinemaAddress;
    addressLabel.numberOfLines = 0;
    addressLabel.font = [UIFont systemFontOfSize:15.0];
    addressLabel.textColor = [UIColor whiteColor];
    CGSize addressMaxSize = CGSizeMake(300.0, 40.0);
    CGSize addressLabelSize = [addressLabel.text sizeWithFont:addressLabel.font constrainedToSize:addressMaxSize];
    [addressLabel setFrame:CGRectMake(10.0, 240.0, 300.0, addressLabelSize.height)];
    [self.headerView addSubview:addressLabel];
    [addressLabel release];
    
    UILabel *buslineNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 290.0, 80.0, 20.0)];
    buslineNameLabel.backgroundColor = [UIColor clearColor];
    buslineNameLabel.text = @"乘车路线：";
    buslineNameLabel.numberOfLines = 0;
    buslineNameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    buslineNameLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:buslineNameLabel];
    [buslineNameLabel release];
    
    UILabel *buslineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 315.0, 300.0, 0.0)];
    buslineLabel.backgroundColor = [UIColor clearColor];
    NSString *busline = self.cinemaItem.cinemaBusline;
    buslineLabel.text = busline;
    buslineLabel.font = [UIFont systemFontOfSize:15.0];
    buslineLabel.textColor = [UIColor whiteColor];
    buslineLabel.numberOfLines = 0;
    CGSize buslineSize = CGSizeMake(300.0, 10000.0);
    CGSize buslineLabelSize = [buslineLabel.text sizeWithFont:buslineLabel.font constrainedToSize:buslineSize];
    [buslineLabel setFrame:CGRectMake(10.0, 315.0, 300.0, buslineLabelSize.height)];
    [self.headerView addSubview:buslineLabel];
    [buslineLabel release];
    
    
    UILabel *seperator = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 325.0+buslineLabelSize.height, 320.0, 20.0)];
    seperator.backgroundColor = [UIColor lightGrayColor];
    seperator.text = @"  简介";
    seperator.font = [UIFont boldSystemFontOfSize:15.0];
    seperator.textColor = [UIColor whiteColor];
    [self.headerView addSubview:seperator];
    [seperator release];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 350.0+buslineLabelSize.height, 300.0, 0.0)];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    NSString *description = [self.cinemaItem.cinemaDescription stringByReplacingOccurrencesOfString:@"<br/><br/>" withString:@"\n"];
    if ([description isEqualToString:@""]||!description) {
        description = @"暂无";
    }
    NSString *movieDescription = description;
    descriptionLabel.text = movieDescription;
    descriptionLabel.font = [UIFont systemFontOfSize:15.0];
    descriptionLabel.textColor = [UIColor whiteColor];
    descriptionLabel.numberOfLines = 0;
    CGSize size = CGSizeMake(300.0, 10000.0);
    CGSize labelSize = [descriptionLabel.text sizeWithFont:descriptionLabel.font constrainedToSize:size];
    [descriptionLabel setFrame:CGRectMake(10.0, 350.0+buslineLabelSize.height, 300.0, labelSize.height)];
    [self.headerView addSubview:descriptionLabel];
    [descriptionLabel release];
    
    [self.headerView setFrame:CGRectMake(0.0, 0.0, 320.0, 380.0+buslineLabelSize.height+labelSize.height)];
    self.tableView.tableHeaderView = self.headerView;
    
    headerSize = 380.0+buslineLabelSize.height+labelSize.height;
//    UITableView *hallTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 355.0+buslineLabelSize.height+labelSize.height, 320.0, [[UIScreen mainScreen] applicationFrame].size.height-93.0) style:UITableViewStyleGrouped];
//    hallTable.delegate = self;
//    hallTable.dataSource = self;
//    self.hallTable = hallTable;
//    [scrollView addSubview:hallTable];
//    [hallTable release];
    
    [self requestHallInfo];
    
//    scrollView.contentSize = CGSizeMake(320.0, 355.0+buslineLabelSize.height+labelSize.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack
{
    self.downLoader.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.displayView) {
        int page = (scrollView.contentOffset.x+160.0)/320.0;
        self.pageControl.currentPage = (page+self.pictures.count-1)%self.pictures.count;
        
        if (scrollView.contentOffset.x<10.0) {
            CGFloat minorOffset = scrollView.contentOffset.x-0.0;
            if (scrollView.decelerating) {
                minorOffset = 0;
            }
            NSLog(@"%d",self.pictures.count);
            [self.displayView scrollRectToVisible:CGRectMake(320.0*(self.pictures.count+minorOffset), 0.0, 320.0, 150.0) animated:NO];
        }
        else if (scrollView.contentOffset.x>320.0*(self.pictures.count+1)-10.0){
            CGFloat minorOffset = scrollView.contentOffset.x-320.0*(self.pictures.count+1);
            if (scrollView.decelerating) {
                minorOffset = 0;
            }
            [self.displayView scrollRectToVisible:CGRectMake(320.0+minorOffset, 0.0, 320.0, 150.0) animated:NO];
        }
    }
}

- (void)cinemaHallInfo
{
    CinemaHallViewController *cinemaHallVC = [[CinemaHallViewController alloc] initWithStyle:UITableViewStyleGrouped];
    cinemaHallVC.backButtonTitle = self.navigationItem.title;
    cinemaHallVC.cinemaId = self.cinemaItem.cinemaId;
    [self.navigationController pushViewController:cinemaHallVC animated:YES];
    [cinemaHallVC release];
}

- (void)showLocation
{
    NSRange range = [self.cinemaItem.cinemaMapLocation rangeOfString:@";ll="];
    if (range.location != NSNotFound) {
        NSString *latitudeString = [self.cinemaItem.cinemaMapLocation substringFromIndex:range.location+4];
        NSRange latitudeRange= [latitudeString rangeOfString:@","];
        CLLocationDegrees latitude = [[latitudeString substringToIndex:latitudeRange.location] doubleValue];
        NSString *longitudeString = [latitudeString substringFromIndex:latitudeRange.location+1];
        NSRange longitudeRange = [longitudeString rangeOfString:@"&amp"];
        CLLocationDegrees longitude = [[longitudeString substringToIndex:longitudeRange.location] doubleValue];
        MKPointAnnotation *cinemaAnnotation = [[MKPointAnnotation alloc] init];
        cinemaAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        cinemaAnnotation.title = self.cinemaItem.cinemaName;
        cinemaAnnotation.subtitle = self.cinemaItem.cinemaAddress;
        
        NSArray *cinemaLocation = [NSArray arrayWithObjects:cinemaAnnotation, nil];
        [cinemaAnnotation release];
        MapViewController *mapVC = [[MapViewController alloc] init];
        mapVC.locations = cinemaLocation;
        [self.navigationController pushViewController:mapVC animated:YES];
        [mapVC release];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无位置信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)requestHallInfo
{
    NSString *fullpath = [[NSBundle mainBundle] pathForResource:@"request-cinemahall" ofType:@"xml"];
    NSString *requestString = [[NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"$_CINEMAID" withString:self.cinemaItem.cinemaId];
    NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kMovieAPILocation]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = requestData;
    
    self.downLoader.delegate = nil;
    DownLoadController *downLoadController = [[DownLoadController alloc] initWithRequest:request];
    downLoadController.delegate = self;
    self.downLoader = downLoadController;
    [downLoadController beginAsyncRequest];
    [downLoadController release];
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.frame = CGRectMake(135.0, headerSize+([UIScreen mainScreen].applicationFrame.size.height-44.0-48.0-50.0)/2, 50.0, 50.0);
    self.activityIndicatorView = activityIndicatorView;
    [self.tableView addSubview:activityIndicatorView];
    [activityIndicatorView release];
    
    [self.activityIndicatorView startAnimating];
}

- (void)responseReceived:(NSMutableData *)responseData
{
    self.responseData = responseData;
    [self downLoadFinish];
}

- (void)refreshFail:(NSURLConnection *)connection
{
    [self.hud hide:YES];
}

- (void)downLoadFinish
{
    NSLog(@"%@",[[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] autorelease]);
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.responseData options:0 error:nil];
    NSArray *hallNodes = [document nodesForXPath:@"//root//body//rows//wp_hall" error:nil];
    if (hallNodes && hallNodes.count>0) {
        self.hallItems = [NSMutableArray array];
        for (GDataXMLElement *hallNode in hallNodes) {
            HallItem *hallItem = [[HallItem alloc] init];
            hallItem.id = [[hallNode attributeForName:@"id"] stringValue];
            hallItem.hallId = [[hallNode attributeForName:@"hallid"] stringValue];
            hallItem.hallName = [[hallNode attributeForName:@"name"] stringValue];
            hallItem.seatCount = [[[hallNode attributeForName:@"seatcount"] stringValue] intValue];
            hallItem.vip = [[hallNode attributeForName:@"vip"] stringValue];
            hallItem.valid = [[[hallNode attributeForName:@"valid"] stringValue] intValue];
            [self.hallItems addObject:hallItem];
            [hallItem release];
        }
    }
    else {
        self.hallItems = [NSMutableArray array];
    }
    
    [document release];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    [self.activityIndicatorView stopAnimating];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"影厅";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.hallItems && self.hallItems.count>0) {
        return self.hallItems.count;
    }
    else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.hallItems && self.hallItems.count>0){
        return 60.0;
    }
    return [UIScreen mainScreen].applicationFrame.size.height-112.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hallItems && self.hallItems.count>0) {
        static NSString *CellIdentifier = @"MovieCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        HallItem *hallItem = [self.hallItems objectAtIndex:indexPath.row];
        NSMutableString *text = [NSMutableString string];
        [text appendString:hallItem.hallName];
        [text appendString:@"  "];
        [text appendString:[NSString stringWithFormat:@"%d",hallItem.seatCount]];
        [text appendString:@"座"];
        if (![hallItem.vip isEqualToString:@"N"]) {
            [text appendString:@"  "];
            [text appendString:@"vip厅"];
        }
        cell.textLabel.text = text;
        cell.textLabel.textColor = [UIColor whiteColor];
        NSString *detailText;
        if (hallItem.valid) {
            detailText = @"对外售票";
        }
        else {
            detailText = @"不对外售票";
        }
        cell.detailTextLabel.text = detailText;
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"MovieCellNone";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"暂无影厅信息";
        cell.textLabel.font = [UIFont systemFontOfSize:20.0];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
    }
}
@end
