//
//  ResetPwdViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 13-1-7.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import "ResetPwdViewController.h"
#import "UserItem.h"
#import "MovieConstants.h"
#import "GDataXMLNode.h"
#import "MBProgressHUD.h"

@interface ResetPwdViewController ()
@property (retain, nonatomic) UIScrollView *scrollView;
@property (retain, nonatomic) UITextField *oldPasswordField;
@property (retain, nonatomic) UITextField *passwordField;
@property (retain, nonatomic) UITextField *rePasswordField;
@property (retain, nonatomic) MBProgressHUD *hud;
@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) UIAlertView *successView;
@end

@implementation ResetPwdViewController
{
    BOOL isRequesting;
}
@synthesize backButtonTitle = _backButtonTitle;
@synthesize scrollView = _scrollView;
@synthesize oldPasswordField = _oldPasswordField;
@synthesize passwordField = _passwordField;
@synthesize rePasswordField = _rePasswordField;
@synthesize hud = _hud;
@synthesize responseData = _responseData;
@synthesize successView = _successView;

- (void)dealloc
{
    [_backButtonTitle release];
    [_scrollView release];
    [_oldPasswordField release];
    [_passwordField release];
    [_rePasswordField release];
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
    imageView.frame = CGRectMake(0.0, 0.0, 320.0, 367.0);
    [self.view addSubview:imageView];
    [imageView release];
    
    self.navigationItem.title = @"修改密码";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
//    UIButton *backButton = [UIButton buttonWithType:101];
//    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:self.backButtonTitle forState:UIControlStateNormal];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backItem;
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
//    self.navigationItem.leftBarButtonItem = backItem;
//    [backItem release];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0)];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    [scrollView release];
    
    UILabel *instructLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 20.0, 240.0, 20.0)];
    instructLabel.backgroundColor = [UIColor clearColor];
    instructLabel.text = @"请填写以下用户信息：";
    instructLabel.font = [UIFont systemFontOfSize:18.0];
    instructLabel.textColor = [UIColor redColor];
    [self.scrollView addSubview:instructLabel];
    [instructLabel release];
    
    UILabel *oldPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 60.0, 240.0, 20.0)];
    oldPasswordLabel.backgroundColor = [UIColor clearColor];
    oldPasswordLabel.text = @"旧密码（区分大小写）";
    oldPasswordLabel.font = [UIFont systemFontOfSize:16.0];
    [self.scrollView addSubview:oldPasswordLabel];
    [oldPasswordLabel release];
    
    UITextField *oldPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(40.0, 90.0, 240.0, 30.0)];
    oldPasswordField.borderStyle = UITextBorderStyleRoundedRect;
    oldPasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    oldPasswordField.keyboardType = UIKeyboardTypeAlphabet;
    oldPasswordField.returnKeyType = UIReturnKeyNext;
    oldPasswordField.secureTextEntry = YES;
    oldPasswordField.placeholder = @"点击输入旧密码";
    oldPasswordField.font = [UIFont systemFontOfSize:15.0];
    oldPasswordField.delegate = self;
    self.oldPasswordField = oldPasswordField;
    [self.scrollView addSubview:oldPasswordField];
    [oldPasswordField release];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 140.0, 240.0, 20.0)];
    passwordLabel.backgroundColor = [UIColor clearColor];
    passwordLabel.text = @"新密码（区分大小写）";
    passwordLabel.font = [UIFont systemFontOfSize:16.0];
    [self.scrollView addSubview:passwordLabel];
    [passwordLabel release];
    
    UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(40.0, 170.0, 240.0, 30.0)];
    passwordField.borderStyle = UITextBorderStyleRoundedRect;
    passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordField.keyboardType = UIKeyboardTypeAlphabet;
    passwordField.returnKeyType = UIReturnKeyNext;
    passwordField.secureTextEntry = YES;
    passwordField.placeholder = @"点击输入新密码";
    passwordField.font = [UIFont systemFontOfSize:15.0];
    passwordField.delegate = self;
    self.passwordField = passwordField;
    [self.scrollView addSubview:passwordField];
    [passwordField release];
    
    UILabel *rePasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 220.0, 240.0, 20.0)];
    rePasswordLabel.backgroundColor = [UIColor clearColor];
    rePasswordLabel.text = @"确认新密码（区分大小写）";
    rePasswordLabel.font = [UIFont systemFontOfSize:16.0];
    [self.scrollView addSubview:rePasswordLabel];
    [rePasswordLabel release];
    
    UITextField *rePasswordField = [[UITextField alloc] initWithFrame:CGRectMake(40.0, 250.0, 240.0, 30.0)];
    rePasswordField.borderStyle = UITextBorderStyleRoundedRect;
    rePasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    rePasswordField.keyboardType = UIKeyboardTypeAlphabet;
    rePasswordField.returnKeyType = UIReturnKeyDone;
    rePasswordField.secureTextEntry = YES;
    rePasswordField.placeholder = @"点击输入新密码";
    rePasswordField.font = [UIFont systemFontOfSize:15.0];
    rePasswordField.delegate = self;
    self.rePasswordField = rePasswordField;
    [self.scrollView addSubview:rePasswordField];
    [rePasswordField release];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.frame = CGRectMake(120.0, 300.0, 80.0, 30.0);
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

- (void)hidesKeyboard
{
    [self.oldPasswordField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.rePasswordField resignFirstResponder];
    
    [self.scrollView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.rePasswordField) {
        [self.scrollView setContentInset:UIEdgeInsetsMake(-140.0, 0.0, 0.0, 0.0)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        if (textField == self.oldPasswordField) {
            [self.passwordField becomeFirstResponder];
        }
        else if (textField == self.passwordField) {
            [self.rePasswordField becomeFirstResponder];
        }
    }
    if (textField.returnKeyType == UIReturnKeyDone) {
        UserItem *userItem = [UserItem sharedUser];
        if (userItem) {
            if ([self.passwordField.text isEqualToString:self.rePasswordField.text])
            {
                [textField resignFirstResponder];
                [self.scrollView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
                [self sendRequest];
            }
            else {
                [self reset];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入新密码不同，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
    self.oldPasswordField.text = nil;
    [self.scrollView addSubview:self.oldPasswordField];
    self.passwordField.text = nil;
    [self.scrollView addSubview:self.passwordField];
    self.rePasswordField.text = nil;
    [self.scrollView addSubview:self.rePasswordField];
    
    [self hidesKeyboard];
}

- (void)submit
{
    UserItem *userItem = [UserItem sharedUser];
    if (userItem) {
        if ([self.passwordField.text isEqualToString:self.rePasswordField.text])
        {
            [self hidesKeyboard];
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
        UserItem *userItem = [UserItem sharedUser];
        if (self.oldPasswordField.text == nil) {
            self.oldPasswordField.text = @"";
        }
        if (self.passwordField.text == nil) {
            self.passwordField.text = @"";
        }
        NSString *fullpath = [[NSBundle mainBundle] pathForResource:@"request-resetpwd" ofType:@"xml"];
        NSString *requestString = [[[[[NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"$_USERNAME" withString:userItem.userName] stringByReplacingOccurrencesOfString:@"$_OLDPASSWORD" withString:self.oldPasswordField.text] stringByReplacingOccurrencesOfString:@"$_NEWPASSWORD" withString:self.passwordField.text] stringByReplacingOccurrencesOfString:@"$_MOBILENUM" withString:userItem.mobileNum];
        NSLog(@"%@,%@",self.oldPasswordField.text,self.passwordField.text);
        NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kMovieAPILocation]];
        request.HTTPBody = requestData;
        request.HTTPMethod = @"POST";
        
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
    if ([responseCd isEqualToString:@"00"]) {
        NSString *message = [@"您的新手机号为" stringByAppendingString:self.passwordField.text];
        NSString *responseMessage = [[[[document nodesForXPath:@"//root//rtn//rms" error:nil] lastObject] stringValue] stringByAppendingString:message];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:responseMessage delegate:self cancelButtonTitle:@"返回用户页" otherButtonTitles:nil];
        self.successView = alertView;
        [alertView show];
        [alertView release];
    }
    else {
        NSString *responseMessage = [[[document nodesForXPath:@"//root//rtn//rms" error:nil] lastObject] stringValue];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:responseMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    [document release];
    
    isRequesting = NO;
    //dismiss wait view
    [self.hud hide:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.successView) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
