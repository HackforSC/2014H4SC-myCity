//
//  ProjectDetailTableViewController.m
//  myCity
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 myCity. All rights reserved.
//

#import "ProjectDetailTableViewController.h"
#import "MyCityProjectOverviewTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ProjectDetailTableViewController ()
@property (strong, nonatomic) IBOutlet UITableViewCell *donationCell;
@property (nonatomic,strong)NSString *style;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *donateButtons;

@end

#define ProjectDetailHeaderSection 0
#define ProjectDetailDonateSection 1
#define ProjectDetailDetailSection 2

@implementation ProjectDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.backgroundColor = [UIColor myCityPanelBackgroundColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self.tableView registerClass:[MyCityProjectOverviewTableViewCell class] forCellReuseIdentifier:@"MyCityProjectOverviewTableViewCell"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];
    
    _style = @"<style type=\"text/css\">body {background-color: transparent  !important;color: rgb(83, 71, 65)  !important;font-family:\"HelveticaNeue\", sans-serif  !important;font-size: 12pt  !important;line-height:25px !important;font-weight:300;}</style>";
    
    [_donateButtons makeObjectsPerformSelector:@selector(setTintColor:) withObject:[UIColor myCityOrangeColor]];
    
    for (UIButton *button in _donateButtons) {
        [button setTitleColor:[UIColor myCityOrangeColor] forState:UIControlStateNormal];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = _currentProject.name;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case ProjectDetailHeaderSection:
        {
            MyCityProjectOverviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCityProjectOverviewTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.blockHighlight = YES;
            cell.totalCashAmount = _currentProject.goalAmount.intValue;
            cell.totalCashRaised = _currentProject.totalDonations.intValue;
            cell.totalBackers = _currentProject.backerCount.intValue;
            cell.userCashRaised = _currentProject.userDonations.intValue;
            [cell.projectMastHead setImageWithURL:[NSURL URLWithString:_currentProject.photoUrl]];
            
            cell.projectTitle = _currentProject.name;

            return cell;
        }
            break;
        case ProjectDetailDonateSection:
        {
            return _donationCell;
        }
            break;
        case ProjectDetailDetailSection:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
            cell.indentationWidth = 2;
            cell.indentationLevel = 12;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.numberOfLines = 0;
            
            NSDictionary *textAttributes = @{NSForegroundColorAttributeName: RGB(51, 51, 51),
                                             NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0]};
            NSDictionary *docAttribters = @{NSDefaultAttributesDocumentAttribute: textAttributes};
            
            NSAttributedString * attributedContent = [[NSAttributedString alloc] initWithData:[[_style stringByAppendingString:_currentProject.descriptionText] dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:&docAttribters error:nil];
            
            cell.textLabel.attributedText = attributedContent;
        }
            
        default:
            break;
    }
    
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case ProjectDetailHeaderSection:
        {
            return MyCityProjectOverviewCellHeight-40.0;
        }
            break;
        case ProjectDetailDonateSection:
            return 44.0;
            break;
        case ProjectDetailDetailSection:
        {
            NSDictionary *textAttributes = @{NSForegroundColorAttributeName: RGB(51, 51, 51),
                                             NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0]};
            NSDictionary *docAttribters = @{NSDefaultAttributesDocumentAttribute: textAttributes};
            
            NSAttributedString * attributedContent = [[NSAttributedString alloc] initWithData:[[_style stringByAppendingString:_currentProject.descriptionText] dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:&docAttribters error:nil];
            
            CGRect size = [attributedContent boundingRectWithSize:CGSizeMake(tableView.bounds.size.width-40.0, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            
            return size.size.height+20;
        }
            break;
            
        default:
        {
            return 0.0;
        }
            break;
    }
}

-(IBAction)donateMONEYS:(UIButton*)sender
{
    NSString *donationAmount = [[sender titleForState:UIControlStateNormal] stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Are you sure you want to donate $%@ to this project?", donationAmount] message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes!", nil];
    alert.tag = donationAmount.intValue;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        int donationAmount = (int)alertView.tag;
        
        [[SessionManager sharedManager] donateToProjectID:_currentProject.myCityProjectId.intValue amount:donationAmount withCompletionBlock:^(BOOL success, NSString *errorMessage, id resultObject) {
           
            if (success) {
                _currentProject.userDonations = [NSString stringWithFormat:@"%d", _currentProject.userDonations.intValue + donationAmount];
                _currentProject.totalDonations = [NSString stringWithFormat:@"%d", _currentProject.totalDonations.intValue + donationAmount];
                
                
                [self.tableView reloadData];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thanks for donating!" message:@"Your donation helps projects in your community thrive. Check back to see the status of this project any time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorMessage message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            
        }];
    }
}

@end
