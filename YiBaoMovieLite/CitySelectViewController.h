//
//  CitySelectViewController.h
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-16.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitySelectViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UISearchDisplayDelegate>
@property (retain, nonatomic) NSString *selectedCity;
//@property (assign, nonatomic) id<selectCity> delegate;

@end
