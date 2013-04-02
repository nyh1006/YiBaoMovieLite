//
//  ResetPwdViewController.h
//  YiBaoMovieLite
//
//  Created by MaKai on 13-1-6.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownLoadController.h"

@interface FindPwdViewController : UIViewController<UITextFieldDelegate,NSURLConnectionDataDelegate,UIAlertViewDelegate>
@property (retain, nonatomic) NSString *backButtonTitle;
@end
