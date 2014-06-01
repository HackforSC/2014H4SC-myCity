//
//  DonationsScreenTableViewController.m
//  myCity
//
//  Created by Brendan Lee on 6/1/14.
//  Copyright (c) 2014 myCity. All rights reserved.
//

#import "DonationsScreenTableViewController.h"
#import "MyCityProjectOverviewTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ProjectDetailTableViewController.h"

@interface DonationsScreenTableViewController ()

@property(nonatomic,strong)NSArray *projects;

@end

@implementation DonationsScreenTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Donations";
        [self.tabBarItem setImage:[UIImage imageNamed:@"Dollar"]];
        [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"Dollar_Filled"]];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:MyCityDidUpdateDonationsNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
}

-(void)reloadData
{
    _projects = [[SessionManager sharedManager] myProjects];
    [self.refreshControl endRefreshing];
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
