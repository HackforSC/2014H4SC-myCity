//
//  SessionManager.h
//  myCity
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 myCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyCityUser.h"
#import "MyCityCurrentData.h"
#import "MyCityDonation.h"
#import "MyCityInterest.h"
#import "MyCityLocation.h"
#import "MyCityProject.h"
#import "MyCityTag.h"

#import "ESTBeaconDefinitions.h"
#import "ESTBeaconManager.h"
#import "ESTBeaconRegion.h"

#import <CoreLocation/CoreLocation.h>

#define MYCITY_SIGNING_KEY @"BYaLNZfwYz9ZLazkbDBJua[qiLmH,BDIfHE3Y8&7Oyi;QQvBZy"
#define MYCITY_API_BASE @"https://mycity.52-apps.com/"

#define MyCityDataDidUpdateNotification @"MyCityDataDidUpdateNotification"
#define MyCityDidUpdateBluetoothBeaconsNotification @"MyCityDidUpdateBluetoothBeaconsNotification"
#define MyCityDidUpdateDonationsNotification @"MyCityDidUpdateDonationsNotification"

typedef void (^APIResultBlock)(BOOL success, NSString *errorMessage, id resultObject);


@interface SessionManager : NSObject<ESTBeaconManagerDelegate, CLLocationManagerDelegate>

@property(nonatomic,strong)ESTBeaconManager *beaconManager;
@property(nonatomic,strong)CLLocationManager *locationManager;

@property(nonatomic,strong)MyCityUser *currentUser;
@property(nonatomic,strong)MyCityCurrentData *currentData;

@property(nonatomic,strong)NSArray *beacons;

+(SessionManager*)sharedManager;

-(void)sendMyCityAPIRequestToEndpoint:(NSString*)endpoint withParameters:(NSDictionary*)parameters completionBlock:(APIResultBlock)completionBlock;

-(void)loginWithEmailAddress:(NSString*)email password:(NSString*)password completionBlock:(APIResultBlock)completionBlock;

-(void)signupWithFirstName:(NSString*)firstName lastName:(NSString*)lastName emailAddress:(NSString*)email password:(NSString*)password completionBlock:(APIResultBlock)completionBlock;

-(void)refreshDataSourceWithCompletionBlock:(APIResultBlock)completionBlock;

-(void)donateToProjectID:(int)projectID amount:(int)amount withCompletionBlock:(APIResultBlock)completionBlock;

-(NSArray*)allProjects;

-(MyCityInterest*)interestForBeaconID:(NSString*)beacon;

-(NSArray*)myProjects;

-(void)logout;

-(void)saveSession;

-(void)recoverSession;


@end
