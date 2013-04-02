//
//  MapViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 13-1-14.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import "MapViewController.h"

#import <MapKit/MapKit.h>

@interface MapViewController()
@property (nonatomic, retain) MKMapView *mapView;
@property (retain, nonatomic) CLLocationManager *locationManager;

@end

@implementation MapViewController
@synthesize locations=_locations;
@synthesize mapView=_mapView;
@synthesize locationManager = _locationManager;

-(void)dealloc
{
    self.locationManager.delegate = nil;
    
    [_locations release];
    [_mapView release];
    [_locationManager release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"影院位置";
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem *locationButton = [[UIBarButtonItem alloc] initWithTitle:@"当前位置" style:UIBarButtonItemStyleBordered target:self action:@selector(userLocate)];
    self.navigationItem.rightBarButtonItem = locationButton;
    [locationButton release];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // map view
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 367.0)];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    self.mapView = mapView;
    [mapView release];
    
    // 判断是否单个批注显示
    if ([self.locations count] == 1)
    {
        // 使用这个批注作为区域中心
        MKCoordinateRegion region;
        region.span = MKCoordinateSpanMake(0.003, 0.003);
        region.center = [[self.locations lastObject] coordinate];
        [self.mapView setRegion:region];
    }
    
    // 添加所有的批注
    [self.mapView addAnnotations:self.locations];
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    self.locationManager = locationManager;
    [locationManager release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (MKPointAnnotation *annotation in self.mapView.annotations)
    {
        // 判断是否单个批注显示
        if ([self.locations count] == 1)
        {
            // 选中当前批注
            [self performSelector:@selector(selectAnnotation:) withObject:annotation afterDelay:1.0];
            break;
        }
    }
}

-(void)selectAnnotation:(id<MKAnnotation>)annotation
{
    [self.mapView selectAnnotation:annotation animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        ((MKUserLocation *)annotation).title = @"当前位置";
        return nil;
    }
    else
    {
        // 普通的MKPointAnnotation
        
        // 重用和创建annotationView
        static NSString *identifier = @"PinAnnotation";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annotationView)
        {
            annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
        }
        else
        {
            annotationView.annotation = annotation;
        }
        
        // 打开callout功能
        annotationView.canShowCallout = YES;
        
        // 允许当前批注带大头针动画
        annotationView.animatesDrop = YES;
        
        return annotationView;
    }
}

- (void)userLocate
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    self.mapView.showsUserLocation = YES;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
    {
        [self performSelector:@selector(updateLocationToUserRegion:) withObject:userLocation];
    }
}
 
- (void)updateLocationToUserRegion:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region;
    region.span = MKCoordinateSpanMake(0.003, 0.003);
    region.center = userLocation.coordinate;
    [self.mapView setRegion:region];
    [self performSelector:@selector(selectUserAnnotation:) withObject:userLocation afterDelay:1.0];
}
- (void)selectUserAnnotation:(id<MKAnnotation>)annotation
{
    [self selectAnnotation:annotation];
    [self refreshUserButton];
}

- (void)refreshUserButton 
{
    self.navigationItem.rightBarButtonItem.title = @"影院位置";
    self.navigationItem.rightBarButtonItem.action = @selector(updateLocationToCinemaRigion);
}

- (void)updateLocationToCinemaRigion
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.mapView.showsUserLocation = NO;
    MKCoordinateRegion region;
    region.span = MKCoordinateSpanMake(0.003, 0.003);
    region.center = [[self.locations lastObject] coordinate];
    [self.mapView setRegion:region];
    
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
            [self performSelector:@selector(selectCinemaAnnotation:) withObject:annotation afterDelay:1.0];
            break;
        }
    }
}

- (void)selectCinemaAnnotation:(id<MKAnnotation>)annotation
{
    [self selectAnnotation:annotation];
    [self refreshCinemaButton];
}

- (void)refreshCinemaButton
{
    self.navigationItem.rightBarButtonItem.title = @"当前位置";
    self.navigationItem.rightBarButtonItem.action = @selector(userLocate);
}

@end