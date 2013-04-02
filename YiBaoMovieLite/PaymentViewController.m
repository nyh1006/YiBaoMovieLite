//
//  PaymentViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-23.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "PaymentViewController.h"
#import "MovieConstants.h"
#import "GDataXMLNode.h"
#import "UserItem.h"
#import "UISeatButton.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"

@interface PaymentViewController ()
@property (retain, nonatomic) UILabel *paytypeLabel;
@property (retain, nonatomic) MBProgressHUD *hud;
@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSString *responseMessage;
@end

@implementation PaymentViewController
{
    BOOL isRequesting;
}
@synthesize backButtonTitle = _backButtonTitle;
@synthesize infoItem = _infoItem;
@synthesize selectedSeats = _selectedSeats;
@synthesize paytypeLabel = _paytypeLabel;
@synthesize hud = _hud;
@synthesize responseData = _responseData;
@synthesize responseMessage = _responseMessage;

- (void)dealloc
{
    [_backButtonTitle release];
    [_infoItem release];
    [_selectedSeats release];
    [_paytypeLabel release];
    [_hud release];
    [_responseData release];
    [_responseMessage release];
    
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
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    self.navigationItem.title = @"订单";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 310.0, 2.0)];
    topLabel.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:topLabel];
    [topLabel release];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 2.0, 210.0)];
    leftLabel.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:leftLabel];
    [leftLabel release];
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 215.0, 310.0, 2.0)];
    bottomLabel.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:bottomLabel];
    [bottomLabel release];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(315.0, 5.0, 2.0, 210.0)];
    rightLabel.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:rightLabel];
    [rightLabel release];
    
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 10.0, 300.0, 20.0)];
    orderLabel.backgroundColor = [UIColor clearColor];
    orderLabel.text = @"订单内容：";
    orderLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:orderLabel];
    [orderLabel release];
    
    UILabel *priceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 50.0, 100.0, 30.0)];
    priceNameLabel.backgroundColor = [UIColor clearColor];
    priceNameLabel.text = @"单价：";
    priceNameLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:priceNameLabel];
    [priceNameLabel release];
    
//    UserItem *currentUser = [UserItem sharedUser];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 50.0, 190.0, 30.0)];
    priceLabel.backgroundColor = [UIColor clearColor];
//    if (currentUser && [currentUser.paytype isEqualToString:@"2"]) {
    priceLabel.text = [NSString stringWithFormat:@"%.2f",self.infoItem.vipPrice/100];
//    }
//    else {
//    priceLabel.text = [NSString  stringWithFormat:@"%.2f",self.infoItem.price/100];
//    }
    [self.view addSubview:priceLabel];
    [priceLabel release];
    
    UILabel *seatLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 100.0, 100.0, 30.0)];
    seatLabel.backgroundColor = [UIColor clearColor];
    seatLabel.text = @"座位数：";
    seatLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:seatLabel];
    [seatLabel release];
    
    UILabel *seatAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 100.0, 190.0, 30.0)];
    seatAmountLabel.backgroundColor = [UIColor clearColor];
    seatAmountLabel.text = [NSString stringWithFormat:@"%d",self.selectedSeats.count];
    seatAmountLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:seatAmountLabel];
    [seatAmountLabel release];
    
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 130.0, 100.0, 30.0)];
    totalLabel.backgroundColor = [UIColor clearColor];
    totalLabel.text = @"总金额：";
    totalLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:totalLabel];
    [totalLabel release];
    
    UILabel *totalFundLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 130.0, 190.0, 30.0)];
    totalFundLabel.backgroundColor = [UIColor clearColor];
    totalFundLabel.text = [NSString stringWithFormat:@"%.2f",self.infoItem.price/100*self.selectedSeats.count];
    totalFundLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:totalFundLabel];
    [totalFundLabel release];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.frame = CGRectMake(200.0, 230.0, 100.0, 30.0);
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    isRequesting = NO;
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

- (void)submitOrder
{
    if (!isRequesting) {
        UserItem *userItem = [UserItem sharedUser];
        if (userItem) {
            isRequesting = YES;
            NSString *fullpath = [[NSBundle mainBundle] pathForResource:@"request-pay" ofType:@"xml"];
            NSString *requestString = [[[[[[[[NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"$_USERNAME" withString:userItem.userName] stringByReplacingOccurrencesOfString:@"$_USERPASSWORD" withString:userItem.password] stringByReplacingOccurrencesOfString:@"$_MOBILENUM" withString:userItem.mobileNum] stringByReplacingOccurrencesOfString:@"$_PAYTYPE" withString:userItem.paytype] stringByReplacingOccurrencesOfString:@"$_GOODNUM" withString:[NSString stringWithFormat:@"%d",self.selectedSeats.count]] stringByReplacingOccurrencesOfString:@"$_PRICE" withString:[NSString stringWithFormat:@"%d",(int)self.infoItem.vipPrice]] stringByReplacingOccurrencesOfString:@"$_SHOWID" withString:self.infoItem.showID];
            NSMutableString *requestMutableString = [NSMutableString string];
            for (UISeatButton *seatButton in self.selectedSeats) {
                [requestMutableString appendString:@"<wp_seat row=\""];
                [requestMutableString appendString:seatButton.rowId];
                [requestMutableString appendString:@"\" column=\""];
                [requestMutableString appendString:seatButton.columnId];
                [requestMutableString appendString:@"\"></wp_seat>"];
            }
            requestString = [requestString stringByReplacingOccurrencesOfString:@"$_WPSEAT" withString:requestMutableString];
            NSLog(@"%@",requestString);
            NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kMovieAPILocation]];
            request.HTTPMethod = @"POST";
            request.HTTPBody = requestData;
//            DownLoadController *downloader = [[DownLoadController alloc] initWithRequest:request];
//            downloader.delegate = self;
//            self.downloader = downloader;
//            [downloader beginAsyncRequest];
//            [downloader release];
            NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
            [connection start];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"请求中";
            self.hud = hud;
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }

    }
}

//- (void)responseReceived:(NSMutableData *)responseData
//{
//    self.responseData = responseData;
//    [self downLoadFinish];
//}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"无网络连接，请待会再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    
    isRequesting = NO;
    [self.hud hide:YES];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%@",[[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] autorelease]);
    NSLog(@"%@",[[UserItem sharedUser] mobileNum]);
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.responseData options:0 error:nil];
    NSString *responseCd = [[[document nodesForXPath:@"//root//rtn//rcd" error:nil] lastObject] stringValue];
    NSArray *payNodes = [document nodesForXPath:@"//root//rtn//rms" error:nil];
    GDataXMLElement *payNode = [payNodes objectAtIndex:0];
    self.responseMessage = [payNode stringValue];
    if ([responseCd isEqualToString:@"00"]) {
        
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:self.responseMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    [document release];
    isRequesting = NO;
    //dismiss wait view
    [self.hud hide:YES];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    LoginViewController *loginVC = [[LoginViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:loginVC];
//    [loginVC release];
//    [self presentViewController:navigation animated:YES completion:^{}];
//    [navigation release];
//}
@end
