//
//  LoginViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-28.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomTableViewCell.h"
#import "MovieConstants.h"
#import "GDataXMLNode.h"
#import "RegisterViewController.h"
#import "UserItem.h"
#import "FindPwdViewController.h"
#import "AppDelegate.h"
#import "UserInfoViewController.h"
#import "UserItem.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()
@property (retain, nonatomic) UITableView *tableView;
@property (retain, nonatomic) UITextField *userNameField;
@property (retain, nonatomic) UITextField *passwordField;
@property (retain, nonatomic) DownLoadController *downloader;
@property (retain, nonatomic) MBProgressHUD *hud;
@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSString *responseMessage;
@property (retain, nonatomic) UIAlertView *successView;
@end

@implementation LoginViewController
{
    BOOL isRequesting;
}
@synthesize tableView = _tableView;
@synthesize userNameField = _userNameField;
@synthesize passwordField = _passwordField;
@synthesize downloader = _downloader;
@synthesize hud = _hud;
@synthesize responseData = _responseData;
@synthesize responseMessage = _responseMessage;
@synthesize successView = _successView;

- (void)dealloc
{
    [_tableView release];
    [_userNameField release];
    [_passwordField release];
    [_downloader release];
    [_hud release];
    [_responseData release];
    [_responseMessage release];
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
    self.navigationItem.title = @"登录";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    self.view.backgroundColor = [UIColor blackColor];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(30.0, 0.0, 260.0, [UIScreen mainScreen].applicationFrame.size.height-44.0-49.0) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView release];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor blackColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 260.0, 130.0)];
    headerView.backgroundColor = [UIColor blackColor];
    self.tableView.tableHeaderView = headerView;
    [headerView release];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user.ico"]];
    imageView.frame = CGRectMake(100.0, 40.0, 60.0, 60.0);
    [self.tableView.tableHeaderView addSubview:imageView];
    [imageView release];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 260.0, [UIScreen mainScreen].applicationFrame.size.height-44.0-49.0-130.0-110.0)];
    footerView.backgroundColor = [UIColor blackColor];
    self.tableView.tableFooterView = footerView;
    [footerView release];
    
//    UIImageView *footerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"footer.jpg"]];
//    footerImageView.frame = CGRectMake(0.0, 0.0, 320.0, [UIScreen mainScreen].applicationFrame.size.height-44.0-49.0-150.0-110.0);
//    [footerView addSubview:footerImageView];
//    [footerImageView release];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(10.0, 30.0, 100.0, 30.0);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:loginButton];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    registerButton.frame = CGRectMake(150.0, 30.0, 100.0, 30.0);
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(register) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:registerButton];
    
    UIButton *findPwdButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    findPwdButton.frame = CGRectMake(10.0, 70.0, 130.0, 30.0);
    [findPwdButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [findPwdButton addTarget:self action:@selector(findPwd) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:findPwdButton];
    
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

- (void)register
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    registerVC.backButtonTitle = self.navigationItem.title;
    [self.navigationController pushViewController:registerVC animated:YES];
    [registerVC release];
}

- (void)hidesKeyboard
{
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.tableView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CustomCell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    if (indexPath.section == 0) {
        cell.titleLabel.text = @"用户名";
        cell.titleLabel.textColor = [UIColor grayColor];
        cell.contentField.placeholder = @"请输入用户名";
        cell.contentField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        cell.contentField.returnKeyType = UIReturnKeyNext;
        cell.contentField.delegate = self;
        self.userNameField = cell.contentField;
    }
    else if (indexPath.section == 1){
        cell.titleLabel.text = @"密码";
        cell.titleLabel.textColor = [UIColor grayColor];
        cell.contentField.placeholder = @"请输入密码";
        cell.contentField.returnKeyType = UIReturnKeyDone;
        cell.contentField.secureTextEntry = YES;
        cell.contentField.delegate = self;
        self.passwordField = cell.contentField;
    }
    
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.tableView setContentInset:UIEdgeInsetsMake(-56.0, 0.0, 0.0, 0.0)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        [self.passwordField becomeFirstResponder];
    }
    else if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
        [self.tableView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        [self sendRequest];
    }
    return YES;
}

//- (BOOL)checkInput
//{
//    NSError *passwordError = nil;
//    NSRegularExpression *passwordDetector = [NSRegularExpression regularExpressionWithPattern:@"^([0-9]|[A-F])+$" options:0 error:&passwordError];
//    if (self.passwordField.text == nil) {
//        self.passwordField.text = @"";
//    }
//    NSArray *passwordLinks = [passwordDetector matchesInString:self.passwordField.text options:0 range:NSMakeRange(0, self.passwordField.text.length)];
//    
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
//    return YES;
//}

//- (void)changePwd
//{
//    UserItem *userItem = [UserItem sharedUser];
//    //判断用户名是否存在，如果不存在，即用户未登录
//    if (!userItem.userName) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//        [alertView release];
//    }
//    else {
//        FindPwdViewController *resetPwdVC = [[FindPwdViewController alloc] init];
//        [self.navigationController pushViewController:resetPwdVC animated:YES];
//        [resetPwdVC release];
//    }
//}

- (void)findPwd
{
    FindPwdViewController *findPwdVC = [[FindPwdViewController alloc] init];
    findPwdVC.backButtonTitle = self.navigationItem.title;
    [self.navigationController pushViewController:findPwdVC animated:YES];
    [findPwdVC release];
}

- (void)login
{
    [self hidesKeyboard];
    [self.tableView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    [self sendRequest];
}

- (void)sendRequest
{
    if (!isRequesting) {
        isRequesting = YES;
        if (self.userNameField.text == nil) {
            self.userNameField.text = @"";
        }
        if (self.passwordField.text == nil) {
            self.passwordField.text = @"";
        }
        NSString *fullpath = [[NSBundle mainBundle] pathForResource:@"request-login" ofType:@"xml"];
        NSString *requestString = [NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil];
        requestString = [[requestString stringByReplacingOccurrencesOfString:@"$_USERNAME" withString:self.userNameField.text] stringByReplacingOccurrencesOfString:@"$_USERPASSWORD" withString:self.passwordField.text];
        NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kMovieAPILocation]];
        request.HTTPMethod = @"POST";
        request.HTTPBody = requestData;
        
        DownLoadController *downloader = [[DownLoadController alloc] initWithRequest:request];
        downloader.delegate = self;
        self.downloader = downloader;
        [downloader beginAsyncRequest];
        [downloader release];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"请求中...";
        self.hud = hud;
    }
}

- (void)responseReceived:(NSMutableData *)responseData
{
    self.responseData = responseData;
    [self finishDownLoad];
}

- (void)refreshFail:(NSURLConnection *)connection
{
    isRequesting = NO;
    [self.hud hide:YES];
}

- (void)reset
{     
    self.userNameField.text = nil;
    self.passwordField.text = nil;
    [self.tableView reloadData];
}

- (void)finishDownLoad
{
    NSLog(@"%@",[[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] autorelease]);
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.responseData options:0 error:nil];
    NSArray *messageNodes = [document nodesForXPath:@"//root//rtn//rms" error:nil];
    GDataXMLElement *messageNode = [messageNodes objectAtIndex:0];
    self.responseMessage = [messageNode stringValue];
    NSArray *userNodes = [document nodesForXPath:@"//root//body" error:nil];
    if (userNodes && userNodes.count>0) {
        GDataXMLElement *userNode = [userNodes objectAtIndex:0];
        UserItem *userItem = [[UserItem alloc] init];
        userItem.userName = self.userNameField.text;
        userItem.password = self.passwordField.text;
        userItem.mobileNum = [[[userNode elementsForName:@"mob_num"] objectAtIndex:0] stringValue];
        userItem.userIndex = [[[userNode elementsForName:@"userindex"] objectAtIndex:0] stringValue];
        if ([[userNode elementsForName:@"keyval"] objectAtIndex:0]) {
            if (![[[[userNode elementsForName:@"keyval"] objectAtIndex:0] stringValue] isEqualToString:@""]) {
                userItem.keyVal = [[[userNode elementsForName:@"keyval"] objectAtIndex:0] stringValue];
            }
        }
        userItem.paytype = [[[userNode elementsForName:@"paytype"] objectAtIndex:0] stringValue];
        [UserItem setSharedUser:userItem];
        [userItem release];
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:userInfoVC animated:YES];
        [userInfoVC release];
        [self reset];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:self.responseMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        [self reset];
    }
    [document release];
    
    isRequesting = NO;
    
    //dismiss wait view
    [self.hud hide:YES];
}

@end
