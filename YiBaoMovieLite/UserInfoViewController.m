//
//  UserInfoViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 13-1-7.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import "UserInfoViewController.h"
#import "CustomTableViewCell.h"
#import "UserItem.h"
#import "ResetUserInfoViewController.h"
#import "ResetPwdViewController.h"
#import "MovieConstants.h"
#import "GDataXMLNode.h"
#import "MBProgressHUD.h"

@interface UserInfoViewController ()
@property (retain, nonatomic) UILabel *statusLabel;
@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UILabel *contentLabel;
@property (retain, nonatomic) QuitController *quitController;
@property (retain, nonatomic) MBProgressHUD *hud;
@end

@implementation UserInfoViewController
{
    BOOL isRequesting;
}
@synthesize statusLabel = _statusLabel;
@synthesize titleLabel = _titleLabel;
@synthesize contentLabel = _contentLabel;
@synthesize quitController = _quitController;
@synthesize hud = _hud;

- (void)dealloc
{
    [_statusLabel release];
    [_titleLabel release];
    [_contentLabel release];
    [_quitController release];
    [_hud release];
    
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

    self.navigationItem.title = @"当前用户";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.hidesBackButton = YES;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor blackColor];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    UserItem *userItem = [UserItem sharedUser];
    if (userItem) {
        return 2;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    UserItem *userItem = [UserItem sharedUser];
    if (userItem) {
        switch (section) {
            case 0:
                return 1;
                break;
            default:
                return 3;
                break;
        }
    }
    else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserItem *userItem = [UserItem sharedUser];
    if (userItem) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else {
        return [[UIScreen mainScreen] applicationFrame].size.height - 115.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserItem *userItem = [UserItem sharedUser];
    if (userItem) {
        UITableViewCell *cell;
        switch (indexPath.section)
        {
            case 0:
            {
                static NSString *CellIdentifier = @"SpecificCell";
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.backgroundColor = [UIColor darkGrayColor];
                if (!self.titleLabel) {
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 7.0, 100.0, 30.0)];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    titleLabel.text = @"用户名";
                    titleLabel.font = [UIFont systemFontOfSize:20.0];
                    titleLabel.textAlignment = NSTextAlignmentRight;
                    titleLabel.textColor = [UIColor whiteColor];
                    self.titleLabel = titleLabel;
                    [cell.contentView addSubview:titleLabel];
                    [titleLabel release];
                }
                if (!self.contentLabel) {
                    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 7.0, 170.0, 30.0)];
                    contentLabel.backgroundColor = [UIColor clearColor];
                    UserItem *userItem = [UserItem sharedUser];
                    if (userItem.userName) {
                        contentLabel.text = userItem.userName;
                    }
                    contentLabel.font = [UIFont systemFontOfSize:18.0];
                    contentLabel.textColor = [UIColor blueColor];
                    contentLabel.textAlignment = NSTextAlignmentCenter;
                    self.contentLabel = contentLabel;
                    [cell.contentView addSubview:contentLabel];
                    [contentLabel release];
                }
                else {
                    UserItem *userItem = [UserItem sharedUser];
                    if (userItem.userName) {
                        self.contentLabel.text = userItem.userName;
                    }
                    [cell.contentView addSubview:self.contentLabel];
                }
                break;
            }
            default:
            {
                static NSString *CellIdentifier = @"NormalCell";
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                }
                cell.backgroundColor = [UIColor grayColor];
                switch (indexPath.row)
                {
                    case 0:
                    {
                        cell.textLabel.text = @"修改用户信息";
                        cell.textLabel.font = [UIFont systemFontOfSize:20.0];
                        cell.textLabel.textAlignment = NSTextAlignmentCenter;
                        cell.textLabel.textColor = [UIColor whiteColor];
                        break;
                    }
                    case 1:
                    {
                        cell.textLabel.text = @"修改密码";
                        cell.textLabel.font = [UIFont systemFontOfSize:20.0];
                        cell.textLabel.textAlignment = NSTextAlignmentCenter;
                        cell.textLabel.textColor = [UIColor whiteColor];
                        break;
                    }
                    default:
                    {
                        cell.textLabel.text = @"退出登录";
                        cell.textLabel.font = [UIFont systemFontOfSize:20.0];
                        cell.textLabel.textAlignment = NSTextAlignmentCenter;
                        cell.textLabel.textColor = [UIColor whiteColor];
                        break;
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
        }
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"NormalCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.textLabel.text = @"请先登录";
        cell.textLabel.font = [UIFont systemFontOfSize:20.0];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserItem *useItem = [UserItem sharedUser];
    if (useItem) {
        if (indexPath.section == 1) {
            switch (indexPath.row) {
                case 0:
                {
                    ResetUserInfoViewController *resetUserInfoVC = [[ResetUserInfoViewController alloc] init];
                    resetUserInfoVC.backButtonTitle = self.navigationItem.title;
                    [self.navigationController pushViewController:resetUserInfoVC animated:YES];
                    [resetUserInfoVC release];
                    break;
                }
                case 1:
                {
                    ResetPwdViewController *resetPwdVC = [[ResetPwdViewController alloc] init];
                    resetPwdVC.backButtonTitle = self.navigationItem.title;
                    [self.navigationController pushViewController:resetPwdVC animated:YES];
                    [resetPwdVC release];
                    break;
                }
                default:
                {
                    UserItem *userItem = [UserItem sharedUser];
                    if (userItem) {
                        [self quit];
                    }
                    //                        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
                    break;
                }
            }
        }
    }
}

- (void)quit
{
    if (!isRequesting) {
        isRequesting = YES;
        QuitController *quitController = [[QuitController alloc] init];
        quitController.delegate = self;
        self.quitController = quitController;
        [quitController requestQuit];
        [quitController release];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"请求中...";
        self.hud = hud;
    }
}

- (void)responseFail
{
    isRequesting = NO;
    [self.hud hide:YES];
}

- (void)responseQuit
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    isRequesting = NO;
    [self.hud hide:YES];
}

@end
