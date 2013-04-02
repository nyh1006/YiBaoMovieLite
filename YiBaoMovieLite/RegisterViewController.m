//
//  RegisterViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-28.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "RegisterViewController.h"
#import "MovieConstants.h"
#import "GDataXMLNode.h"
#import "string.h"
#import "UserItem.h"
#import "MBProgressHUD.h"

@interface RegisterViewController ()
@property (retain, nonatomic) UIScrollView *scrollView;
@property (retain, nonatomic) UITextField *userNameField;
@property (retain, nonatomic) UITextField *passwordField;
@property (retain, nonatomic) UITextField *rePasswordField;
@property (retain, nonatomic) UITextField *mobileField;
@property (retain, nonatomic) MBProgressHUD *hud;
@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) UIAlertView *successView;
@end

@implementation RegisterViewController
{
    BOOL isRequesting;
}
@synthesize backButtonTitle = _backButtonTitle;
@synthesize scrollView = _scrollView;
@synthesize userNameField = _userNameField;
@synthesize passwordField = _passwordField;
@synthesize rePasswordField = _rePasswordField;
@synthesize mobileField = _mobileField;
@synthesize hud = _hud;
@synthesize responseData = _responseData;
@synthesize successView = _successView;

- (void)dealloc
{
    [_backButtonTitle release];
    [_scrollView release];
    [_userNameField release];
    [_passwordField release];
    [_rePasswordField release];
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
//    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];]
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register.jpg"]];
    imageView.frame = CGRectMake(0.0, 0.0, 320.0, 367.0);
    [self.view addSubview:imageView];
    [imageView release];
    
    self.navigationItem.title = @"用户注册";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
//    UIButton *backButton = [UIButton buttonWithType:101];
//    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:self.backButtonTitle forState:UIControlStateNormal];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backItem;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0)];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    [scrollView release];
    
    UILabel *instructLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 10.0, 240.0, 20.0)];
    instructLabel.backgroundColor = [UIColor clearColor];
    instructLabel.text = @"请填写以下用户信息：";
    instructLabel.font = [UIFont systemFontOfSize:18.0];
    instructLabel.textColor = [UIColor redColor];
    [self.scrollView addSubview:instructLabel];
    [instructLabel release];
    
    UILabel *mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 40.0, 240.0, 20.0)];
    mobileLabel.backgroundColor = [UIColor clearColor];
    mobileLabel.text = @"手机号";
    mobileLabel.font = [UIFont systemFontOfSize:16.0];
    [self.scrollView addSubview:mobileLabel];
    [mobileLabel release];
    
    UITextField *mobileField = [[UITextField alloc] initWithFrame:CGRectMake(40.0, 70.0, 240.0, 30.0)];
    mobileField.borderStyle = UITextBorderStyleRoundedRect;
    mobileField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    mobileField.returnKeyType = UIReturnKeyNext;
    mobileField.placeholder = @"点击输入手机号码";
    mobileField.font = [UIFont systemFontOfSize:15.0];
    mobileField.delegate = self;
    self.mobileField = mobileField;
    [self.scrollView addSubview:mobileField];
    [mobileField release];
    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 110.0, 240.0, 20.0)];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.text = @"用户名（3－10位英文或数字）";
    userNameLabel.font = [UIFont systemFontOfSize:16.0];
    [self.scrollView addSubview:userNameLabel];
    [userNameLabel release];
    
    UITextField *userNameField = [[UITextField alloc] initWithFrame:CGRectMake(40.0, 140.0, 240.0, 30.0)];
    userNameField.borderStyle = UITextBorderStyleRoundedRect;
    userNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userNameField.keyboardType = UIKeyboardTypeAlphabet;
    userNameField.returnKeyType = UIReturnKeyNext;
    userNameField.placeholder = @"点击输入用户名";
    userNameField.font = [UIFont systemFontOfSize:15.0];
    userNameField.delegate = self;
    self.userNameField = userNameField;
    [self.scrollView addSubview:userNameField];
    [userNameField release];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 180.0, 240.0, 20.0)];
    passwordLabel.backgroundColor = [UIColor clearColor];
    passwordLabel.text = @"输入密码（3-10位英文或数字）";
    passwordLabel.font = [UIFont systemFontOfSize:16.0];
    [self.scrollView addSubview:passwordLabel];
    [passwordLabel release];
    
    UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(40.0, 210.0, 240.0, 30.0)];
    passwordField.borderStyle = UITextBorderStyleRoundedRect;
    passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordField.keyboardType = UIKeyboardTypeAlphabet;
    passwordField.returnKeyType = UIReturnKeyNext;
    passwordField.secureTextEntry = YES;
    passwordField.placeholder = @"点击输入密码";
    passwordField.font = [UIFont systemFontOfSize:15.0];
    passwordField.delegate = self;
    self.passwordField = passwordField;
    [self.scrollView addSubview:passwordField];
    [passwordField release];
    
    UILabel *rePasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 250.0, 240.0, 20.0)];
    rePasswordLabel.backgroundColor = [UIColor clearColor];
    rePasswordLabel.text = @"确认密码（3-10位英文或数字）";
    rePasswordLabel.font = [UIFont systemFontOfSize:16.0];
    [self.scrollView addSubview:rePasswordLabel];
    [rePasswordLabel release];
    
    UITextField *rePasswordField = [[UITextField alloc] initWithFrame:CGRectMake(40.0, 280.0, 240.0, 30.0)];
    rePasswordField.borderStyle = UITextBorderStyleRoundedRect;
    rePasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    rePasswordField.keyboardType = UIKeyboardTypeAlphabet;
    rePasswordField.returnKeyType = UIReturnKeyDone;
    rePasswordField.secureTextEntry = YES;
    rePasswordField.placeholder = @"点击输入密码";
    rePasswordField.font = [UIFont systemFontOfSize:15.0];
    rePasswordField.delegate = self;
    self.rePasswordField = rePasswordField;
    [self.scrollView addSubview:rePasswordField];
    [rePasswordField release];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.frame = CGRectMake(120.0, 320.0, 80.0, 30.0);
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:submitButton];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidesKeyboard)];
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];
    
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

//- (void)goBack
//{
////    self.downloader.delegate = nil;
//
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)hidesKeyboard
{
    [self.mobileField resignFirstResponder];
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.rePasswordField resignFirstResponder];
    
    [self.scrollView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.passwordField || textField == self.rePasswordField) {
        [self.scrollView setContentInset:UIEdgeInsetsMake(-210.0, 0.0, 0.0, 0.0)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        if (textField == self.mobileField) {
            [self.userNameField becomeFirstResponder];
        }
        else if (textField == self.userNameField) {
            [self.passwordField becomeFirstResponder];
        }
        else if (textField == self.passwordField) {
            [self.rePasswordField becomeFirstResponder];
        }
    }
    if (textField.returnKeyType == UIReturnKeyDone) {
        if ([self.passwordField.text isEqualToString:self.rePasswordField.text])
        {
            [textField resignFirstResponder];
            [self.scrollView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
            [self sendRequest];
        }
        else {
            [self reset];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入密码不同，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
        }
    }
    return YES;
}


-(void)reset
{
    self.mobileField.text = nil;
    [self.scrollView addSubview:self.mobileField];
    self.userNameField.text = nil;
    [self.scrollView addSubview:self.userNameField];
    self.passwordField.text = nil;
    [self.scrollView addSubview:self.passwordField];
    self.rePasswordField.text = nil;
    [self.scrollView addSubview:self.rePasswordField];
    [self hidesKeyboard];
}

//- (BOOL)checkInput
//{
//    NSString *emailRegex = @"^[\w-]+(/.[/w-]+)*@[/w-]+(/.[/w-]+)+$";
//    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"%@", emailRegex];
//    
//    NSString *mobileRegex = @"^1[3|4|5|8][0-9]/d{4,8}$";
//    NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"%@", mobileRegex];
//    
//    NSString *phoneRegex = @"^(([0/+]/d{2,3}-)?(0/d{2,3})-)?(/d{7,8})(-(/d{3,}))?$";
//    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"%@", phoneRegex];
//    
//    NSString *postcodeRegex = @"^[1-9][0-9]{5}$";
//    NSPredicate *postcodePredicate = [NSPredicate predicateWithFormat:@"%@", postcodeRegex];
    
//    NSError *error = nil;
//    
//    NSRegularExpression *detector = [NSRegularExpression regularExpressionWithPattern:@"^1[3,5]{1}[0-9]{1}[0-9]{8}$" options:0 error:&error];
//    if (self.mobileField.text == nil) {
//        self.mobileField.text = @"";
//    }
//    NSArray *links = [detector matchesInString:self.mobileField.text options:0 range:NSMakeRange(0, self.mobileField.text.length)];
//
//    NSError *passwordError = nil;
//    NSRegularExpression *passwordDetector = [NSRegularExpression regularExpressionWithPattern:@"^([0-9]|[A-F])+$" options:0 error:&passwordError];
//    if (self.passwordField.text == nil) {
//        self.passwordField.text = @"";
//    }
//    NSArray *passwordLinks = [passwordDetector matchesInString:self.passwordField.text options:0 range:NSMakeRange(0, self.passwordField.text.length)];
    
//    if (self.userNameField.text.length<3){
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"用户名小于3位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//        [alertView release];
//        [self.userNameField becomeFirstResponder];
//        return NO;
//    }
//    else if (passwordLinks.count == 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"密码输入错误(数字或大写字母A-F)" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//        [alertView release];
//        [self.passwordField becomeFirstResponder];
//        return NO;
//    }
//    else if (links.count == 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"手机号输入不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//        [alertView release];
//        [self.mobileField becomeFirstResponder];
//        return NO;
//    }
//    return YES;
//}

- (void)submit
{
    if ([self.passwordField.text isEqualToString:self.rePasswordField.text])
    {
        [self hidesKeyboard];
        [self sendRequest];
    }
    else {
        [self reset];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入密码不同，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }
}

- (void)sendRequest
{
    if (!isRequesting) {
        isRequesting = YES;
        if (self.mobileField == nil) {
            self.mobileField.text = @"";
        }
        if (self.userNameField.text == nil) {
            self.userNameField.text = @"";
        }
        if (self.passwordField.text == nil) {
            self.passwordField.text = @"";
        }
        if (self.rePasswordField.text == nil) {
            self.rePasswordField.text = @"";
        }
        
        NSString *fullpath = [[NSBundle mainBundle] pathForResource:@"request-register" ofType:@"xml"];
        NSString *requestString = [[[[NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"$_USERNAME" withString:self.userNameField.text] stringByReplacingOccurrencesOfString:@"$_USERPASSWORD" withString:self.passwordField.text] stringByReplacingOccurrencesOfString:@"$_MOBILENUM" withString:self.mobileField.text];
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
//    [self finishDownload];
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
    NSArray *messageNodes = [document nodesForXPath:@"//root//rtn//rms" error:nil];
    GDataXMLElement *messageNode = [messageNodes objectAtIndex:0];
    NSString *responseMessage = [messageNode stringValue];
    [document release];
    
    if ([responseCd isEqualToString:@"00"]) {
        NSString *userInfo = [[[@"用户名：" stringByAppendingString:self.userNameField.text] stringByAppendingString:@"  密码："] stringByAppendingString:self.self.passwordField.text];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册成功！" message:userInfo delegate:self cancelButtonTitle:@"点击这里登录" otherButtonTitles:nil];
        self.successView = alertView;
        [alertView show];
        [alertView release];
    }
    else {
        [self.mobileField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册失败！" message:responseMessage delegate:nil cancelButtonTitle:@"点击这里返回" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    isRequesting = NO;
    
    //dismiss wait view
    [self.hud hide:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.successView)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
