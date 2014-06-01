//
//  MyCityProject.m
//  
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 52apps. All rights reserved.
//

#import "MyCityProject.h"

#import "MyCityDonation.h"
#import "MyCityTag.h"

@implementation MyCityProject

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.descriptionText forKey:@"descriptionText"];
    [encoder encodeObject:self.donations forKey:@"donations"];
    [encoder encodeObject:self.goalAmount forKey:@"goalAmount"];
    [encoder encodeObject:self.interestsId forKey:@"interestsId"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.photoUrl forKey:@"photoUrl"];
    [encoder encodeObject:self.myCityProjectId forKey:@"myCityProjectId"];
    [encoder encodeObject:self.tags forKey:@"tags"];
    [encoder encodeObject:self.totalDonations forKey:@"totalDonations"];
    [encoder encodeObject:self.userDonations forKey:@"userDonations"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.descriptionText = [decoder decodeObjectForKey:@"descriptionText"];
        self.donations = [decoder decodeObjectForKey:@"donations"];
        self.goalAmount = [decoder decodeObjectForKey:@"goalAmount"];
        self.interestsId = [decoder decodeObjectForKey:@"interestsId"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.photoUrl = [decoder decodeObjectForKey:@"photoUrl"];
        self.myCityProjectId = [decoder decodeObjectForKey:@"myCityProjectId"];
        self.tags = [decoder decodeObjectForKey:@"tags"];
        self.totalDonations = [decoder decodeObjectForKey:@"totalDonations"];
        self.userDonations = [decoder decodeObjectForKey:@"userDonations"];
    }
    return self;
}

+ (MyCityProject *)instanceFromDictionary:(NSDictionary *)aDictionary
{

    MyCityProject *instance = [[MyCityProject alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary
{

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.descriptionText = [aDictionary objectForKey:@"description"];

    NSArray *receivedDonations = [aDictionary objectForKey:@"donations"];
    if ([receivedDonations isKindOfClass:[NSArray class]]) {

        NSMutableArray *populatedDonations = [NSMutableArray arrayWithCapacity:[receivedDonations count]];
        for (NSDictionary *item in receivedDonations) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [populatedDonations addObject:[MyCityDonation instanceFromDictionary:item]];
            }
        }

        self.donations = populatedDonations;

    }
    self.goalAmount = [aDictionary objectForKey:@"goal_amount"];
    self.interestsId = [aDictionary objectForKey:@"Interests_id"];
    self.name = [aDictionary objectForKey:@"name"];
    self.photoUrl = [aDictionary objectForKey:@"photo_url"];
    self.myCityProjectId = [aDictionary objectForKey:@"id"];
    self.backerCount = [aDictionary objectForKey:@"total_backers"];

    NSArray *receivedTags = [aDictionary objectForKey:@"tags"];
    if ([receivedTags isKindOfClass:[NSArray class]]) {

        NSMutableArray *populatedTags = [NSMutableArray arrayWithCapacity:[receivedTags count]];
        for (NSDictionary *item in receivedTags) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [populatedTags addObject:[MyCityTag instanceFromDictionary:item]];
            }
        }

        self.tags = populatedTags;

    }
    self.totalDonations = [aDictionary objectForKey:@"total_donations"];
    self.userDonations = [aDictionary objectForKey:@"user_donations"];

}

- (NSDictionary *)dictionaryRepresentation
{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    if (self.descriptionText) {
        [dictionary setObject:self.descriptionText forKey:@"descriptionText"];
    }

    if (self.donations) {
        [dictionary setObject:self.donations forKey:@"donations"];
    }

    if (self.goalAmount) {
        [dictionary setObject:self.goalAmount forKey:@"goalAmount"];
    }

    if (self.interestsId) {
        [dictionary setObject:self.interestsId forKey:@"interestsId"];
    }

    if (self.name) {
        [dictionary setObject:self.name forKey:@"name"];
    }

    if (self.photoUrl) {
        [dictionary setObject:self.photoUrl forKey:@"photoUrl"];
    }

    if (self.myCityProjectId) {
        [dictionary setObject:self.myCityProjectId forKey:@"myCityProjectId"];
    }

    if (self.tags) {
        [dictionary setObject:self.tags forKey:@"tags"];
    }

    if (self.totalDonations) {
        [dictionary setObject:self.totalDonations forKey:@"totalDonations"];
    }

    if (self.userDonations) {
        [dictionary setObject:self.userDonations forKey:@"userDonations"];
    }

    return dictionary;

}

@end
