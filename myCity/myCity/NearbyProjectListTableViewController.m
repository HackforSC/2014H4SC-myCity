//
//  NearbyProjectListTableViewController.m
//  myCity
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 myCity. All rights reserved.
//

#import "NearbyProjectListTableViewController.h"
#import "MyCityProjectOverviewTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ProjectDetailTableViewController.h"

@interface NearbyProjectListTableViewController ()

@property(nonatomic,strong)NSArray *projects;

@end

@implementation NearbyProjectListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Nearby";
        [self.tabBarItem setImage:[UIImage imageNamed:@"Location"]];
        [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"LocationSelected"]];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:MyCityDidUpdateBluetoothBeaconsNotification object:nil];
    
    self.tableView.backgroundColor = [UIColor myCityPanelBackgroundColor];
    [self.tableView registerClass:[MyCityProjectOverviewTableViewCell class] forCellReuseIdentifier:@"MyCityProjectOverviewTableViewCell"];

    
    [self reloadData];
}

-(void)reloadData
{
    NSMutableArray *projects = [NSMutableArray array];
    
    NSArray *beacons = [[SessionManager sharedManager] beacons];
    
    for (ESTBeacon *currentBeacon in beacons) {
        MyCityInterest *currentInterest = [[SessionManager sharedManager] interestForBeaconID:[NSString stringWithFormat:@"%d",currentBeacon.minor.intValue]];
        
        if (currentInterest) {
            [projects addObjectsFromArray:currentInterest.projects];
        }
    }
    
    _projects = projects;
    
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
    return _projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        MyCityProjectOverviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCityProjectOverviewTableViewCell" forIndexPath:indexPath];
        
        MyCityProject *currentProject = _projects[indexPath.row];
        
        cell.totalCashAmount = currentProject.goalAmount.intValue;
        cell.totalCashRaised = currentProject.totalDonations.intValue;
        cell.totalBackers = currentProject.backerCount.intValue;
        cell.userCashRaised = currentProject.userDonations.intValue;
        [cell.projectMastHead setImageWithURL:[NSURL URLWithString:currentProject.photoUrl]];
        
        cell.projectTitle = currentProject.name;
        
        return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCityProject *currentProject = _projects[indexPath.row];
    
    if (currentProject.userDonations.intValue < 0.001) {
        return MyCityProjectOverviewCellHeight - 30.0;
    }
    
    return MyCityProjectOverviewCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProjectDetailTableViewController *project = [[ProjectDetailTableViewController alloc] initWithNibName:@"ProjectDetailTableViewController" bundle:nil];
    project.currentProject = _projects[indexPath.row];
    
    [self.navigationController pushViewController:project animated:YES];
}


@end
