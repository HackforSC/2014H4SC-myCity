//
//  SessionManager.m
//  myCity
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 myCity. All rights reserved.
//

#import "SessionManager.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonCrypto.h>
#import "NSData+NSData_AES.h"


static SessionManager *sharedManager;

@implementation SessionManager

+(SessionManager*)sharedManager
{
    if (!sharedManager) {
        sharedManager = [[SessionManager alloc] init];
        [sharedManager postInit];
    }
    
    return sharedManager;
}

-(id)init
{
    self = [super init];
    
    if (self) {
        [self recoverSession];
        
        _beaconManager = [[ESTBeaconManager alloc] init];
        _beaconManager.delegate = self;
        
        ESTBeaconRegion *region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID identifier:@"AllBeacons"];
        
        [_beaconManager startMonitoringForRegion:region];
        [_beaconManager startRangingBeaconsInRegion:region];
        
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        [_locationManager setDistanceFilter:kCLDistanceFilterNone];
        
        [_locationManager setDelegate:self];
        [_locationManager startUpdatingLocation];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    
    return self;
}

-(void)postInit
{
    
}

-(void)didEnterBackground
{
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
    }];
}

-(void)didEnterForeground
{
    ESTBeaconRegion *region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID identifier:@"AllBeacons"];
    
    [_beaconManager startMonitoringForRegion:region];
    [_beaconManager startRangingBeaconsInRegion:region];
    
    [_locationManager startUpdatingLocation];
}

-(void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    NSLog(@"Ranged beacons: %lu", (unsigned long)beacons.count);
    
    NSMutableArray *nearBeacons = [NSMutableArray array];
    
    for (ESTBeacon* currentBeacon in beacons) {
        switch (currentBeacon.proximity) {
            case CLProximityUnknown:
            {
                NSLog(@"Unknown: %d, %d", currentBeacon.minor.intValue, (int)currentBeacon.rssi);
            }
                break;
            case CLProximityImmediate:
            {
                NSLog(@"Immediate: %d, %d", currentBeacon.minor.intValue, (int)currentBeacon.rssi);
                [nearBeacons addObject:currentBeacon];
            }
                break;
            case CLProximityNear:
            {
                NSLog(@"Near: %d, %d", currentBeacon.minor.intValue, (int)currentBeacon.rssi);
                [nearBeacons addObject:currentBeacon];
            }
                break;
            case CLProximityFar:
            {
                NSLog(@"Far: %d, %d", currentBeacon.minor.intValue, (int)currentBeacon.rssi);
            }
                break;
            default:
                break;
        }
        
        MyCityInterest *interest = [self interestForBeaconID:[NSString stringWithFormat:@"%d",currentBeacon.minor.intValue]];
        
        if (interest) {
            NSLog(@"Interest: %@", interest.name);
        }
        
    }
    
    if (nearBeacons.count > _beacons.count) {
        ESTBeacon *firstBeacon = [beacons firstObject];
        MyCityInterest *interest = [self interestForBeaconID:[NSString stringWithFormat:@"%d",firstBeacon.minor.intValue]];
        
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground && interest) {
            UILocalNotification *notif = [[UILocalNotification alloc] init];
            [notif setAlertBody:[NSString stringWithFormat:@"%@ is looking for donations and needs your help!", interest.name]];
            [notif setFireDate:[NSDate date]];
            
            [[UIApplication sharedApplication] presentLocalNotificationNow:notif];
        }

    }
    
    
    if (_beacons.count != nearBeacons.count) {
        _beacons = nearBeacons;

        [[NSNotificationCenter defaultCenter] postNotificationName:MyCityDidUpdateBluetoothBeaconsNotification object:nil];
    }
    else
    {
        _beacons = nearBeacons;
    }
    
}

-(MyCityInterest*)interestForBeaconID:(NSString*)beacon
{
    
    for (int i=0; i<_currentData.locations.count; i++) {
        MyCityLocation *currentLocation = _currentData.locations[i];
        
        for (int j = 0; j<currentLocation.interests.count; j++) {
            
            MyCityInterest *currentInterest = currentLocation.interests[j];
            
            if (![currentInterest.beacon isKindOfClass:[NSNull class]] && [currentInterest.beacon isEqualToString:beacon]) {
                return currentInterest;
            }
        }
    }
    
    return nil;
}

-(void)beaconManager:(ESTBeaconManager *)manager rangingBeaconsDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"Failed ranging: %@",error.localizedDescription);
}

-(void)beaconManager:(ESTBeaconManager *)manager didDiscoverBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    NSLog(@"Discovered beacons: %lu", (unsigned long)beacons.count);
}

-(void)beaconManager:(ESTBeaconManager *)manager didFailDiscoveryInRegion:(ESTBeaconRegion *)region
{
    NSLog(@"Failed discovery");
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Location Updates");
}

-(void)sendMyCityAPIRequestToEndpoint:(NSString*)endpoint withParameters:(NSDictionary*)parameters completionBlock:(APIResultBlock)completionBlock
{
    NSMutableDictionary *requestParams = [NSMutableDictionary dictionaryWithDictionary:parameters];
    requestParams[@"timestamp"] = @((int)[[NSDate date] timeIntervalSince1970]);
    
    NSError *error;
    NSData *json = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    NSString *hash = nil;
    
    if (jsonString) {
        hash = [self hashForAPIWithParameters:jsonString timestamp:requestParams[@"timestamp"]];
    }
    
    if (hash) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:endpoint relativeToURL:[NSURL URLWithString:MYCITY_API_BASE]]];
        
        NSString * params =[NSString stringWithFormat:@"json=%@&signing_hash=%@", jsonString, hash];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if (!error) {
                    
                    //NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                    
                    NSError *jsonError = nil;
                    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                    
                    if (!jsonError) {
                        
                        if ([response[@"status"] isEqualToString:@"success"]) {
                            if (completionBlock) {
                                completionBlock(YES, nil, response);
                            }
                        }
                        else
                        {
                            if (completionBlock) {
                                completionBlock(NO, response[@"error_readable"], response);
                            }
                        }
                        
                    }
                    else
                    {
                        if (completionBlock) {
                            completionBlock(NO, [NSString stringWithFormat:@"Unable to connect to server. %@", jsonError.localizedDescription], nil);
                        }
                    }
                }
                else
                {
                    if (completionBlock) {
                        completionBlock(NO, [NSString stringWithFormat:@"Unable to connect to server. %@", error.localizedDescription], nil);
                    }
                }
            });
            
        }] resume];
    }
    else
    {
        if (completionBlock) {
            completionBlock(NO, [NSString stringWithFormat:@"Unable to connect to server. Invalid request creation."], nil);
        }
    }
}

-(NSString*)hashForAPIWithParameters:(NSString*)JSON timestamp:(NSNumber*)time
{
    if(JSON)
    {
        NSString *timestamp = [NSString stringWithFormat:@"%d",[time intValue]];
        
        return [self sha256:[NSString stringWithFormat:@"%@%@%@",JSON,timestamp,MYCITY_SIGNING_KEY]];
    }
    return nil;
}

-(NSString*) sha256:(NSString *)clear{
    const char *s=[clear cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, (int)keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

-(void)loginWithEmailAddress:(NSString*)email password:(NSString*)password completionBlock:(APIResultBlock)completionBlock
{
    [self sendMyCityAPIRequestToEndpoint:@"user/login" withParameters:@{@"email_address": email, @"password" : password} completionBlock:^(BOOL success, NSString *errorMessage, NSDictionary* resultObject) {
        
        if (success) {
            _currentUser = [MyCityUser instanceFromDictionary:resultObject[@"user"]];
            [self saveSession];
        }
        else
        {
            _currentUser = nil;
        }
        
        if (completionBlock) {
            if (success) {
                completionBlock(YES, nil, _currentUser);
            }
            else
            {
                completionBlock(NO, errorMessage, resultObject);
            }
        }
    }];
}

-(void)signupWithFirstName:(NSString*)firstName lastName:(NSString*)lastName emailAddress:(NSString*)email password:(NSString*)password completionBlock:(APIResultBlock)completionBlock
{
    [self sendMyCityAPIRequestToEndpoint:@"user" withParameters:@{@"first_name": firstName, @"last_name" : lastName, @"email_address" : email, @"password" : password} completionBlock:^(BOOL success, NSString *errorMessage, NSDictionary *resultObject) {
        
        if (success) {
            _currentUser = [MyCityUser instanceFromDictionary:resultObject[@"user"]];
            [self saveSession];
        }
        else
        {
            _currentUser = nil;
        }
        
        if (completionBlock) {
            if (success) {
                completionBlock(YES, nil, _currentUser);
            }
            else
            {
                completionBlock(NO, errorMessage, resultObject);
            }
        }
        
    }];
}

-(void)refreshDataSourceWithCompletionBlock:(APIResultBlock)completionBlock
{
    [self sendMyCityAPIRequestToEndpoint:[NSString stringWithFormat:@"user/%d/locations", _currentUser.myCityUserId.intValue] withParameters:@{@"access_key" : _currentUser.accessKey, @"user_id" : _currentUser.myCityUserId} completionBlock:^(BOOL success, NSString *errorMessage, NSDictionary *resultObject) {
        
        if (success) {
            _currentData = [MyCityCurrentData instanceFromDictionary:resultObject];
            
            if (completionBlock) {
                completionBlock(YES, nil, _currentData);
            }
        }
        else
        {
            if (completionBlock) {
                completionBlock(NO, errorMessage, resultObject);
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MyCityDataDidUpdateNotification object:nil];
        
    }];
}

-(void)donateToProjectID:(int)projectID amount:(int)amount withCompletionBlock:(APIResultBlock)completionBlock
{
    [self sendMyCityAPIRequestToEndpoint:[NSString stringWithFormat:@"user/%@/donate", _currentUser.myCityUserId] withParameters:@{@"access_key" : _currentUser.accessKey, @"user_id" : _currentUser.myCityUserId, @"ammount" : @(amount), @"project_id" : @(projectID)} completionBlock:^(BOOL success, NSString *errorMessage, id resultObject) {
       
        if (completionBlock) {
            completionBlock(success, errorMessage, resultObject);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MyCityDidUpdateDonationsNotification object:nil];
        
    }];
}

-(NSArray*)allProjects
{
    NSMutableArray *allProjects = [NSMutableArray array];
    
    for (int i=0; i<_currentData.locations.count; i++) {
        MyCityLocation *currentLocation = _currentData.locations[i];
        
        for (int j=0; j<currentLocation.interests.count; j++) {
            MyCityInterest *currentInterest = currentLocation.interests[j];
            
            [allProjects addObjectsFromArray:currentInterest.projects];
        }
    }
    
    return allProjects;
}

-(NSArray*)myProjects
{
    NSMutableArray *projectList = [NSMutableArray array];
    
    NSArray *locations = [[[[SessionManager sharedManager] currentData] locations] copy];
    
    for (MyCityLocation *currentLocation in locations) {
        NSArray *interests = [currentLocation.interests copy];
        
        for (MyCityInterest *currentInterest in interests) {
            NSArray *projects = currentInterest.projects.copy;
            
            for (MyCityProject *currentProject in projects) {
                if (currentProject.userDonations.intValue > 0.001) {
                    [projectList addObject:currentProject];
                }
            }
            
        }
    }
    
    return projectList;
}

-(void)logout
{
    _currentUser = nil;
    _currentData = nil;
    
    [USER_DEFAULTS removeObjectForKey:@"session"];
    [USER_DEFAULTS synchronize];
}

//Keychain doesn't unlock until after first user unlock after reboot. This is problematic for location services (and bluetooth) that boot before that. Credentials can be lost, or a session cannot begin, until the user unlocks the device possibly hours later. Encrypting it and storing it myself lets me begin services immediately after reboot. Although its in user defaults, its IS encrypted.
-(void)saveSession
{
    if(_currentUser)
    {
        NSMutableDictionary *recoveryProperties = [NSMutableDictionary dictionary];
        
        [recoveryProperties setObject:_currentUser forKey:@"user"];

        
        NSData *encryptedData = [[NSKeyedArchiver archivedDataWithRootObject:recoveryProperties] AES256EncryptWithKey:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
        
        [USER_DEFAULTS setObject:encryptedData forKey:@"session"];
        [USER_DEFAULTS synchronize];
    }
}

-(void)recoverSession
{
    NSDictionary *recoveryProperties = nil;
    @try {
        recoveryProperties = [NSKeyedUnarchiver unarchiveObjectWithData:[[USER_DEFAULTS objectForKey:@"session"] AES256DecryptWithKey:[[[UIDevice currentDevice] identifierForVendor] UUIDString]]];
        
        
    }
    @catch (NSException *exception) {
        recoveryProperties = nil;
    }
    @finally {
        if (recoveryProperties) {
            _currentUser = recoveryProperties[@"user"];
        }
    }
}

@end
