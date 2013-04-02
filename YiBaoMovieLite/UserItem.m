//
//  UserItem.m
//  YiBaoMovieLite
//
//  Created by MaKai on 13-1-4.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import "UserItem.h"

@implementation UserItem
@synthesize userName = _userName;
@synthesize password = _password;
@synthesize mobileNum = _mobileNum;
@synthesize userIndex = _userIndex;
@synthesize keyVal = _keyVal;
@synthesize paytype = _paytype;
@synthesize phoneNum = _phoneNum;
@synthesize address = _address;
@synthesize postCode = _postCode;
@synthesize fullName = _fullName;
@synthesize email = _email;
@synthesize idCard = _idCard;

- (void)dealloc
{
    [_userName release];
    [_password release];
    [_mobileNum release];
    [_userIndex release];
    [_keyVal release];
    [_paytype release];
    [_phoneNum release];
    [_address release];
    [_postCode release];
    [_fullName release];
    [_email release];
    [_idCard release];
    
    [super dealloc];
}


static UserItem *sharedUser = nil;

+ (void)setSharedUser:(UserItem *)userItem
{
    [sharedUser release];
    sharedUser = [userItem retain];
}

+ (UserItem *)sharedUser
{
    return sharedUser;
}

//static BOOL isQuit = NO;
//+ (BOOL)isQuit:(BOOL)isSet
//{
//    if (isSet) {
//        if (!isQuit) {
//            isQuit = YES;
//        }
//        else {
//            isQuit = NO;
//        }
//    }
//    return isQuit;
//}

@end
