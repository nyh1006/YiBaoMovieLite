//
//  AboutViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-23.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about.jpg"]];
    imageView.frame = CGRectMake(0.0, 0.0, 320.0, 416.0);
    [self.view addSubview:imageView];
    [imageView release];
    
//    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 100.0, 150.0, 30.0)];
//    nameLabel.font = [UIFont boldSystemFontOfSize:20.0];
//    nameLabel.backgroundColor = [UIColor clearColor];
//    nameLabel.textAlignment = NSTextAlignmentCenter;
//    nameLabel.text = @"Ma kai";
//    [self.view addSubview:nameLabel];
//    [nameLabel release];
    
//    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 140.0, 250.0, 30.0)];
//    descriptionLabel.font = [UIFont systemFontOfSize:18.0];
//    descriptionLabel.backgroundColor = [UIColor clearColor];
//    descriptionLabel.textAlignment = NSTextAlignmentCenter;
//    descriptionLabel.text = @"©Copyright iBokan, 2012";
//    [self.view addSubview:descriptionLabel];
//    [descriptionLabel release];
    
    self.navigationItem.title = @"About This App";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
