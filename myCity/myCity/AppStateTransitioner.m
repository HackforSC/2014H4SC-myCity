//
//  AppStateTransitioner.m
//  myCity
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 myCity. All rights reserved.
//

#import "AppStateTransitioner.h"
#import "AppDelegate.h"

#import "LoginScreenViewController.h"
#import "HomeScreenTableViewController.h"
#import "LocationsListTableViewController.h"
#import "NearbyProjectListTableViewController.h"
#import "AccountScreenViewController.h"
#import "DonationsScreenTableViewController.h"

@implementation AppStateTransitioner

+(void)switchAppContextToViewController:(UIViewController*)controller animated:(BOOL)animated
{
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    
    if (animated) {
        
        UIView *blackOut = [[UIView alloc] initWithFrame:[appDel.window bounds]];
        blackOut.backgroundColor = [UIColor whiteColor];
        blackOut.alpha = 0.0;
        [blackOut setNeedsDisplay];
        
        [appDel.window addSubview:blackOut];
        
        [UIView animateWithDuration:0.7 animations:^{
            
            blackOut.alpha =1.0;
            
        } completion:^(BOOL finished) {
            if (finished) {
                
                
                appDel.window.rootViewController = nil;
                
                for (UIView *myView in appDel.window.subviews) {
                    if(myView !=blackOut)
                        [myView removeFromSuperview];
                }
                //        [self.window setNeedsDisplay];
                
                appDel.window.rootViewController = controller;
                [appDel.window bringSubviewToFront:blackOut];
                
                [UIView animateWithDuration:0.7 animations:^{
                    blackOut.alpha = 0.0;
                } completion:^(BOOL finished) {
                    
                    if(finished)
                    {
                        [blackOut removeFromSuperview];
                    }
                    
                }];
            }
        }];
    }
    else
    {
        appDel.window.rootViewController = controller;
    }
}

+(void)transitionToLoginAnimated:(BOOL)animated
{
    LoginScreenViewController *login = [[LoginScreenViewController alloc] initWithNibName:@"LoginScreenViewController" bundle:nil];
    
    [self switchAppContextToViewController:login animated:animated];
}

+(void)transitionToCoreAppAnimated:(BOOL)animated
{
    HomeScreenTableViewController *home = [[HomeScreenTableViewController alloc] initWithStyle:UITableViewStylePlain];
    LocationsListTableViewController *locations = [[LocationsListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    NearbyProjectListTableViewController *nearby = [[NearbyProjectListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    AccountScreenViewController *account = [[AccountScreenViewController alloc] initWithNibName:@"AccountScreenViewController" bundle:nil];
    DonationsScreenTableViewController *donations = [[DonationsScreenTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:home];
    homeNav.navigationBar.tintColor = [UIColor myCityOrangeColor];
    
    UINavigationController *locationsNav = [[UINavigationController alloc] initWithRootViewController:locations];
    locationsNav.navigationBar.tintColor = [UIColor myCityOrangeColor];
    
    UINavigationController *nearbyNav = [[UINavigationController alloc] initWithRootViewController:nearby];
    nearbyNav.navigationBar.tintColor = [UIColor myCityOrangeColor];
    
    UINavigationController *accountNav = [[UINavigationController alloc] initWithRootViewController:account];
    accountNav.navigationBar.tintColor = [UIColor myCityOrangeColor];
    
    UINavigationController *donationsNav = [[UINavigationController alloc] initWithRootViewController:donations];
    donationsNav.navigationBar.tintColor = [UIColor myCityOrangeColor];
    
    UITabBarController *tabbar = [[UITabBarController alloc] init];
    [tabbar setViewControllers:@[homeNav, locationsNav, nearbyNav, donationsNav, accountNav]];
    
    tabbar.tabBar.tintColor = [UIColor myCityOrangeColor];
    
    [self switchAppContextToViewController:tabbar animated:animated];
}

@end
