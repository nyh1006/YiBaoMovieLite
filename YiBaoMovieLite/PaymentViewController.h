//
//  PaymentViewController.h
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-23.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoItem.h"
#import "DownLoadController.h"

@interface PaymentViewController : UIViewController<NSURLConnectionDataDelegate,UIAlertViewDelegate>
@property (retain, nonatomic) NSString *backButtonTitle;
@property (retain, nonatomic) InfoItem *infoItem;
@property (retain, nonatomic) NSMutableArray *selectedSeats;
@end
