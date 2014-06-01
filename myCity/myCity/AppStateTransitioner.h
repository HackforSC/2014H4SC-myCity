//
//  AppStateTransitioner.h
//  myCity
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 myCity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppStateTransitioner : NSObject

+(void)switchAppContextToViewController:(UIViewController*)controller animated:(BOOL)animated;

+(void)transitionToLoginAnimated:(BOOL)animated;

+(void)transitionToCoreAppAnimated:(BOOL)animated;

@end
