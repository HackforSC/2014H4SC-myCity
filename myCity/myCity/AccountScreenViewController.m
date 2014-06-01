//
//  AccountScreenViewController.m
//  myCity
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 myCity. All rights reserved.
//

#import "AccountScreenViewController.h"
#import "NSMutableAttributedString+AppendStringWithFormat.h"

@interface AccountScreenViewController ()

@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UILabel *accountStatusString;
@end

@implementation AccountScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Profile";
        [self.tabBarItem setImage:[UIImage imageNamed:@"Contact"]];
        [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"Contact_Filled"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_logoutButton setBackgroundColor:[UIColor myCityOrangeColor]];
    _logoutButton.layer.cornerRadius = 5.0;
    _logoutButton.clipsToBounds = YES;
    [_logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor myCityPanelBackgroundColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self computeAccountInfoString];
}

-(void)computeAccountInfoString
{
    UIFont *helveticaLight = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    UIFont *helveticaMedium = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0];
    
    NSDictionary *plainTextDict = @{NSForegroundColorAttributeName: [UIColor myCityDarkTextColor], NSFontAttributeName : helveticaLight};
    
    NSDictionary *heavyTextDict = @{NSForegroundColorAttributeName: [UIColor myCityDarkTextColor], NSFontAttributeName : helveticaMedium};
    
    NSMutableAttributedString *displayString = [[NSMutableAttributedString alloc] initWithString:@"My name is " attributes:plainTextDict];
    
    [displayString appendString:[[[SessionManager sharedManager] currentUser] firstName] withAttributes:heavyTextDict];
    
    [displayString appendString:@".\n\n" withAttributes:plainTextDict];
    
    int dollarAmount = 0;
    
    NSArray *myProjects = [[SessionManager sharedManager] myProjects];
    
    for (MyCityProject *currentProject in myProjects) {
        if (currentProject.userDonations.intValue > 0.001) {
            dollarAmount += currentProject.userDonations.intValue;
        }
    }
    
    [displayString appendString:@"I've donated " withAttributes:plainTextDict];
    [displayString appendString:[NSString stringWithFormat:@"$%d",dollarAmount] withAttributes:heavyTextDict];
    [displayString appendString:@" this year.\n\n" withAttributes:plainTextDict];
    
    [displayString appendString:@"I've helped " withAttributes:plainTextDict];
    
    if (myProjects.count == 1) {
        [displayString appendString:[NSString stringWithFormat:@"%d project", (int)myProjects.count] withAttributes:heavyTextDict];
    }
    else
    {
        [displayString appendString:[NSString stringWithFormat:@"%d projects", (int)myProjects.count] withAttributes:heavyTextDict];
    }
    
    [displayString appendString:@" reach their goal.\n\n" withAttributes:plainTextDict];
    
    [displayString appendString:@"I've submitted " withAttributes:plainTextDict];
    [displayString appendString:@"5 improvement ideas" withAttributes:heavyTextDict];
    [displayString appendString:@" this year.\n\n" withAttributes:plainTextDict];
    [displayString appendString:@"Columbia, SC" withAttributes:heavyTextDict];
    [displayString appendString:@" is " withAttributes:plainTextDict];
    [displayString appendString:@"myCity" withAttributes:@{NSFontAttributeName: helveticaLight, NSForegroundColorAttributeName : [UIColor myCityOrangeColor]}];
    [displayString appendString:@"." withAttributes:plainTextDict];
    
    CGRect stringSize = [displayString boundingRectWithSize:CGSizeMake(self.view.bounds.size.width-40.0, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    
    _accountStatusString.attributedText = displayString;
    _accountStatusString.frame = CGRectMake(20.0, self.topLayoutGuide.length+10, self.view.bounds.size.width-40.0, stringSize.size.height);
    
    _logoutButton.frame = CGRectMake(20.0, self.topLayoutGuide.length+10+stringSize.size.height, self.view.bounds.size.width-40.0, 44.0);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logoutButton:(id)sender {
    [[SessionManager sharedManager] logout];
    
    [AppStateTransitioner transitionToLoginAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
