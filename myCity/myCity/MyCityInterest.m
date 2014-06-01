//
//  MyCityInterest.m
//  
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 52apps. All rights reserved.
//

#import "MyCityInterest.h"

#import "MyCityProject.h"

@implementation MyCityInterest

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.descriptionText forKey:@"descriptionText"];
    [encoder encodeObject:self.myCityInterestId forKey:@"myCityInterestId"];
    [encoder encodeObject:self.lat forKey:@"lat"];
    [encoder encodeObject:self.locationsId forKey:@"locationsId"];
    [encoder encodeObject:self.lon forKey:@"long"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.photoUrl forKey:@"photoUrl"];
    [encoder encodeObject:self.projects forKey:@"projects"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.descriptionText = [decoder decodeObjectForKey:@"descriptionText"];
        self.myCityInterestId = [decoder decodeObjectForKey:@"myCityInterestId"];
        self.lat = [decoder decodeObjectForKey:@"lat"];
        self.locationsId = [decoder decodeObjectForKey:@"locationsId"];
        self.lon = [decoder decodeObjectForKey:@"long"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.photoUrl = [decoder decodeObjectForKey:@"photoUrl"];
        self.projects = [decoder decodeObjectForKey:@"projects"];
    }
    return self;
}

+ (MyCityInterest *)instanceFromDictionary:(NSDictionary *)aDictionary
{

    MyCityInterest *instance = [[MyCityInterest alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary
{

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.descriptionText = [aDictionary objectForKey:@"description"];
    self.myCityInterestId = [aDictionary objectForKey:@"id"];
    self.lat = [aDictionary objectForKey:@"lat"];
    self.locationsId = [aDictionary objectForKey:@"Locations_id"];
    self.lon = [aDictionary objectForKey:@"long"];
    self.name = [aDictionary objectForKey:@"name"];
    self.photoUrl = [aDictionary objectForKey:@"photo_url"];
    self.beacon = [aDictionary objectForKey:@"beacons"];

    NSArray *receivedProjects = [aDictionary objectForKey:@"projects"];
    if ([receivedProjects isKindOfClass:[NSArray class]]) {

        NSMutableArray *populatedProjects = [NSMutableArray arrayWithCapacity:[receivedProjects count]];
        for (NSDictionary *item in receivedProjects) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [populatedProjects addObject:[MyCityProject instanceFromDictionary:item]];
            }
        }

        self.projects = populatedProjects;

    }

}

- (NSDictionary *)dictionaryRepresentation
{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    if (self.descriptionText) {
        [dictionary setObject:self.descriptionText forKey:@"descriptionText"];
    }

    if (self.myCityInterestId) {
        [dictionary setObject:self.myCityInterestId forKey:@"myCityInterestId"];
    }

    if (self.lat) {
        [dictionary setObject:self.lat forKey:@"lat"];
    }

    if (self.locationsId) {
        [dictionary setObject:self.locationsId forKey:@"locationsId"];
    }

    if (self.lon) {
        [dictionary setObject:self.lon forKey:@"long"];
    }

    if (self.name) {
        [dictionary setObject:self.name forKey:@"name"];
    }

    if (self.photoUrl) {
        [dictionary setObject:self.photoUrl forKey:@"photoUrl"];
    }

    if (self.projects) {
        [dictionary setObject:self.projects forKey:@"projects"];
    }

    return dictionary;

}

@end
