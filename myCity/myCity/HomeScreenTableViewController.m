//
//  HomeScreenTableViewController.m
//  myCity
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 myCity. All rights reserved.
//

#import "HomeScreenTableViewController.h"
#import "MyCityProjectOverviewTableViewCell.h"
#import "ProjectDetailTableViewController.h"

#import "UIImageView+WebCache.h"

#define HomescreenTableViewSectionBluetoothLE 0
#define HomescreenTableViewSectionProjects 1


@interface HomeScreenTableViewController ()

@property(nonatomic,strong)NSArray *projects;

@end

@implementation HomeScreenTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Popular";
        [self.tabBarItem setImage:[UIImage imageNamed:@"Favorites"]];
        [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"Favorites_Filled"]];
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
    [self.tableView registerClass:[MyCityProjectOverviewTableViewCell class] forCellReuseIdentifier:@"MyCityProjectOverviewTableViewCell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![[SessionManager sharedManager] currentData]) {
        
        [self.refreshControl beginRefreshing];
        [self reloadData];
    }
    else
    {
        [[SessionManager sharedManager] allProjects];
        [self.tableView reloadData];
    }
}

-(void)reloadData
{
    [[SessionManager sharedManager] refreshDataSourceWithCompletionBlock:^(BOOL success, NSString *errorMessage, id resultObject) {
        
        _projects = [[SessionManager sharedManager] allProjects];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case HomescreenTableViewSectionBluetoothLE:
            return 0;
            break;
        case HomescreenTableViewSectionProjects:
            return _projects.count;
            break;
            
        default:
            break;
    }
    
    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == HomescreenTableViewSectionProjects) {

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
    return nil;
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
