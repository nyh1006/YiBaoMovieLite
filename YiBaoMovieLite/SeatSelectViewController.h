//
//  SeatSelectViewController.h
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-17.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoItem.h"
#import "DownLoadController.h"
#import <QuartzCore/QuartzCore.h>

@interface SeatSelectViewController : UIViewController<ResponseReceived,UIScrollViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
@property (retain, nonatomic) NSString *backButtonTitle;
@property (retain,nonatomic) InfoItem *infoItem;
@end
