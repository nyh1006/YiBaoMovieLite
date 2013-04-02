//
//  UserItem.h
//  YiBaoMovieLite
//
//  Created by MaKai on 13-1-4.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserItem : NSObject
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *password;
@property (retain, nonatomic) NSString *mobileNum;
@property (retain, nonatomic) NSString *userIndex;
@property (retain, nonatomic) NSString *keyVal;
@property (retain, nonatomic) NSString *paytype;
@property (retain, nonatomic) NSString *phoneNum;
@property (retain, nonatomic) NSString *address;
@property (retain, nonatomic) NSString *postCode;
@property (retain, nonatomic) NSString *fullName;
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *idCard;

+ (void)setSharedUser:(UserItem *)userItem;
+ (UserItem *)sharedUser;

@end
