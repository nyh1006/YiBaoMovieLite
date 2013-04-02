//
//  MapViewController.h
//  YiBaoMovieLite
//
//  Created by MaKai on 13-1-14.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic, retain) NSArray *locations;

@end

