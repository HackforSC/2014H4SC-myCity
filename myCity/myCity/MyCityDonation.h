//
//  MyCityDonation.h
//  
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 52apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCityDonation : NSObject <NSCoding> {

}

@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *myCityDonationId;
@property (nonatomic, strong) NSString *projectsId;
@property (nonatomic, strong) NSString *timeStamp;
@property (nonatomic, strong) NSString *userId;

+ (MyCityDonation *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
