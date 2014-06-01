//
//  MyCityLocation.h
//  
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 52apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCityLocation : NSObject <NSCoding> {

}

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSArray *interests;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *myCityLocationId;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *streetAddress;

+ (MyCityLocation *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
