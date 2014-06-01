//
//  MyCityUser.m
//  
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 52apps. All rights reserved.
//

#import "MyCityUser.h"

@implementation MyCityUser

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.accessKey forKey:@"accessKey"];
    [encoder encodeObject:self.emailAddress forKey:@"emailAddress"];
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.myCityUserId forKey:@"myCityUserId"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.profileUrl forKey:@"profileUrl"];
    [encoder encodeObject:self.timeStamp forKey:@"timeStamp"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.accessKey = [decoder decodeObjectForKey:@"accessKey"];
        self.emailAddress = [decoder decodeObjectForKey:@"emailAddress"];
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.myCityUserId = [decoder decodeObjectForKey:@"myCityUserId"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.profileUrl = [decoder decodeObjectForKey:@"profileUrl"];
        self.timeStamp = [decoder decodeObjectForKey:@"timeStamp"];
    }
    return self;
}

+ (MyCityUser *)instanceFromDictionary:(NSDictionary *)aDictionary
{

    MyCityUser *instance = [[MyCityUser alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary
{

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.accessKey = [aDictionary objectForKey:@"access_key"];
    self.emailAddress = [aDictionary objectForKey:@"email_address"];
    self.firstName = [aDictionary objectForKey:@"first_name"];
    self.myCityUserId = [aDictionary objectForKey:@"id"];
    self.lastName = [aDictionary objectForKey:@"last_name"];
    self.profileUrl = [aDictionary objectForKey:@"profile_url"];
    self.timeStamp = [aDictionary objectForKey:@"time_stamp"];

}

- (NSDictionary *)dictionaryRepresentation
{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    if (self.accessKey) {
        [dictionary setObject:self.accessKey forKey:@"accessKey"];
    }

    if (self.emailAddress) {
        [dictionary setObject:self.emailAddress forKey:@"emailAddress"];
    }

    if (self.firstName) {
        [dictionary setObject:self.firstName forKey:@"firstName"];
    }

    if (self.myCityUserId) {
        [dictionary setObject:self.myCityUserId forKey:@"myCityUserId"];
    }

    if (self.lastName) {
        [dictionary setObject:self.lastName forKey:@"lastName"];
    }

    if (self.profileUrl) {
        [dictionary setObject:self.profileUrl forKey:@"profileUrl"];
    }

    if (self.timeStamp) {
        [dictionary setObject:self.timeStamp forKey:@"timeStamp"];
    }

    return dictionary;

}

@end
