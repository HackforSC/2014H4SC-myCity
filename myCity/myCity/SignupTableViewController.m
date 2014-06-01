//
//  SignupTableViewController.m
//  myCity
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 myCity. All rights reserved.
//

#import "SignupTableViewController.h"

@interface SignupTableViewController ()
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@end

#define SignupFirstNameRow 0
#define SignupLastNameRow 1
#define SignupEmailRow 2
#define SignupPasswordRow 3
#define SignupConfirmPasswordRow 4

#define InputFieldTagID 301

@implementation SignupTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"myCity";
    
    //Assign theme colors in code
    _firstNameTextField.tintColor = [UIColor myCityOrangeColor];
    _lastNameTextField.tintColor = [UIColor myCityOrangeColor];
    _emailAddressTextField.tintColor = [UIColor myCityOrangeColor];
    _passwordTextField.tintColor = [UIColor myCityOrangeColor];
    _confirmPasswordTextField.tintColor = [UIColor myCityOrangeColor];
    
    _firstNameTextField.textColor = [UIColor myCityDarkTextColor];
    _lastNameTextField.textColor = [UIColor myCityDarkTextColor];
    _emailAddressTextField.textColor = [UIColor myCityDarkTextColor];
    _passwordTextField.textColor = [UIColor myCityDarkTextColor];
    _confirmPasswordTextField.textColor = [UIColor myCityDarkTextColor];
    
    //Assign frames
    CGRect frameInCell = CGRectMake(20.0, 0, self.tableView.bounds.size.width, 44.0);
    _firstNameTextField.frame = frameInCell;
    _lastNameTextField.frame = frameInCell;
    _emailAddressTextField.frame = frameInCell;
    _passwordTextField.frame = frameInCell;
    _confirmPasswordTextField.frame = frameInCell;
    
    //Assign input tag so we can pull any textfields out of a cell before reuse
    _firstNameTextField.tag = InputFieldTagID;
    _lastNameTextField.tag = InputFieldTagID;
    _emailAddressTextField.tag = InputFieldTagID;
    _passwordTextField.tag = InputFieldTagID;
    _confirmPasswordTextField.tag = InputFieldTagID;
    
    self.tableView.backgroundColor = [UIColor myCityPanelBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStyleBordered target:self action:@selector(attemptSignup)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor myCityDarkTextColor];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_firstNameTextField becomeFirstResponder];
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
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SignupCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SignupCell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //Remove any input fields from this reused cell.
    [[cell.contentView viewWithTag:InputFieldTagID] removeFromSuperview];
    
    // Configure the cell...
    
    switch (indexPath.row) {
        case SignupFirstNameRow:
        {
            [cell.contentView addSubview:_firstNameTextField];
        }
            break;
        case SignupLastNameRow:
        {
            [cell.contentView addSubview:_lastNameTextField];
        }
            break;
        case SignupEmailRow:
        {
            [cell.contentView addSubview:_emailAddressTextField];
        }
            break;
        case SignupPasswordRow:
        {
            [cell.contentView addSubview:_passwordTextField];
        }
            break;
        case SignupConfirmPasswordRow:
        {
            [cell.contentView addSubview:_confirmPasswordTextField];
        }
            break;
        default:
            break;
    }
    
    return cell;
}


-(IBAction)nextField:(id)sender
{
    if (sender == _firstNameTextField) {
        [_lastNameTextField becomeFirstResponder];
    } else if (sender == _lastNameTextField)
    {
        [_emailAddressTextField becomeFirstResponder];
    } else if (sender == _emailAddressTextField)
    {
        [_passwordTextField becomeFirstResponder];
    } else if (sender == _passwordTextField)
    {
        [_confirmPasswordTextField becomeFirstResponder];
    } else if (sender == _confirmPasswordTextField)
    {
        [self attemptSignup];
    } else
    {
        [sender resignFirstResponder];
    }
}

-(void)attemptSignup
{
    
    if (_firstNameTextField.text.length == 0 || _lastNameTextField.text.length == 0 || _emailAddressTextField.text.length == 0 || _passwordTextField.text.length == 0 || _confirmPasswordTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"All fields are required." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (![_passwordTextField.text isEqualToString:_confirmPasswordTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your passwords don't match. Try typing them again." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self.view endEditing:YES];
    self.navigationController.view.userInteractionEnabled = NO;
    
    UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinny startAnimating];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinny];
    
    [[SessionManager sharedManager] signupWithFirstName:_firstNameTextField.text lastName:_lastNameTextField.text emailAddress:_emailAddressTextField.text password:_passwordTextField.text completionBlock:^(BOOL success, NSString *errorMessage, id resultObject) {
        
        if (success) {
            [AppStateTransitioner transitionToCoreAppAnimated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorMessage message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        self.navigationController.view.userInteractionEnabled = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStyleBordered target:self action:@selector(attemptSignup)];

    }];
}

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
