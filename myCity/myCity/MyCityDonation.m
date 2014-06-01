//
//  MyCityDonation.m
//  
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 52apps. All rights reserved.
//

#import "MyCityDonation.h"

@implementation MyCityDonation

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.amount forKey:@"amount"];
    [encoder encodeObject:self.myCityDonationId forKey:@"myCityDonationId"];
    [encoder encodeObject:self.projectsId forKey:@"projectsId"];
    [encoder encodeObject:self.timeStamp forKey:@"timeStamp"];
    [encoder encodeObject:self.userId forKey:@"userId"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.amount = [decoder decodeObjectForKey:@"amount"];
        self.myCityDonationId = [decoder decodeObjectForKey:@"myCityDonationId"];
        self.projectsId = [decoder decodeObjectForKey:@"projectsId"];
        self.timeStamp = [decoder decodeObjectForKey:@"timeStamp"];
        self.userId = [decoder decodeObjectForKey:@"userId"];
    }
    return self;
}

+ (MyCityDonation *)instanceFromDictionary:(NSDictionary *)aDictionary
{

    MyCityDonation *instance = [[MyCityDonation alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary
{

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.amount = [aDictionary objectForKey:@"amount"];
    self.myCityDonationId = [aDictionary objectForKey:@"id"];
    self.projectsId = [aDictionary objectForKey:@"projects_id"];
    self.timeStamp = [aDictionary objectForKey:@"time_stamp"];
    self.userId = [aDictionary objectForKey:@"user_id"];

}

- (NSDictionary *)dictionaryRepresentation
{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    if (self.amount) {
        [dictionary setObject:self.amount forKey:@"amount"];
    }

    if (self.myCityDonationId) {
        [dictionary setObject:self.myCityDonationId forKey:@"myCityDonationId"];
    }

    if (self.projectsId) {
        [dictionary setObject:self.projectsId forKey:@"projectsId"];
    }

    if (self.timeStamp) {
        [dictionary setObject:self.timeStamp forKey:@"timeStamp"];
    }

    if (self.userId) {
        [dictionary setObject:self.userId forKey:@"userId"];
    }

    return dictionary;

}

@end
