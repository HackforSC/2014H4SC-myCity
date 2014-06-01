//
//  MyCityProject.h
//  
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 52apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCityProject : NSObject <NSCoding> {

}

@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSArray *donations;
@property (nonatomic, strong) NSString *goalAmount;
@property (nonatomic, strong) NSString *interestsId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSString *myCityProjectId;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSString *totalDonations;
@property (nonatomic, strong) NSString *userDonations;
@property (nonatomic,strong) NSString *backerCount;

+ (MyCityProject *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
