//
//  LocationsListTableViewController.m
//  myCity
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 myCity. All rights reserved.
//

#import "LocationsListTableViewController.h"
#import "InterestListTableViewController.h"
#import "UIImageView+WebCache.h"

@interface LocationsListTableViewController ()

@property(nonatomic,strong)NSArray *locations;

@end

@implementation LocationsListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Locations";
        [self.tabBarItem setImage:[UIImage imageNamed:@"Map_Pin"]];
        [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"Map_Pin_Solid"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.backgroundColor = [UIColor myCityPanelBackgroundColor];
    self.tableView.tableFooterView = [UIView new];
    [self reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:MyCityDataDidUpdateNotification object:nil];
}

-(void)reloadData
{
    _locations = [[[[SessionManager sharedManager] currentData] locations] copy];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _locations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    cell.textLabel.textColor = [UIColor myCityDarkTextColor];
    cell.textLabel.numberOfLines = 2;
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    cell.imageView.layer.cornerRadius = cell.imageView.bounds.size.width/2.0;
    cell.imageView.layer.shouldRasterize = YES;
    cell.imageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    cell.imageView.clipsToBounds = YES;
    cell.tag = indexPath.row;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;


    MyCityLocation *currentLocation = _locations[indexPath.row];
    
    cell.textLabel.text = currentLocation.name;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", currentLocation.city, currentLocation.state];


    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    InterestListTableViewController *interest = [[InterestListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    interest.currentLocation = _locations[indexPath.row];
    
    [self.navigationController pushViewController:interest animated:YES];
}

@end
