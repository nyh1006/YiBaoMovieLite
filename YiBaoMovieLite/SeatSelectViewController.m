//
//  SeatSelectViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-17.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "SeatSelectViewController.h"
#import "MovieConstants.h"
#import "GDataXMLNode.h"
#import "SeatItem.h"
#import "UISeatButton.h"
#import "PaymentViewController.h"
#import "UserItem.h"
#import "MBProgressHUD.h"

@interface SeatSelectViewController ()
@property (retain, nonatomic) UILabel *headerLabel;
@property (retain, nonatomic) UIScrollView *scrollView;
@property (retain, nonatomic) UIView *backgroundView;
@property (retain, nonatomic) UIView *rowView;
@property (retain, nonatomic) DownLoadController *downloader;
@property (retain, nonatomic) MBProgressHUD *hud;
@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSMutableArray *seatInfos;
@property (retain, nonatomic) NSMutableArray *rowPositions;
@property (retain, nonatomic) NSMutableOrderedSet *orderedSet;
@property (retain, nonatomic) UIView *buttonView;
@property (retain, nonatomic) UIImage *freeImage;            //可购座位
@property (retain, nonatomic) UIImage *saleImage;            //已卖座位
@property (retain, nonatomic) UIImage *loverImage;           //情侣座位
@property (retain, nonatomic) UIImage *damagedImage;         //损坏座位
@property (retain, nonatomic) UIImage *lockImage;            //已选座位
@property (retain, nonatomic) UIImage *lastImage;            //以前的座位
@property (retain, nonatomic) UIView *displayView;           //选座区域
@property (retain, nonatomic) UILabel *displayLabel1;
@property (retain, nonatomic) UILabel *displayLabel2;
@property (retain, nonatomic) UILabel *displayLabel3;
@property (retain, nonatomic) UILabel *displayLabel4;
@property (retain, nonatomic) UILabel *displayLabel5;
@property (retain, nonatomic) UILabel *displayLabel6;
@property (retain, nonatomic) UILabel *displayLabel7;
@property (retain, nonatomic) UILabel *displayLabel8;
@property (retain, nonatomic) NSMutableArray *selectedSeats; //已选座位
@end

@implementation SeatSelectViewController
{
    NSInteger maxRowNum;
    NSInteger maxColumnNum;
    CGFloat columnScale;
    CGFloat rowScale;
}
@synthesize backButtonTitle = _backButtonTitle;
@synthesize headerLabel = _headerLabel;
@synthesize infoItem = _infoItem;
@synthesize scrollView = _scrollView;
@synthesize backgroundView = _backgroundView;
@synthesize rowView = _rowView;
@synthesize downloader = _downloader;
@synthesize hud = _hud;
@synthesize responseData = _responseData;
@synthesize seatInfos = _seatInfos;
@synthesize rowPositions = _rowPositions;
@synthesize orderedSet = _orderedSet;
@synthesize buttonView = _buttonView;
@synthesize freeImage = _freeImage;
@synthesize saleImage = _saleImage;
@synthesize loverImage = _loverImage;
@synthesize damagedImage = _damagedImage;
@synthesize lockImage = _lockImage;
@synthesize displayView = _displayView;
@synthesize displayLabel1 = _displayLabel1;
@synthesize displayLabel2 = _displayLabel2;
@synthesize displayLabel3 = _displayLabel3;
@synthesize displayLabel4 = _displayLabel4;
@synthesize displayLabel5 = _displayLabel5;
@synthesize displayLabel6 = _displayLabel6;
@synthesize displayLabel7 = _displayLabel7;
@synthesize displayLabel8 = _displayLabel8;
@synthesize selectedSeats = _selectedSeats;

- (void)dealloc
{
    [_backButtonTitle release];
    [_headerLabel release];
    [_infoItem release];
    [_scrollView release];
    [_backgroundView release];
    [_rowView release];
    [_downloader release];
    [_hud release];
    [_responseData release];
    [_seatInfos release];
    [_rowPositions release];
    [_orderedSet release];
    [_buttonView release];
    [_freeImage release];
    [_saleImage release];
    [_loverImage release];
    [_damagedImage release];
    [_lockImage release];
    [_displayView release];
    [_displayLabel1 release];
    [_displayLabel2 release];
    [_displayLabel3 release];
    [_displayLabel4 release];
    [_displayLabel5 release];
    [_displayLabel6 release];
    [_displayLabel7 release];
    [_displayLabel8 release];
    [_selectedSeats release];
    
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
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
    self.navigationItem.title = @"选座";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:101];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:self.backButtonTitle forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];
    
    UIBarButtonItem *payButton= [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(pay)];
    self.navigationItem.rightBarButtonItem = payButton;
    [payButton release];
    
    UIView *instructView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 40.0, 320.0, 45.0)];
    instructView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:instructView];
    [instructView release];
    
    UIButton *freeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    freeButton.frame = CGRectMake(12.5, 5.0, 15.0, 15.0);
    [freeButton setImage:[UIImage imageNamed:@"free.gif"] forState:UIControlStateNormal];
    freeButton.userInteractionEnabled = NO;
    [instructView addSubview:freeButton];
    
    UILabel *freeLabel = [[UILabel alloc] initWithFrame:CGRectMake(27.5, 5.0, 75.0, 15.0)];
    freeLabel.backgroundColor = [UIColor clearColor];
    freeLabel.text = @"可购座位";
    freeLabel.font = [UIFont systemFontOfSize:15.0];
    [instructView addSubview:freeLabel];
    [freeLabel release];
    
    UIButton *lockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lockButton.frame = CGRectMake(115.0, 5.0, 15.0, 15.0);
    [lockButton setImage:[UIImage imageNamed:@"lock.gif"] forState:UIControlStateNormal];
    lockButton.userInteractionEnabled = NO;
    [instructView addSubview:lockButton];
    
    UILabel *lockLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 5.0, 75.0, 15.0)];
    lockLabel.backgroundColor = [UIColor clearColor];
    lockLabel.text = @"已选的座位";
    lockLabel.font = [UIFont systemFontOfSize:15.0];
    [instructView addSubview:lockLabel];
    [lockLabel release];

    UIButton *saleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saleButton.frame = CGRectMake(217.5, 5.0, 15.0, 15.0);
    [saleButton setImage:[UIImage imageNamed:@"sale.gif"] forState:UIControlStateNormal];
    saleButton.userInteractionEnabled = NO;
    [instructView addSubview:saleButton];
    
    UILabel *saleLabel = [[UILabel alloc] initWithFrame:CGRectMake(232.5, 5.0, 75.0, 15.0)];
    saleLabel.backgroundColor = [UIColor clearColor];
    saleLabel.text = @"已售出座位";
    saleLabel.font = [UIFont systemFontOfSize:15.0];
    [instructView addSubview:saleLabel];
    [saleLabel release];
    
    UIButton *damagedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    damagedButton.frame = CGRectMake(12.5, 25.0, 15.0, 15.0);
    [damagedButton setImage:[UIImage imageNamed:@"damaged.gif"] forState:UIControlStateNormal];
    damagedButton.userInteractionEnabled = NO;
    [instructView addSubview:damagedButton];
    
    UILabel *damagedLabel = [[UILabel alloc] initWithFrame:CGRectMake(27.5, 25.0, 75.0, 15.0)];
    damagedLabel.backgroundColor = [UIColor clearColor];
    damagedLabel.text = @"已损坏座位";
    damagedLabel.font = [UIFont systemFontOfSize:15.0];
    [instructView addSubview:damagedLabel];
    [damagedLabel release];
    
    UIButton *loverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loverButton.frame = CGRectMake(115.0, 25.0, 15.0, 15.0);
    [loverButton setImage:[UIImage imageNamed:@"lover.gif"] forState:UIControlStateNormal];
    loverButton.userInteractionEnabled = NO;
    [instructView addSubview:loverButton];
    
    UILabel *loverLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 25.0, 75.0, 15.0)];
    loverLabel.backgroundColor = [UIColor clearColor];
    loverLabel.text = @"情侣座位";
    loverLabel.font = [UIFont systemFontOfSize:15.0];
    [instructView addSubview:loverLabel];
    [loverLabel release];
    
    UIView *displayView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    displayView.backgroundColor = [UIColor clearColor];
    self.displayView = displayView;
    [self.view addSubview:displayView];
    [displayView release];
    
    UILabel *displayLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 80.0, 20.0)];
    displayLabel1.backgroundColor = [UIColor clearColor];
    displayLabel1.font = [UIFont systemFontOfSize:15.0];
    displayLabel1.textAlignment = NSTextAlignmentCenter;
    displayLabel1.textColor = [UIColor orangeColor];
    self.displayLabel1 = displayLabel1;
    [self.displayView addSubview:displayLabel1];
    [displayLabel1 release];
    UILabel *displayLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(80.0, 0.0, 80.0, 20.0)];
    displayLabel2.backgroundColor = [UIColor clearColor];
    displayLabel2.font = [UIFont systemFontOfSize:15.0];
    displayLabel2.textAlignment = NSTextAlignmentCenter;
    displayLabel2.textColor = [UIColor orangeColor];
    self.displayLabel2 = displayLabel2;
    [self.displayView addSubview:displayLabel2];
    [displayLabel2 release];
    UILabel *displayLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(160.0, 0.0, 80.0, 20.0)];
    displayLabel3.backgroundColor = [UIColor clearColor];
    displayLabel3.font = [UIFont systemFontOfSize:15.0];
    displayLabel3.textAlignment = NSTextAlignmentCenter;
    displayLabel3.textColor = [UIColor orangeColor];
    self.displayLabel3 = displayLabel3;
    [self.displayView addSubview:displayLabel3];
    [displayLabel3 release];
    UILabel *displayLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(240.0, 0.0, 80.0, 20.0)];
    displayLabel4.backgroundColor = [UIColor clearColor];
    displayLabel4.font = [UIFont systemFontOfSize:15.0];
    displayLabel4.textAlignment = NSTextAlignmentCenter;
    displayLabel4.textColor = [UIColor orangeColor];
    self.displayLabel4 = displayLabel4;
    [self.displayView addSubview:displayLabel4];
    [displayLabel4 release];
    UILabel *displayLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 20.0, 80.0, 20.0)];
    displayLabel5.backgroundColor = [UIColor clearColor];
    displayLabel5.font = [UIFont systemFontOfSize:15.0];
    displayLabel5.textAlignment = NSTextAlignmentCenter;
    displayLabel5.textColor = [UIColor orangeColor];
    self.displayLabel5 = displayLabel5;
    [self.displayView addSubview:displayLabel5];
    [displayLabel5 release];
    UILabel *displayLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(80.0, 20.0, 80.0, 20.0)];
    displayLabel6.backgroundColor = [UIColor clearColor];
    displayLabel6.font = [UIFont systemFontOfSize:15.0];
    displayLabel6.textAlignment = NSTextAlignmentCenter;
    displayLabel6.textColor = [UIColor orangeColor];
    self.displayLabel6 = displayLabel6;
    [self.displayView addSubview:displayLabel6];
    [displayLabel6 release];
    UILabel *displayLabel7 = [[UILabel alloc] initWithFrame:CGRectMake(160.0, 20.0, 80.0, 20.0)];
    displayLabel7.backgroundColor = [UIColor clearColor];
    displayLabel7.font = [UIFont systemFontOfSize:15.0];
    displayLabel7.textAlignment = NSTextAlignmentCenter;
    displayLabel7.textColor = [UIColor orangeColor];
    self.displayLabel7 = displayLabel7;
    [self.displayView addSubview:displayLabel7];
    [displayLabel7 release];
    UILabel *displayLabel8 = [[UILabel alloc] initWithFrame:CGRectMake(240.0, 20.0, 80.0, 20.0)];
    displayLabel8.backgroundColor = [UIColor clearColor];
    displayLabel8.font = [UIFont systemFontOfSize:15.0];
    displayLabel8.textAlignment = NSTextAlignmentCenter;
    displayLabel8.textColor = [UIColor orangeColor];
    self.displayLabel8 = displayLabel8;
    [self.displayView addSubview:displayLabel8];
    [displayLabel8 release];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 85.0, 320.0, 20.0)];
    headerLabel.backgroundColor = [UIColor darkGrayColor];
    NSMutableString *text = [NSMutableString string];
    [text appendString:self.infoItem.hallID];
    [text appendString:@"号厅"];
//    [text appendString:[NSString stringWithFormat:@"%d",[self.seatInfos count]]];
    [text appendString:@"银幕方向"];
    self.headerLabel = headerLabel;
    headerLabel.text = text;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:headerLabel];
    [headerLabel release];
    
    //设置上层scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 105.0, 320.0, [UIScreen mainScreen].bounds.size.height-217.0)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    [scrollView release];
    
    NSString *fullpath = [[NSBundle mainBundle] pathForResource:@"request-seat" ofType:@"xml"];
    NSString *requestString = [NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil];
    requestString = [requestString stringByReplacingOccurrencesOfString:@"$_SHOWID" withString:self.infoItem.showID];
    NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kMovieAPILocation]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = requestData;
    
    self.downloader.delegate = nil;
    DownLoadController *downloader = [[DownLoadController alloc] initWithRequest:request];
    downloader.delegate = self;
    self.downloader = downloader;
    [downloader beginAsyncRequest];
    [downloader release];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.scrollView animated:YES];
    hud.labelText = @"加载中...";
    self.hud = hud;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack
{
    self.downloader.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pay
{
    if (self.selectedSeats.count>0) {
        PaymentViewController *payVC = [[PaymentViewController alloc] init];
        payVC.backButtonTitle = self.navigationItem.title;
        payVC.infoItem = self.infoItem;
        payVC.selectedSeats = self.selectedSeats;
        [self.navigationController pushViewController:payVC animated:YES];
        [payVC release];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未选择座位，请选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
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
    NSString *responseCd = [[[document nodesForXPath:@"//root//rtn//rcd" error:nil] lastObject] stringValue];
    if ([responseCd isEqualToString:@"00"]) {
        NSString *seatNum = [[[[document nodesForXPath:@"//root//body//rows" error:nil] lastObject] attributeForName:@"num"] stringValue];
        NSMutableString *text = [NSMutableString string];
        [text appendString:self.infoItem.hallID];
        [text appendString:@"号厅("];
        [text appendString:seatNum];
        [text appendString:@"座)银幕方向"];
        self.headerLabel.text = text;
        NSArray *seatNodes = [document nodesForXPath:@"//root//body//rows//wp_seat" error:nil];
        if (seatNodes && [seatNodes count]>0) {
            self.seatInfos = [NSMutableArray array];
            for (GDataXMLElement *seatNode in seatNodes) {
                SeatItem *seatItem = [[SeatItem alloc] init];
                seatItem.cinemaId = [[seatNode attributeForName:@"cinemaid"] stringValue];
                seatItem.hallId = [[seatNode attributeForName:@"hallid"] stringValue];
                seatItem.rowId = [[seatNode attributeForName:@"rowid"] stringValue];
                seatItem.rowDesc = [[seatNode attributeForName:@"rowdesc"] stringValue];
                seatItem.columnId = [[seatNode attributeForName:@"columnid"] stringValue];
                seatItem.columnDesc = [[seatNode attributeForName:@"columndesc"] stringValue];
                seatItem.seatType = [[seatNode attributeForName:@"seattype"] stringValue];
                seatItem.damaged = [[seatNode attributeForName:@"damaged"] stringValue];
                seatItem.status = [[[seatNode attributeForName:@"status"] stringValue] intValue];
                
                [self.seatInfos addObject:seatItem];
                [seatItem release];
            }
            if ([seatNum intValue]>0) {
                [self refreshView];
            }
        }
        else{
            self.seatInfos = [NSMutableArray array];
        }
    }
    else {
        NSString *responseMessage = [[[document nodesForXPath:@"//root//rtn//rms" error:nil] lastObject] stringValue];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:responseMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    
    [document release];
    
    //dismiss wait view
    [self.hud hide:YES];
}

- (void)refreshView
{
    maxRowNum = 0;
    maxColumnNum = 0;
    
    //座位的5种背景图片
    self.freeImage = [UIImage imageNamed:@"free.gif"];
    self.saleImage = [UIImage imageNamed:@"sale.gif"];
    self.loverImage = [UIImage imageNamed:@"lover.gif"];
    self.damagedImage = [UIImage imageNamed:@"damaged.gif"];
    self.lockImage = [UIImage imageNamed:@"lock.gif"];
    
    //求座位的最大显示行号和最大显示列号
    for (int i=0; i<[self.seatInfos count]; i++) {
        //求最大行数
        if ([[[self.seatInfos objectAtIndex:i] rowDesc] intValue]>maxRowNum) {
            maxRowNum = [[[self.seatInfos objectAtIndex:i] rowDesc] intValue];
        } 
        //求最大列数
        if ([[[self.seatInfos objectAtIndex:i] columnDesc] intValue]>maxColumnNum) {
            maxColumnNum = [[[self.seatInfos objectAtIndex:i] columnDesc] intValue];
        }
    }
    
    columnScale = 320.0/(30.0+30.0*maxColumnNum-10.0);
    rowScale = ([UIScreen mainScreen].bounds.size.height-218.0)/(30.0*maxRowNum-10.0);
    
    //scrollView的内层view，放大缩小的目标view
//    if (columnScale <rowScale) {
//        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0+25.0*maxColumnNum-5.0, ([UIScreen mainScreen].bounds.size.height-253.0)/columnScale)];
//        self.buttonView = buttonView;
//        [self.scrollView addSubview:buttonView];
//        [buttonView release];
//    }
//    else {
//        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0/rowScale, 25.0*maxRowNum-5.0)];
//        self.buttonView = buttonView;
//        [self.scrollView addSubview:buttonView];
//        [buttonView release];
//    }
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0+30.0*maxColumnNum-10.0, 30.0*maxRowNum-10.0)];
    self.buttonView = buttonView;
    [self.scrollView addSubview:buttonView];
    [buttonView release];
    
    //40.0+25.0*maxRowNum
    //设置scrollView的滚动区域
//    if (columnScale<rowScale) {
//        self.scrollView.contentSize = CGSizeMake(30.0+25.0*maxColumnNum-5.0, ([UIScreen mainScreen].bounds.size.height-253.0)/columnScale);
//    }
//    else {
//        self.scrollView.contentSize = CGSizeMake(320.0/rowScale, 25.0*maxRowNum-5.0);
//    }
    self.scrollView.contentSize = CGSizeMake(30.0+30.0*maxColumnNum-10.0, 30.0*maxRowNum-10.0);
    
    //设置scrollView的最大缩放比例为1.0
    self.scrollView.maximumZoomScale = 1.0;
    //设置scrollView的最小缩放比例
    if (columnScale < rowScale) {
        self.scrollView.minimumZoomScale = self.scrollView.frame.size.width/self.scrollView.contentSize.width;
    }
    else {
        self.scrollView.minimumZoomScale = self.scrollView.frame.size.height/self.scrollView.contentSize.height;
    }
    
    //设置触发座位显示缩放的手势
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleZoom:)];
//    recognizer.delegate=self;
    recognizer.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:recognizer];
    [recognizer release];
    
    //存放所有seat的行坐标
    self.orderedSet = [NSMutableOrderedSet orderedSet];
    self.rowPositions = [NSMutableArray array];
    for (int i=0; i<[self.seatInfos count]; i++) {
        SeatItem *seatItem = [self.seatInfos objectAtIndex:i];
        int rowPosition = [seatItem.rowDesc intValue]-1;
        int columnPosition = [seatItem.columnDesc intValue]-1;
        
        //将seat的行坐标添加到set
        [self.rowPositions addObject:[NSNumber numberWithInt:rowPosition]];
        
        UISeatButton *seatButton = [UISeatButton buttonWithType:UIButtonTypeCustom];
        seatButton.frame = CGRectMake(30.0+30.0*columnPosition, 30.0*rowPosition, 20.0, 20.0);
        seatButton.rowId = seatItem.rowId;
        seatButton.columnId = seatItem.columnId;
        seatButton.exclusiveTouch = YES;
        
        if ([seatItem.damaged isEqualToString:@"N"]) {
            if (!seatItem.status) {
                if (![seatItem.seatType isEqualToString:@"N"]) {
                    [seatButton setImage:self.loverImage forState:UIControlStateNormal];
                }
                else {
                    [seatButton setImage:self.freeImage forState:UIControlStateNormal];
                }
                [seatButton addTarget:self action:@selector(selectSeat:)forControlEvents:UIControlEventTouchUpInside];
                UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
                gestureRecognizer.numberOfTapsRequired = 2;
                [seatButton addGestureRecognizer:gestureRecognizer];
                [gestureRecognizer release];
            }
            else if (seatItem.status) {
                seatButton.userInteractionEnabled = NO;
                [seatButton setImage:self.saleImage forState:UIControlStateNormal];
            }
        }
        else if (![seatItem.damaged isEqualToString:@"N"]) {
            seatButton.userInteractionEnabled = NO;
            [seatButton setImage:self.damagedImage forState:UIControlStateNormal];
        }
        [self.buttonView addSubview:seatButton];
    }
    
    //行号view
    if (columnScale < rowScale) {
        UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0.0, -1000.0, 30.0,([UIScreen mainScreen].bounds.size.height-218.0)/columnScale+2000.0)];
        rowView.backgroundColor = [UIColor grayColor];
//        rowView.layer.opacity = 0.6;
        self.rowView = rowView;
        [self.buttonView addSubview:rowView];
        [rowView release];
    }
    else {
        UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0.0, -1000.0, 30.0, 30.0*maxRowNum-10.0+2000.0)];
        rowView.backgroundColor = [UIColor grayColor];
//        rowView.layer.opacity = 0.5;
        self.rowView = rowView;
        [self.buttonView addSubview:rowView];
        [rowView release];
    }
        
    //将seat的行(纵)坐标按从小到大排列
    int min;
    for (int i=0; i<self.rowPositions.count; i++) {
        min =i;
        for (int j=i+1; j<self.rowPositions.count; j++) {
            if ([[self.rowPositions objectAtIndex:min] intValue]>[[self.rowPositions objectAtIndex:j] intValue]) {
                min = j;
            }
        }
        if (min != i) {
            NSNumber *number = [self.rowPositions objectAtIndex:min];
            [self.rowPositions replaceObjectAtIndex:min withObject:[self.rowPositions objectAtIndex:i]];
            [self.rowPositions replaceObjectAtIndex:i withObject:number];
        }
    }
    
    [self.orderedSet addObjectsFromArray:self.rowPositions];
    for (int i=0; i<self.orderedSet.count; i++) {
        NSLog(@"%d",[[self.orderedSet objectAtIndex:i] intValue]);
    }
    
    //给行号条添加Label
    for (int i=0; i<self.orderedSet.count; i++) {
        UILabel *rowDecLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 30.0*[[self.orderedSet objectAtIndex:i] intValue]+1000.0, 30.0, 20.0)];
        rowDecLabel.backgroundColor = [UIColor clearColor];
        rowDecLabel.text = [NSString stringWithFormat:@"%d",i+1];
        rowDecLabel.textAlignment = NSTextAlignmentCenter;
        rowDecLabel.textColor = [UIColor blackColor];
        rowDecLabel.font = [UIFont systemFontOfSize:15.0];
        [self.rowView addSubview:rowDecLabel];
        [rowDecLabel release];
    }
    
    self.selectedSeats = [NSMutableArray array];
    
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (columnScale < rowScale) {
        [self.rowView setFrame:CGRectMake(self.scrollView.contentOffset.x/scrollView.zoomScale, -1000.0, 30.0, ([UIScreen mainScreen].bounds.size.height-218.0)/columnScale+2000.0)];
    }
    else {
        [self.rowView setFrame:CGRectMake(self.scrollView.contentOffset.x/scrollView.zoomScale, -1000.0, 30.0, 30.0*maxRowNum-10.0+2000.0)];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.buttonView;
}

- (void)toggleZoom:(UITapGestureRecognizer *)recognizer
{
    if (self.scrollView.zoomScale >= self.scrollView.maximumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
        //        [self performSelector:@selector(setFrame1) withObject:nil afterDelay:0.2];
    }
    else {
        CGPoint touchLocation = [recognizer locationInView:self.buttonView];
        [self.scrollView zoomToRect:CGRectMake(touchLocation.x-320.0/2, touchLocation.y-([UIScreen mainScreen].bounds.size.height-218.0)/2, 320.0, [UIScreen mainScreen].bounds.size.height-218.0) animated:YES];
        //        [self performSelector:@selector(setFrame2) withObject:nil afterDelay:0.2];
    }
}

- (BOOL)isSelected:(UISeatButton *)seatButton
{
    if (self.selectedSeats && self.selectedSeats.count>0) {
        NSMutableArray *selectedSeatsWithRowId = [NSMutableArray array];
        for (int i=0; i<self.selectedSeats.count; i++) {
            UISeatButton *theButton = [self.selectedSeats objectAtIndex:i];
            if ([seatButton.rowId isEqualToString:theButton.rowId]) {
                [selectedSeatsWithRowId addObject:theButton];
            }
        }
        if (selectedSeatsWithRowId.count>0) {
            for (int j=0; j<selectedSeatsWithRowId.count; j++) {
                UISeatButton *theButtonWithRowId = [selectedSeatsWithRowId objectAtIndex:j];
                if ([seatButton.columnId intValue] == [theButtonWithRowId.columnId intValue]-1 || [seatButton.columnId intValue] == [theButtonWithRowId.columnId intValue]+1) {
                    return YES;
                }
            }
            return NO;
        }
        else {
            return YES;
        }
    }
    else {
        return YES;
    }
}

- (BOOL)isCancelSelected:(UISeatButton *)seatButton
{
    NSMutableArray *selectedSeatsWithRowId = [NSMutableArray array];
    for (int i=0; i<self.selectedSeats.count; i++) {
        UISeatButton *theButton = [self.selectedSeats objectAtIndex:i];
        if ([seatButton.rowId isEqualToString:theButton.rowId]) {
            [selectedSeatsWithRowId addObject:theButton];
        }
    }
    for (int j=0; j<selectedSeatsWithRowId.count; j++) {
        UISeatButton *theButtonWithRowId = [selectedSeatsWithRowId objectAtIndex:j];
        if ([seatButton.columnId intValue] == [theButtonWithRowId.columnId intValue]-1)
        {
            for (int j=0; j<selectedSeatsWithRowId.count; j++) {
                UISeatButton *theButton = [selectedSeatsWithRowId objectAtIndex:j];
                if ([seatButton.columnId intValue] == [theButton.columnId intValue]+1)
                {
                    return NO;
                }
            }
        }
    }
    return YES;
}

- (void)selectSeat:(UISeatButton *)seatButton
{
    //如果seatButton未选中
    if(seatButton.imageView.image != self.lockImage)
    {
        if ([self isSelected:seatButton]) {
            if (self.selectedSeats.count >= 8)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多选择8个座位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            }
            else
            {
                [self.selectedSeats addObject:seatButton];
                
                seatButton.position = self.selectedSeats.count-1;
                
                if (self.selectedSeats.count == 1) {
                    self.displayLabel1.text = [[[seatButton.rowId stringByAppendingString:@"排"] stringByAppendingString:seatButton.columnId] stringByAppendingString:@"座"];
                    [self.displayView addSubview:self.displayLabel1];
                }
                else if (self.selectedSeats.count == 2) {
                    self.displayLabel2.text = [[[seatButton.rowId stringByAppendingString:@"排"] stringByAppendingString:seatButton.columnId] stringByAppendingString:@"座"];
                    [self.displayView addSubview:self.displayLabel2];
                }
                else if (self.selectedSeats.count == 3)
                {
                    self.displayLabel3.text = [[[seatButton.rowId stringByAppendingString:@"排"] stringByAppendingString:seatButton.columnId] stringByAppendingString:@"座"];
                    [self.displayView addSubview:self.displayLabel3];
                }
                else if (self.selectedSeats.count == 4)
                {
                    self.displayLabel4.text = [[[seatButton.rowId stringByAppendingString:@"排"] stringByAppendingString:seatButton.columnId] stringByAppendingString:@"座"];
                    [self.displayView addSubview:self.displayLabel4];
                }
                else if (self.selectedSeats.count == 5)
                {
                    self.displayLabel5.text = [[[seatButton.rowId stringByAppendingString:@"排"] stringByAppendingString:seatButton.columnId] stringByAppendingString:@"座"];
                    [self.displayView addSubview:self.displayLabel5];
                }
                else if (self.selectedSeats.count == 6)
                {
                    self.displayLabel6.text = [[[seatButton.rowId stringByAppendingString:@"排"] stringByAppendingString:seatButton.columnId] stringByAppendingString:@"座"];
                    [self.displayView addSubview:self.displayLabel6];
                }
                else if (self.selectedSeats.count == 7)
                {
                    self.displayLabel7.text = [[[seatButton.rowId stringByAppendingString:@"排"] stringByAppendingString:seatButton.columnId] stringByAppendingString:@"座"];
                    [self.displayView addSubview:self.displayLabel7];
                }
                else if (self.selectedSeats.count == 8)
                {
                    self.displayLabel8.text = [[[seatButton.rowId stringByAppendingString:@"排"] stringByAppendingString:seatButton.columnId] stringByAppendingString:@"座"];
                    [self.displayView addSubview:self.displayLabel8];
                }
                if (seatButton.imageView.image == self.freeImage)
                {
                    self.lastImage = self.freeImage;
                    [seatButton setImage:self.lockImage forState:UIControlStateNormal];
                    [self.buttonView addSubview:seatButton];
                }
                else if (seatButton.imageView.image == self.loverImage)
                {
                    self.lastImage = self.loverImage;
                    [seatButton setImage:self.lockImage forState:UIControlStateNormal];
                    [self.buttonView addSubview:seatButton];
                }
            }
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择同行相邻座位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
    //如果seatButton已选中
    else if (seatButton.imageView.image == self.lockImage)
    {
        if ([self isCancelSelected:seatButton]) {
            if (self.selectedSeats.count>0) {
                [self.selectedSeats removeObjectAtIndex:seatButton.position];
            }
            
            for (int i=seatButton.position; i<self.selectedSeats.count; i++) {
                UISeatButton *seatButton = [self.selectedSeats objectAtIndex:i];
                seatButton.position--;
            }
            
            if (self.selectedSeats.count >= 1) {
                SeatItem *seatItem = [self.selectedSeats objectAtIndex:0];
                self.displayLabel1.text = [[[seatItem.rowId stringByAppendingString:@"排"] stringByAppendingString:seatItem.columnId] stringByAppendingString:@"座"];
            }
            else {
                self.displayLabel1.backgroundColor = [UIColor clearColor];
                self.displayLabel1.text = nil;
            }
            [self.displayView addSubview:self.displayLabel1];
            
            if (self.selectedSeats.count >= 2) {
                SeatItem *seatItem = [self.selectedSeats objectAtIndex:1];
                self.displayLabel2.text = [[[seatItem.rowId stringByAppendingString:@"排"] stringByAppendingString:seatItem.columnId] stringByAppendingString:@"座"];
            }
            else {
                self.displayLabel2.backgroundColor = [UIColor clearColor];
                self.displayLabel2.text = nil;
            }
            [self.displayView addSubview:self.displayLabel2];
            
            if (self.selectedSeats.count >= 3) {
                SeatItem *seatItem = [self.selectedSeats objectAtIndex:2];
                self.displayLabel3.text = [[[seatItem.rowId stringByAppendingString:@"排"] stringByAppendingString:seatItem.columnId] stringByAppendingString:@"座"];
            }
            else {
                self.displayLabel3.backgroundColor = [UIColor clearColor];
                self.displayLabel3.text = nil;
            }
            [self.displayView addSubview:self.displayLabel3];
            
            if (self.selectedSeats.count >= 4) {
                SeatItem *seatItem = [self.selectedSeats objectAtIndex:3];
                self.displayLabel4.text = [[[seatItem.rowId stringByAppendingString:@"排"] stringByAppendingString:seatItem.columnId] stringByAppendingString:@"座"];
            }
            else {
                self.displayLabel4.backgroundColor = [UIColor clearColor];
                self.displayLabel4.text = nil;
            }
            [self.displayView addSubview:self.displayLabel4];
            
            if (self.selectedSeats.count >= 5) {
                SeatItem *seatItem = [self.selectedSeats objectAtIndex:4];
                self.displayLabel5.text = [[[seatItem.rowId stringByAppendingString:@"排"] stringByAppendingString:seatItem.columnId] stringByAppendingString:@"座"];
            }
            else {
                self.displayLabel5.backgroundColor = [UIColor clearColor];
                self.displayLabel5.text = nil;
            }
            [self.displayView addSubview:self.displayLabel5];
            
            if (self.selectedSeats.count >= 6) {
                SeatItem *seatItem = [self.selectedSeats objectAtIndex:5];
                self.displayLabel6.text = [[[seatItem.rowId stringByAppendingString:@"排"] stringByAppendingString:seatItem.columnId] stringByAppendingString:@"座"];
            }
            else {
                self.displayLabel6.backgroundColor = [UIColor clearColor];
                self.displayLabel6.text = nil;
            }
            [self.displayView addSubview:self.displayLabel6];
            
            if (self.selectedSeats.count >= 7) {
                SeatItem *seatItem = [self.selectedSeats objectAtIndex:6];
                self.displayLabel7.text = [[[seatItem.rowId stringByAppendingString:@"排"] stringByAppendingString:seatItem.columnId] stringByAppendingString:@"座"];
            }
            else {
                self.displayLabel7.backgroundColor = [UIColor clearColor];
                self.displayLabel7.text = nil;
            }
            [self.displayView addSubview:self.displayLabel7];
            
            self.displayLabel8.backgroundColor = [UIColor clearColor];
            self.displayLabel8.text = nil;
            [self.displayView addSubview:self.displayLabel8];
            
            [seatButton setImage:self.lastImage forState:UIControlStateNormal];
            [self.buttonView addSubview:seatButton];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此座位暂不可取消，请先取消同行边缘座位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
}

@end
