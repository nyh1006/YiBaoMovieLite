//
//  ResetPwdViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 13-1-6.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import "FindPwdViewController.h"
#import "UserItem.h"
#import "MovieConstants.h"
#import "GDataXMLNode.h"
#import "MBProgressHUD.h"

@interface FindPwdViewController ()
@property (retain, nonatomic) UITextField *userNameField;
@property (retain, nonatomic) UITextField *mobileField;
@property (retain, nonatomic) MBProgressHUD *hud;
@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) UIAlertView *successView;
@end

@implementation FindPwdViewController
{
    BOOL isRequesting;
}
@synthesize backButtonTitle = _backButtonTitle;
@synthesize userNameField = _userNameField;
@synthesize mobileField = _mobileField;
@synthesize hud = _hud;
@synthesize responseData = _responseData;
@synthesize successView = _successView;

- (void)dealloc
{
    [_backButtonTitle release];
    [_userNameField release];
    [_mobileField release];
    [_hud release];
    [_responseData release];
    [_successView release];
    
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
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register.jpg"]];
    imageView.frame = CGRectMake(0.0, 0.0, 320.0, 416.0);
    [self.view addSubview:imageView];
    [imageView release];
    
    self.navigationItem.title = @"找回密码";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
//    UIButton *backButton = [UIButton buttonWithType:101];
//    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:self.backButtonTitle forState:UIControlStateNormal];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backItem;
//    [backItem release];
    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 30.0, 100.0, 30.0)];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.text = @"用户名：";
    userNameLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:userNameLabel];
    [userNameLabel release];
    
    UITextField *userNameField = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 30.0, 190.0, 30.0)];
    userNameField.borderStyle = UITextBorderStyleRoundedRect;
    userNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userNameField.keyboardType = UIKeyboardTypeAlphabet;
    userNameField.returnKeyType = UIReturnKeyNext;
    userNameField.placeholder = @"请输入用户名";
    userNameField.font = [UIFont systemFontOfSize:15.0];
    userNameField.delegate = self;
    self.userNameField = userNameField;
    [self.view addSubview:userNameField];
    [userNameField release];
    
    UILabel *mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 80.0, 100.0, 30.0)];
    mobileLabel.backgroundColor = [UIColor clearColor];
    mobileLabel.text = @"手机：";
    mobileLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:mobileLabel];
    [mobileLabel release];
    
    UITextField *mobileField = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 80.0, 190.0, 30.0)];
    mobileField.borderStyle = UITextBorderStyleRoundedRect;
    mobileField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    mobileField.returnKeyType = UIReturnKeyDone;
    mobileField.placeholder = @"请输入手机号码";
    mobileField.font = [UIFont systemFontOfSize:15.0];
    mobileField.delegate = self;
    self.mobileField = mobileField;
    [self.view addSubview:mobileField];
    [mobileField release];
    
    UILabel *instructLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 130.0, 320.0, 30.0)];
    instructLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    instructLabel.text = @"  密码将通过短信发送";
    instructLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:instructLabel];
    [instructLabel release];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.frame = CGRectMake(120.0, 170.0, 80.0, 30.0);
    [submitButton setTitle:@"确定" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidesKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer release];
    
    isRequesting = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.userNameField becomeFirstResponder];
    [super viewWillAppear:animated];
}

- (void)hidesKeyboard
{
    [self.userNameField resignFirstResponder];
    [self.mobileField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        [self.mobileField becomeFirstResponder];
    }
    if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
        [self submit];
    }
    return YES;
}

-(void)reset
{
    self.userNameField.text = nil;
    [self.view addSubview:self.userNameField];
    self.mobileField.text = nil;
    [self.view addSubview:self.mobileField];
}

- (void)submit
{
    [self hidesKeyboard];
    if (!isRequesting) {
        isRequesting = YES;
        NSString *fullpath = [[NSBundle mainBundle] pathForResource:@"request-findpwd" ofType:@"xml"];
        if (self.userNameField.text == nil) {
            self.userNameField.text = @"";
        }
        if (self.mobileField.text == nil) {
            self.mobileField.text = @"";
        }
        NSString *requestString = [[[NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"$_USERNAME" withString:self.userNameField.text] stringByReplacingOccurrencesOfString:@"$_MOBILENUM" withString:self.mobileField.text];
        NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kMovieAPILocation]];
        request.HTTPMethod = @"POST";
        request.HTTPBody = requestData;
        
//        DownLoadController *downloader = [[DownLoadController alloc] initWithRequest:request];
//        downloader.delegate = self;
//        self.downloader = downloader;
//        [downloader beginAsyncRequest];
//        [downloader release];
        
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        [connection start];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"请求中...";
        self.hud = hud;
    }
}

//- (void)responseReceived:(NSMutableData *)responseData
//{
//    self.responseData = responseData;
//    
//    [self downLoadFinish];
//}
//
//- (void)refreshFail:(NSURLConnection *)connection
//{
//    isRequesting = NO;
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
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.responseData options:0 error:nil];
    NSString *responseCd = [[[document nodesForXPath:@"//root//rtn//rcd" error:nil] lastObject] stringValue];
    NSString *responseMessage = [[[document nodesForXPath:@"//root//rtn//rms" error:nil] lastObject] stringValue];
    if ([responseCd isEqualToString:@"00"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:responseMessage delegate:self cancelButtonTitle:@"点击这里登录" otherButtonTitles:nil];
        self.successView = alertView;
        [alertView show];
        [alertView release];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:responseMessage delegate:nil cancelButtonTitle:@"点击这里返回" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        [self reset];
    }
    [document release];
    isRequesting = NO;
    
    //dismiss wait view
    [self.hud hide:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.successView)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
