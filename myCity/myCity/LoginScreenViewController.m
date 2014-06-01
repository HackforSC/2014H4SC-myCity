//
//  LoginScreenViewController.m
//  myCity
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 myCity. All rights reserved.
//

#import "LoginScreenViewController.h"
#import "FTCustomDrawView.h"

#import "SignupTableViewController.h"

@interface LoginScreenViewController ()
{
    BOOL firstAppearance;
}

@property (strong, nonatomic) IBOutlet UIImageView *buildingLogo;
@property (strong, nonatomic) IBOutlet UILabel *myCityLogoText;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinny;

@property (strong, nonatomic) IBOutlet UIView *formContainer;
@property (strong, nonatomic) IBOutlet FTCustomDrawView *customDrawContainer;

@property(nonatomic, strong) id keyboardWillShowNotification;
@property(nonatomic,strong) id keyboardWillHideNotification;

@property(nonatomic,assign)CGRect currentKeyboardFrame;
@end

@implementation LoginScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _currentKeyboardFrame = CGRectZero;
        firstAppearance = YES;
    }
    return self;
}

-(void)dealloc
{
    if (_keyboardWillHideNotification) {
        [[NSNotificationCenter defaultCenter] removeObserver:_keyboardWillHideNotification];
    }
    
    if (_keyboardWillShowNotification) {
        [[NSNotificationCenter defaultCenter] removeObserver:_keyboardWillShowNotification];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _myCityLogoText.textColor = [UIColor myCityOrangeColor];
    _formContainer.backgroundColor = [UIColor clearColor];
    
    _signInButton.backgroundColor = [UIColor myCityOrangeColor];
    _signInButton.layer.cornerRadius = 5.0;
    
    [_signupButton setTitleColor:[UIColor myCityOrangeColor] forState:UIControlStateNormal];
    
    _emailTextField.tintColor = [UIColor myCityOrangeColor];
    _passwordTextField.tintColor = [UIColor myCityOrangeColor];
    
    [_customDrawContainer setCustomDrawBlock:^(CGRect rect, UIView *view)
     {
         //Colors
         float lineWidth = 1.0/[[UIScreen mainScreen] scale];
         [[UIColor myCityDarkTextColor] set];
         CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWidth);
         
         //Rounded rect
         UIBezierPath *outlineRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(view.bounds, 0.5, 0.5) cornerRadius:5.0f];
         [outlineRect stroke];
         
         CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);
         lineWidth = 1.0;
         
         //Draw seperator lines
         float sectionHeight = ceilf(view.bounds.size.height/2.0);
         CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0.0, sectionHeight-lineWidth/2.0);
         CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), view.bounds.size.width, sectionHeight-lineWidth/2.0);
         
         CGContextStrokePath(UIGraphicsGetCurrentContext());
     }];
    
    _keyboardWillShowNotification = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        // Get the animation parameters being used to show the keyboard. We'll use the same animation parameters as we
        // resize our view.
        UIViewAnimationCurve animationCurve;
        NSTimeInterval animationDuration;
        [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        
        //Convert animation curve to UIViewAnimationOption
        animationCurve = animationCurve << 16;
        
        //Keyboard final frame size
        _currentKeyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        //Convert keyboard from screen to container parent
        _currentKeyboardFrame = [[_formContainer superview] convertRect:_currentKeyboardFrame fromView:nil];
        
        //Animate container to the correct location
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options: (UIViewAnimationOptions)animationCurve
                         animations:^{
                             
                             _formContainer.center = CGPointMake(ceilf(CGRectGetMidX(self.view.bounds)), ceilf((self.view.bounds.size.height-_currentKeyboardFrame.size.height)/2.0));
                             
                         } completion:^(BOOL finished) {
                             
                         }];
    }];
    
    _keyboardWillHideNotification = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        // Get the animation parameters being used to show the keyboard. We'll use the same animation parameters as we
        // resize our view.
        UIViewAnimationCurve animationCurve;
        NSTimeInterval animationDuration;
        [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        
        //Convert animation curve to UIViewAnimationOption
        animationCurve = animationCurve << 16;
        
        //Keyboard final frame size
        _currentKeyboardFrame = CGRectZero;
        
        //Animate container to the correct location
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options: (UIViewAnimationOptions)animationCurve
                         animations:^{
                             
                             _formContainer.center = CGPointMake(ceilf(CGRectGetMidX(self.view.bounds)), ceilf((self.view.bounds.size.height-_currentKeyboardFrame.size.height)/2.0));
                             
                         } completion:^(BOOL finished) {
                             
                         }];
    }];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (firstAppearance) {
        //Prep for appearance animation
        _customDrawContainer.alpha = 0.0;
        _signInButton.alpha = 0.0;
        _signupButton.alpha = 0.0;
        
        if (IS_IPHONE_5) {
            _formContainer.center = CGPointMake(CGRectGetMidX(self.view.bounds), 200 + CGRectGetMidY(_formContainer.bounds));
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (firstAppearance) {
        
        [UIView animateWithDuration:0.5 delay:0.3 options:0 animations:^{
            
            _formContainer.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
            _customDrawContainer.alpha = 1.0;
            _signInButton.alpha = 1.0;
            _signupButton.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            firstAppearance = NO;
        }];
    }
}

-(IBAction)nextField:(id)sender
{
    if (sender == _emailTextField) {
        [_passwordTextField becomeFirstResponder];
    }
    else if (sender == _passwordTextField)
    {
        if (_passwordTextField.text.length > 0 && _emailTextField.text.length > 0) {
            [self attemptLogin:nil];
        }
        
        [_passwordTextField resignFirstResponder];
    } else
    {
        [sender resignFirstResponder];
    }
}

-(IBAction)attemptLogin:(id)sender
{
    [self.view endEditing:YES];
    
    [_spinny startAnimating];
    self.view.userInteractionEnabled = NO;
    
    if (_emailTextField.text.length == 0 || _passwordTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You must provide an email address and password." message:@"If you don't have an account, click Sign Up at the bottom of the screen." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    [[SessionManager sharedManager] loginWithEmailAddress:_emailTextField.text password:_passwordTextField.text completionBlock:^(BOOL success, NSString *errorMessage, id resultObject) {
       
        if (success) {
            [AppStateTransitioner transitionToCoreAppAnimated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorMessage message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        [_spinny stopAnimating];
        self.view.userInteractionEnabled = YES;
    }];
}

-(IBAction)openSignup:(id)sender
{
    SignupTableViewController *signup = [[SignupTableViewController alloc] initWithNibName:@"SignupTableViewController" bundle:nil];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:signup];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
