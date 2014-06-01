//
//  InterestListTableViewController.m
//  myCity
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 myCity. All rights reserved.
//

#import "InterestListTableViewController.h"
#import "ProjectsListTableViewController.h"
#import "UIImageView+WebCache.h"

@interface InterestListTableViewController ()
@property(nonatomic,strong)NSArray *interests;

@end

@implementation InterestListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];
    self.tableView.tableFooterView = [UIView new];

    [self reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:MyCityDataDidUpdateNotification object:nil];
}

-(void)setCurrentLocation:(MyCityLocation *)currentLocation
{
    _currentLocation = currentLocation;
    
    self.title = _currentLocation.name;
    
    [self reloadData];
}

-(void)reloadData
{
    _interests = _currentLocation.interests;
    
    __weak InterestListTableViewController *weakSelf = self;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 160.0)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.alpha = 0.0;
    imageView.clipsToBounds = YES;
    __weak UIImageView *weakImageView = imageView;
    
    [imageView setImageWithURL:[NSURL URLWithString:_currentLocation.photoUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        imageView.image = image;
        weakSelf.tableView.tableHeaderView = imageView;
        dispatch_async(dispatch_get_main_queue(), ^{
           [UIView animateWithDuration:0.3 animations:^{
               imageView.alpha = 1.0;
           }];
        });
    }];
    
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
    return _interests.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    cell.textLabel.textColor = [UIColor myCityDarkTextColor];
    cell.textLabel.numberOfLines = 2;
    
    cell.imageView.layer.cornerRadius = cell.imageView.bounds.size.width/2.0;
    cell.imageView.layer.shouldRasterize = YES;
    cell.imageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    cell.imageView.clipsToBounds = YES;
    cell.tag = indexPath.row;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    MyCityInterest *currentLocation = _interests[indexPath.row];
    
    cell.textLabel.text = currentLocation.name;
    
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProjectsListTableViewController *projectList = [[ProjectsListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    projectList.currentInterest = _interests[indexPath.row];
    
    [self.navigationController pushViewController:projectList animated:YES];
}

@end
