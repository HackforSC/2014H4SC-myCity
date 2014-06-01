//
//  MyCityInterest.h
//  
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 52apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCityInterest : NSObject <NSCoding> {

}

@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *myCityInterestId;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *locationsId;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSArray *projects;

@property(nonatomic,strong)NSString *beacon;

+ (MyCityInterest *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
