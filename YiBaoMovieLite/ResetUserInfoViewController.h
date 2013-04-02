//
//  ResetUserInfoViewController.h
//  YiBaoMovieLite
//
//  Created by MaKai on 13-1-8.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownLoadController.h"

@interface ResetUserInfoViewController : UIViewController<ResponseReceived,UITextFieldDelegate,UIAlertViewDelegate,NSURLConnectionDataDelegate>
@property (retain, nonatomic) NSString *backButtonTitle;
@end
