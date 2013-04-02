//
//  CitySelectViewController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 12-12-16.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "CitySelectViewController.h"
#import "MovieConstants.h"
#import "GDataXMLNode.h"
#import "CinemaItem.h"
#import "ChineseToPinyin.h"
#import "string.h"
#import "CityItem.h"

@interface CitySelectViewController ()
@property (retain, nonatomic) NSMutableArray *citys;
@property (retain, nonatomic) NSMutableArray *cityNames;
@property (retain, nonatomic) UISearchDisplayController *mySearchDisplayController;
@property (retain, nonatomic) NSMutableArray *searchResult;
@property (retain, nonatomic) UITableView *cityTable;
@property (retain, nonatomic) NSMutableDictionary *cityList;
@property (retain, nonatomic) NSString *cityKey;
@property (retain, nonatomic) NSMutableOrderedSet *cityKeys;

@end

@implementation CitySelectViewController
@synthesize cityNames = _cityNames;
@synthesize mySearchDisplayController = _mySearchDisplayController;
@synthesize searchResult = _searchResult;
@synthesize cityTable = _cityTable;
@synthesize cityList = _cityList;
@synthesize cityKey = _cityKey;
@synthesize cityKeys = _cityKeys;
@synthesize citys = _citys;
@synthesize selectedCity = _selectedCity;
//@synthesize delegate = _delegate;

- (void)dealloc
{
    [_cityNames release];
    [_mySearchDisplayController release];
    [_searchResult release];
    [_cityTable release];
    [_cityList release];
    [_cityKey release];
    [_cityKeys release];
    [_citys release];
    [_selectedCity release];
    
    [super dealloc];
}

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
    
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
//    UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableback.jpg"]];
//    backView.frame = CGRectMake(0.0, 0.0, 320.0, [[UIScreen mainScreen] applicationFrame].size.height-93.0);
//    [self.view addSubview:backView];
//    [backView release];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backview.jpg"]];
//    self.tableView.backgroundView = imageView;
//    [imageView release];
    
//    NSString *fullpath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"why.archive"];
//    self.citys = [NSKeyedUnarchiver unarchiveObjectWithFile:fullpath];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.citys = [NSMutableArray array];
    [self.citys addObjectsFromArray:[defaults objectForKey:@"citys"]];
    
    for (int i=0; i<self.citys.count; i++) {
        NSLog(@"%@",[self.citys objectAtIndex:i]);
    }
    
    for (int i=0; i<self.citys.count; i++) {
        int min = i;
        for (int j=i+1; j<self.citys.count; j++) {
            NSString *minCityName = [self.citys objectAtIndex:min];
            NSString *minCityPinYin = [ChineseToPinyin pinyinFromChiniseString:minCityName];
            NSString *minFirstWord = [minCityPinYin substringToIndex:1];
            
            NSString *cityName = [self.citys objectAtIndex:j];
            NSString *cityPinYin = [ChineseToPinyin pinyinFromChiniseString:cityName];
            NSString *firstWord = [cityPinYin substringToIndex:1];
            
            NSComparisonResult result = [minFirstWord compare:firstWord];
            if (result == NSOrderedDescending){
                min = j;
            }
        }
        if (min != i) {
            NSString *minCity = [self.citys objectAtIndex:min];
            [self.citys replaceObjectAtIndex:min withObject:[self.citys objectAtIndex:i]];
            [self.citys replaceObjectAtIndex:i withObject:minCity];
        }
    }
    
    //初始化索引集合和cityList字典
    self.cityKeys = [NSMutableOrderedSet orderedSet];
    self.cityList = [NSMutableDictionary dictionary];
    
    for (int i=0; i<self.citys.count; i++) {
        NSString *cityName = [self.citys objectAtIndex:i];
        NSString *cityPinYin = [ChineseToPinyin pinyinFromChiniseString:cityName];
        NSString *firstWord = [cityPinYin substringToIndex:1];
        [self.cityKeys addObject:firstWord];
        NSMutableArray *cityNames = [self.cityList objectForKey:firstWord];
        if (!cityNames) {
            cityNames = [NSMutableArray array];
            [self.cityList setObject:cityNames forKey:firstWord];
        }
        [cityNames addObject:cityName];
    }
    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
//    headerView.backgroundColor = [UIColor colorWithRed:125.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0];
//    self.tableView.tableHeaderView = headerView;
//    [headerView release];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
//    searchBar.tintColor = [UIColor blackColor];
    searchBar.backgroundImage = [UIImage imageNamed:@"black.jpg"];
    searchBar.placeholder = @"search";
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:searchBar];
    [searchBar release];
    
    self.searchResult = [NSMutableArray array];
    UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsDataSource = self;
    self.mySearchDisplayController = searchDisplayController;
    [searchDisplayController release];
    
    UITableView *cityTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 44.0, 320.0, [UIScreen mainScreen].applicationFrame.size.height-44.0*2) style:UITableViewStylePlain];
    cityTable.backgroundColor = [UIColor blackColor];
    cityTable.delegate = self;
    cityTable.dataSource = self;
    [self.view addSubview:cityTable];
    self.cityTable = cityTable;
    [cityTable release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)save
{
//    CityItem *sharedCity = [[CityItem alloc] init];
//    sharedCity.cityName = self.selectedCity;
//    [CityItem setSharedCity:sharedCity];
    NSDictionary *city = [NSDictionary dictionaryWithObject:self.selectedCity forKey:@"city"];
    NSNotification *notification = [NSNotification notificationWithName:@"SelectCityNotification" object:self userInfo:city];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    else {
        return self.cityKeys.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResult.count;
    }
    else {
        return [[self.cityList objectForKey:[self.cityKeys objectAtIndex:section]] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    else {
        return [self.cityKeys objectAtIndex:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
    }
    NSString *cityName;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cityName = [self.searchResult objectAtIndex:indexPath.row];
        cell.textLabel.text = cityName;
    }
    else {
        cityName = [[self.cityList objectForKey:[self.cityKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        cell.textLabel.text = cityName;
        cell.textLabel.textColor = [UIColor whiteColor];
        if ([self.selectedCity isEqualToString:cityName]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:20.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString *cityName = [self.searchResult objectAtIndex:indexPath.row];
        self.selectedCity = cityName;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.searchDisplayController setActive:NO animated:YES];
    }
    else {
        NSArray *cityArray = [self.cityList objectForKey:[self.cityKeys objectAtIndex:indexPath.section]];
        NSString *cityName = [cityArray objectAtIndex:indexPath.row];
        self.selectedCity = cityName;
    }
    [self.cityTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    else {
        return [self.cityKeys array];
    }
}

//-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    return index;
//}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self.cityTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.searchResult removeAllObjects];
    for (int i=0; i<self.citys.count; i++) {
        NSString *cityPinYin = [ChineseToPinyin pinyinFromChiniseString:[self.citys objectAtIndex:i]];
        if ([cityPinYin hasPrefix:searchString]||[[cityPinYin lowercaseString] hasPrefix:searchString]) {
            [self.searchResult addObject:[self.citys objectAtIndex:i]];
        }
    }
    return YES;
}
@end
