//
//  ResetUserInfoViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 13-1-8.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import "ResetUserInfoViewController.h"
#import "UserItem.h"
#import "MovieConstants.h"
#import "GDataXMLNode.h"
#import "MovieConstants.h"
#import "UserItem.h"
#import "MBProgressHUD.h"

@interface ResetUserInfoViewController ()
@property (retain, nonatomic) DownLoadController *downloader;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSURLConnection *resetConnection;
@property (retain, nonatomic) MBProgressHUD *hud;
@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) UIScrollView *scrollView;
@property (retain, nonatomic) UITextField *userNameField;
@property (retain, nonatomic) UITextField *mobileField;
@property (retain, nonatomic) UITextField *passwordField;
@property (retain, nonatomic) UITextField *rePasswordField;
@property (retain, nonatomic) UITextField *phoneNumField;
@property (retain, nonatomic) UITextField *emailField;
@property (retain, nonatomic) UITextField *addressField;
@property (retain, nonatomic) UITextField *postCodeField;
@property (retain, nonatomic) UITextField *idCardField;

@end

@implementation ResetUserInfoViewController
{
    BOOL isRequesting;
}
@synthesize backButtonTitle = _backButtonTitle;
@synthesize downloader = _downloader;
@synthesize connection = _connection;
@synthesize resetConnection = _resetConnection;
@synthesize hud = _hud;
@synthesize responseData = _responseData;
@synthesize scrollView = _scrollView;
@synthesize userNameField = _userNameField;
@synthesize mobileField = _mobileField;
@synthesize passwordField = _passwordField;
@synthesize rePasswordField = _rePasswordField;
@synthesize phoneNumField = _phoneNumField;
@synthesize emailField = _emailField;
@synthesize addressField = _addressField;
@synthesize postCodeField = _postCodeField;
@synthesize idCardField = _idCardField;

- (void)dealloc
{
    [_backButtonTitle release];
    [_downloader release];
    [_connection release];
    [_resetConnection release];
    [_hud release];
    [_responseData release];
    [_scrollView release];
    [_userNameField release];
    [_mobileField release];
    [_passwordField release];
    [_rePasswordField release];
    [_phoneNumField release];
    [_emailField release];
    [_addressField release];
    [_postCodeField release];
    [_idCardField release];
    
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
    self.navigationItem.title = @"修改用户信息";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:101];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:self.backButtonTitle forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register.jpg"]];
    imageView.frame = CGRectMake(0.0, 0.0, 320.0, 367.0);
    [self.view addSubview:imageView];
    [imageView release];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0)];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    [scrollView release];
    
    isRequesting = NO;

    NSString *fullpath = [[NSBundle mainBundle] pathForResource:@"request-loaduserinfo" ofType:@"xml"];
    UserItem *userItem = [UserItem sharedUser];
    NSString *requestString = [[[[NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"$_USERNAME" withString:userItem.userName] stringByReplacingOccurrencesOfString:@"$_PASSWORD" withString:userItem.password] stringByReplacingOccurrencesOfString:@"$_MOBILENUM" withString:userItem.mobileNum];
    NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kMovieAPILocation]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = requestData;
    
    self.downloader.delegate = nil;
    DownLoadController *downloader = [[DownLoadController alloc] initWithRequest:request];
    self.connection = [NSURLConnection connectionWithRequest:request delegate:downloader];
    downloader.connection = self.connection;
    downloader.delegate = self;
    self.downloader = downloader;
    [downloader beginAsyncRequest];
    [downloader release];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"刷新中...";
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

- (void)responseConnection:(NSURLConnection *)connection Received:(NSMutableData *)responseData
{
    self.responseData = responseData;
    if (connection == self.connection) {
        [self downLoadFinish];
    }
}

- (void)refreshFail:(NSURLConnection *)connection
{
    [self.hud hide:YES];
}

- (void)downLoadFinish
{
    NSLog(@"%@",[[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] autorelease]);
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.responseData options:0 error:nil];
    
    NSString *commandId = [[[[document nodesForXPath:@"//root//head" error:nil] lastObject] attributeForName:@"cid"] stringValue];
    if ([commandId isEqualToString:@"01000005"]) {
        NSString *responseCd = [[[document nodesForXPath:@"//root//rtn//rcd" error:nil] lastObject] stringValue];
        
        NSString *responseMessage = [[[document nodesForXPath:@"//root//rtn//rms" error:nil] lastObject] stringValue];
        
        if ([responseCd isEqualToString:@"00"]) {
            UserItem *userItem = [UserItem sharedUser];
            
            UILabel *instructLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 5.0, 300.0, 20.0)];
            instructLabel.backgroundColor = [UIColor clearColor];
            instructLabel.text = @"以下为用户信息：";
            instructLabel.font = [UIFont systemFontOfSize:15.0];
            instructLabel.textColor = [UIColor redColor];
            [self.scrollView addSubview:instructLabel];
            [instructLabel release];
            
            UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 30.0, 100.0, 30.0)];
            userNameLabel.backgroundColor = [UIColor clearColor];
            userNameLabel.text = @"姓名：";
            userNameLabel.font = [UIFont systemFontOfSize:16.0];
            [self.scrollView addSubview:userNameLabel];
            [userNameLabel release];
            
            UITextField *userNameField = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 30.0, 190.0, 30.0)];
            userNameField.borderStyle = UITextBorderStyleRoundedRect;
            userNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            userNameField.keyboardType = UIKeyboardTypeAlphabet;
            userNameField.returnKeyType = UIReturnKeyNext;
            userNameField.placeholder = userItem.userName;
            userNameField.font = [UIFont systemFontOfSize:15.0];
            userNameField.delegate = self;
            self.userNameField = userNameField;
            [self.scrollView addSubview:userNameField];
            [userNameField release];
            
            UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 65.0, 100.0, 30.0)];
            passwordLabel.backgroundColor = [UIColor clearColor];
            passwordLabel.text = @"密码：";
            passwordLabel.font = [UIFont systemFontOfSize:16.0];
            [self.scrollView addSubview:passwordLabel];
            [passwordLabel release];
            
            UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 65.0, 190.0, 30.0)];
            passwordField.borderStyle = UITextBorderStyleRoundedRect;
            passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            passwordField.keyboardType = UIKeyboardTypeAlphabet;
            passwordField.returnKeyType = UIReturnKeyNext;
            passwordField.secureTextEntry = YES;
            passwordField.placeholder = userItem.password;
            passwordField.font = [UIFont systemFontOfSize:15.0];
            passwordField.delegate = self;
            self.passwordField = passwordField;
            [self.scrollView addSubview:passwordField];
            [passwordField release];
            
            UILabel *rePasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 100.0, 100.0, 30.0)];
            rePasswordLabel.backgroundColor = [UIColor clearColor];
            rePasswordLabel.text = @"确认密码：";
            rePasswordLabel.font = [UIFont systemFontOfSize:16.0];
            [self.scrollView addSubview:rePasswordLabel];
            [rePasswordLabel release];
            
            UITextField *rePasswordField = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 100.0, 190.0, 30.0)];
            rePasswordField.borderStyle = UITextBorderStyleRoundedRect;
            rePasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            rePasswordField.keyboardType = UIKeyboardTypeAlphabet;
            rePasswordField.returnKeyType = UIReturnKeyNext;
            rePasswordField.secureTextEntry = YES;
            rePasswordField.placeholder = @"点击输入密码";
            rePasswordField.font = [UIFont systemFontOfSize:15.0];
            rePasswordField.delegate = self;
            self.rePasswordField = rePasswordField;
            [self.scrollView addSubview:rePasswordField];
            [rePasswordField release];
            
            UILabel *mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 135.0, 100.0, 30.0)];
            mobileLabel.backgroundColor = [UIColor clearColor];
            mobileLabel.text = @"手机号：";
            mobileLabel.font = [UIFont systemFontOfSize:16.0];
            [self.scrollView addSubview:mobileLabel];
            [mobileLabel release];
            
            UITextField *mobileField = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 135.0, 190.0, 30.0)];
            mobileField.borderStyle = UITextBorderStyleRoundedRect;
            mobileField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            mobileField.returnKeyType = UIReturnKeyNext;
            mobileField.placeholder = userItem.mobileNum;
            mobileField.font = [UIFont systemFontOfSize:15.0];
            mobileField.delegate = self;
            self.mobileField = mobileField;
            [self.scrollView addSubview:mobileField];
            [mobileField release];
            
            UILabel *phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 170.0, 100.0, 30.0)];
            phoneNumLabel.backgroundColor = [UIColor clearColor];
            phoneNumLabel.text = @"电话：";
            phoneNumLabel.font = [UIFont systemFontOfSize:16.0];
            [self.scrollView addSubview:phoneNumLabel];
            [phoneNumLabel release];
            
            UITextField *phoneNumField = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 170.0, 190.0, 30.0)];
            phoneNumField.borderStyle = UITextBorderStyleRoundedRect;
            phoneNumField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            phoneNumField.keyboardType = UIKeyboardTypeAlphabet;
            phoneNumField.returnKeyType = UIReturnKeyNext;
            phoneNumField.placeholder = userItem.phoneNum;
            phoneNumField.font = [UIFont systemFontOfSize:15.0];
            phoneNumField.delegate = self;
            self.phoneNumField = phoneNumField;
            [self.scrollView addSubview:phoneNumField];
            [phoneNumField release];
            
            UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 205.0, 100.0, 30.0)];
            emailLabel.backgroundColor = [UIColor clearColor];
            emailLabel.text = @"邮箱：";
            emailLabel.font = [UIFont systemFontOfSize:16.0];
            [self.scrollView addSubview:emailLabel];
            [emailLabel release];
            
            UITextField *emailField = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 205.0, 190.0, 30.0)];
            emailField.borderStyle = UITextBorderStyleRoundedRect;
            emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            emailField.keyboardType = UIKeyboardTypeAlphabet;
            emailField.returnKeyType = UIReturnKeyNext;
            emailField.placeholder = userItem.email;
            emailField.font = [UIFont systemFontOfSize:15.0];
            emailField.delegate = self;
            self.emailField = emailField;
            [self.scrollView addSubview:emailField];
            [emailField release];
            
            UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 240.0, 300.0, 30.0)];
            addressLabel.backgroundColor = [UIColor clearColor];
            addressLabel.text = @"地址：";
            addressLabel.font = [UIFont systemFontOfSize:16.0];
            [self.scrollView addSubview:addressLabel];
            [addressLabel release];
            
            UITextField *addressField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 275.0, 300.0, 30.0)];
            addressField.borderStyle = UITextBorderStyleRoundedRect;
            addressField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            addressField.keyboardType = UIKeyboardTypeAlphabet;
            addressField.returnKeyType = UIReturnKeyNext;
            addressField.placeholder = userItem.address;
            addressField.font = [UIFont systemFontOfSize:15.0];
            addressField.delegate = self;
            self.addressField = addressField;
            [self.scrollView addSubview:addressField];
            [addressField release];
            
            UILabel *postCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 310.0, 100.0, 30.0)];
            postCodeLabel.backgroundColor = [UIColor clearColor];
            postCodeLabel.text = @"邮编：";
            postCodeLabel.font = [UIFont systemFontOfSize:16.0];
            [self.scrollView addSubview:postCodeLabel];
            [postCodeLabel release];
            
            UITextField *postCodeField = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 310.0, 190.0, 30.0)];
            postCodeField.borderStyle = UITextBorderStyleRoundedRect;
            postCodeField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            postCodeField.keyboardType = UIKeyboardTypeAlphabet;
            postCodeField.returnKeyType = UIReturnKeyDone;
            postCodeField.placeholder = userItem.postCode;
            postCodeField.font = [UIFont systemFontOfSize:15.0];
            postCodeField.delegate = self;
            self.postCodeField = postCodeField;
            [self.scrollView addSubview:postCodeField];
            [postCodeField release];
            
            UILabel *idCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 345.0, 100.0, 30.0)];
            idCardLabel.backgroundColor = [UIColor clearColor];
            idCardLabel.text = @"身份证号：";
            idCardLabel.font = [UIFont systemFontOfSize:16.0];
            [self.scrollView addSubview:idCardLabel];
            [idCardLabel release];
            
            UITextField *idCardField = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 345.0, 190.0, 30.0)];
            idCardField.borderStyle = UITextBorderStyleRoundedRect;
            idCardField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            idCardField.keyboardType = UIKeyboardTypeAlphabet;
            idCardField.returnKeyType = UIReturnKeyDone;
            idCardField.placeholder = userItem.idCard;
            idCardField.font = [UIFont systemFontOfSize:15.0];
            idCardField.delegate = self;
            self.idCardField = idCardField;
            [self.scrollView addSubview:idCardField];
            [idCardField release];
            
            UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            submitButton.frame = CGRectMake(120.0, 380.0, 80.0, 30.0);
            [submitButton setTitle:@"提交" forState:UIControlStateNormal];
            [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:submitButton];
            
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidesKeyboard)];
            [self.view addGestureRecognizer:recognizer];
            [recognizer release];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:responseMessage delegate:self cancelButtonTitle:@"返回用户页" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
    else if ([commandId isEqualToString:@"01000001"])
    {
        NSString *responseCd = [[[document nodesForXPath:@"//root//rtn//rcd" error:nil] lastObject] stringValue];
        
        NSString *responseMessage = [[[document nodesForXPath:@"//root//rtn//rms" error:nil] lastObject] stringValue];
        if ([responseCd isEqualToString:@"00"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:responseMessage delegate:self cancelButtonTitle:@"返回用户页" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:responseMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
    [document release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hidesKeyboard
{
    [self.mobileField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.rePasswordField resignFirstResponder];
    [self.userNameField resignFirstResponder];
    [self.phoneNumField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.addressField resignFirstResponder];
    [self.postCodeField resignFirstResponder];
    
    [self.scrollView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.addressField || textField == self.postCodeField || textField == self.idCardField) {
        [self.scrollView setContentInset:UIEdgeInsetsMake(-238.0, 0.0, 0.0, 0.0)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        if (textField == self.userNameField) {
            [self.userNameField becomeFirstResponder];
        }
        else if (textField == self.passwordField) {
            [self.rePasswordField becomeFirstResponder];
        }
        else if (textField == self.rePasswordField) {
            [self.mobileField becomeFirstResponder];
        }
        else if (textField == self.mobileField) {
            [self.phoneNumField becomeFirstResponder];
        }
        else if (textField == self.phoneNumField) {
            [self.emailField becomeFirstResponder];
        }
        else if (textField == self.emailField) {
            [self.addressField becomeFirstResponder];
        }
        else if (textField == self.addressField) {
            [self.postCodeField becomeFirstResponder];
        }
        else if (textField == self.postCodeField) {
            [self.idCardField becomeFirstResponder];
        }
    }
    if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
        [self.scrollView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        UserItem *userItem = [UserItem sharedUser];
        if (userItem) {
            if ([self.passwordField.text isEqualToString:self.rePasswordField.text])
            {
                [self sendRequest];
            }
            else {
                [self reset];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入新密码不同，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                [alertView release];
            }
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
    return YES;
}


- (void)reset
{
    [self hidesKeyboard];
    self.userNameField.text = nil;
    
    [self.scrollView addSubview:self.userNameField];
    self.passwordField.text = nil;
    [self.scrollView addSubview:self.passwordField];
    self.rePasswordField.text = nil;
    [self.scrollView addSubview:self.rePasswordField];
    self.mobileField.text = nil;
    [self.scrollView addSubview:self.mobileField];
    self.phoneNumField.text = nil;
    [self.scrollView addSubview:self.phoneNumField];
    self.emailField.text = nil;
    [self.scrollView addSubview:self.emailField];
    self.addressField.text = nil;
    [self.scrollView addSubview:self.addressField];
    self.postCodeField.text = nil;
    [self.scrollView addSubview:self.postCodeField];
    
}

- (void)submit
{
    UserItem *userItem = [UserItem sharedUser];
    if (userItem) {
        if ([self.passwordField.text isEqualToString:self.rePasswordField.text])
        {
            [self hidesKeyboard];
//            [self.scrollView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
            [self sendRequest];
        }
        else {
            [self reset];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入新密码不同，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
        }
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)sendRequest
{
    if (!isRequesting) {
        isRequesting = YES;
        NSString *fullpath = [[NSBundle mainBundle] pathForResource:@"request-resetuserinfo" ofType:@"xml"];
        NSString *requestString = [[[[[[[[[[[[NSString alloc] initWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil] autorelease]stringByReplacingOccurrencesOfString:@"$_OLDPASSWORD" withString:self.passwordField.text] stringByReplacingOccurrencesOfString:@"$_NEWPASSWORD" withString:self.rePasswordField.text] stringByReplacingOccurrencesOfString:@"$_MOBILENUM" withString:self.mobileField.text] stringByReplacingOccurrencesOfString:@"$_PHONENUM" withString:self.phoneNumField.text] stringByReplacingOccurrencesOfString:@"$_ADDRESS" withString:self.addressField.text] stringByReplacingOccurrencesOfString:@"$_POSTCODE" withString:self.postCodeField.text] stringByReplacingOccurrencesOfString:@"$_FULLNAME" withString:self.userNameField.text] stringByReplacingOccurrencesOfString:@"$_EMAIL" withString:self.emailField.text] stringByReplacingOccurrencesOfString:@"$_IDCARD" withString:self.idCardField.text];
        NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kMovieAPILocation]];
        request.HTTPMethod = @"POST";
        request.HTTPBody = requestData;
//        DownLoadController *downloader = [[DownLoadController alloc] initWithRequest:request];
//        self.resetConnection = [NSURLConnection connectionWithRequest:request delegate:self];
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
    isRequesting = NO;
    
    //dismiss wait view
    [self.hud hide:YES];
}

@end
