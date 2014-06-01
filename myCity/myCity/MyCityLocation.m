//
//  MyCityLocation.m
//  
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 52apps. All rights reserved.
//

#import "MyCityLocation.h"

#import "MyCityInterest.h"

@implementation MyCityLocation

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.descriptionText forKey:@"descriptionText"];
    [encoder encodeObject:self.interests forKey:@"interests"];
    [encoder encodeObject:self.lat forKey:@"lat"];
    [encoder encodeObject:self.myCityLocationId forKey:@"myCityLocationId"];
    [encoder encodeObject:self.lon forKey:@"long"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.photoUrl forKey:@"photoUrl"];
    [encoder encodeObject:self.state forKey:@"state"];
    [encoder encodeObject:self.streetAddress forKey:@"streetAddress"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.city = [decoder decodeObjectForKey:@"city"];
        self.descriptionText = [decoder decodeObjectForKey:@"descriptionText"];
        self.interests = [decoder decodeObjectForKey:@"interests"];
        self.lat = [decoder decodeObjectForKey:@"lat"];
        self.myCityLocationId = [decoder decodeObjectForKey:@"myCityLocationId"];
        self.lon = [decoder decodeObjectForKey:@"long"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.photoUrl = [decoder decodeObjectForKey:@"photoUrl"];
        self.state = [decoder decodeObjectForKey:@"state"];
        self.streetAddress = [decoder decodeObjectForKey:@"streetAddress"];
    }
    return self;
}

+ (MyCityLocation *)instanceFromDictionary:(NSDictionary *)aDictionary
{

    MyCityLocation *instance = [[MyCityLocation alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary
{

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.city = [aDictionary objectForKey:@"city"];
    self.descriptionText = [aDictionary objectForKey:@"description"];

    NSArray *receivedInterests = [aDictionary objectForKey:@"interests"];
    if ([receivedInterests isKindOfClass:[NSArray class]]) {

        NSMutableArray *populatedInterests = [NSMutableArray arrayWithCapacity:[receivedInterests count]];
        for (NSDictionary *item in receivedInterests) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [populatedInterests addObject:[MyCityInterest instanceFromDictionary:item]];
            }
        }

        self.interests = populatedInterests;

    }
    self.lat = [aDictionary objectForKey:@"lat"];
    self.myCityLocationId = [aDictionary objectForKey:@"id"];
    self.lon = [aDictionary objectForKey:@"long"];
    self.name = [aDictionary objectForKey:@"name"];
    self.photoUrl = [aDictionary objectForKey:@"photo_url"];
    self.state = [aDictionary objectForKey:@"state"];
    self.streetAddress = [aDictionary objectForKey:@"street_address"];

}

- (NSDictionary *)dictionaryRepresentation
{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    if (self.city) {
        [dictionary setObject:self.city forKey:@"city"];
    }

    if (self.descriptionText) {
        [dictionary setObject:self.descriptionText forKey:@"descriptionText"];
    }

    if (self.interests) {
        [dictionary setObject:self.interests forKey:@"interests"];
    }

    if (self.lat) {
        [dictionary setObject:self.lat forKey:@"lat"];
    }

    if (self.myCityLocationId) {
        [dictionary setObject:self.myCityLocationId forKey:@"myCityLocationId"];
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

    if (self.state) {
        [dictionary setObject:self.state forKey:@"state"];
    }

    if (self.streetAddress) {
        [dictionary setObject:self.streetAddress forKey:@"streetAddress"];
    }

    return dictionary;

}

@end
