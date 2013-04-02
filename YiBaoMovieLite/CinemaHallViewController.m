//
//  CinemaHallViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-17.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "CinemaHallViewController.h"
#import "GDataXMLNode.h"
#import "MovieConstants.h"
#import "DownLoadController.h"
#import "GDataXMLNode.h"
#import "HallItem.h"

@interface CinemaHallViewController ()
@property (retain,nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSMutableArray *hallItems;
@property (retain, nonatomic) DownLoadController *downLoader;
@end

@implementation CinemaHallViewController
@synthesize backButtonTitle = _backButtonTitle;
@synthesize cinemaId = _cinemaId;
@synthesize responseData = _responseData;
@synthesize hallItems = _hallItems;
@synthesize downLoader = _downLoader;

- (void)dealloc
{
    self.downLoader.delegate = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [_backButtonTitle release];
    [_cinemaId release];
    [_responseData release];
    [_hallItems release];
    [_downLoader release];
    
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
    self.navigationItem.title = @"影厅列表";
    
//    UIButton *backButton = [UIButton buttonWithType:101];
//    [backButton setTitle:self.backButtonTitle forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;
//    [backButtonItem release];
    
    NSString *fullpath = [[NSBundle mainBundle] pathForResource:@"request-cinemahall" ofType:@"xml"];
    NSString *requestString = [[NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"$_CINEMAID" withString:self.cinemaId];
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
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)responseReceived:(NSMutableData *)responseData
{
    self.responseData = responseData;
    [self downLoadFinish];
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
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.hallItems && self.hallItems.count>0) {
        return self.hallItems.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.hallItems && self.hallItems.count>0){
        return 60.0;
    }
    return [UIScreen mainScreen].applicationFrame.size.height-120.0;
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
