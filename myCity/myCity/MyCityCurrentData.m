//
//  MyCityCurrentData.m
//  
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 52apps. All rights reserved.
//

#import "MyCityCurrentData.h"

#import "MyCityLocation.h"

@implementation MyCityCurrentData

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.errorDetail forKey:@"errorDetail"];
    [encoder encodeObject:self.errorReadable forKey:@"errorReadable"];
    [encoder encodeObject:self.locations forKey:@"locations"];
    [encoder encodeObject:self.status forKey:@"status"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.errorDetail = [decoder decodeObjectForKey:@"errorDetail"];
        self.errorReadable = [decoder decodeObjectForKey:@"errorReadable"];
        self.locations = [decoder decodeObjectForKey:@"locations"];
        self.status = [decoder decodeObjectForKey:@"status"];
    }
    return self;
}

+ (MyCityCurrentData *)instanceFromDictionary:(NSDictionary *)aDictionary
{

    MyCityCurrentData *instance = [[MyCityCurrentData alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary
{

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.errorDetail = [aDictionary objectForKey:@"error_detail"];
    self.errorReadable = [aDictionary objectForKey:@"error_readable"];

    NSArray *receivedLocations = [aDictionary objectForKey:@"locations"];
    if ([receivedLocations isKindOfClass:[NSArray class]]) {

        NSMutableArray *populatedLocations = [NSMutableArray arrayWithCapacity:[receivedLocations count]];
        for (NSDictionary *item in receivedLocations) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [populatedLocations addObject:[MyCityLocation instanceFromDictionary:item]];
            }
        }

        self.locations = populatedLocations;

    }
    self.status = [aDictionary objectForKey:@"status"];

}

- (NSDictionary *)dictionaryRepresentation
{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    if (self.errorDetail) {
        [dictionary setObject:self.errorDetail forKey:@"errorDetail"];
    }

    if (self.errorReadable) {
        [dictionary setObject:self.errorReadable forKey:@"errorReadable"];
    }

    if (self.locations) {
        [dictionary setObject:self.locations forKey:@"locations"];
    }

    if (self.status) {
        [dictionary setObject:self.status forKey:@"status"];
    }

    return dictionary;

}

@end
