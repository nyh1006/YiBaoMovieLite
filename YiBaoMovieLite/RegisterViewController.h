//
//  RegisterViewController.h
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-28.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownLoadController.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,NSURLConnectionDataDelegate>
@property (retain, nonatomic) NSString *backButtonTitle;
@end
