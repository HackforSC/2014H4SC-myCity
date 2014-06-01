//
//  MyCityTag.m
//  
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 52apps. All rights reserved.
//

#import "MyCityTag.h"

@implementation MyCityTag

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.projectsId forKey:@"projectsId"];
    [encoder encodeObject:self.tag forKey:@"tag"];
    [encoder encodeObject:self.myCityTagId forKey:@"myCityTagId"];
    [encoder encodeObject:self.timeStamp forKey:@"timeStamp"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.projectsId = [decoder decodeObjectForKey:@"projectsId"];
        self.tag = [decoder decodeObjectForKey:@"tag"];
        self.myCityTagId = [decoder decodeObjectForKey:@"myCityTagId"];
        self.timeStamp = [decoder decodeObjectForKey:@"timeStamp"];
    }
    return self;
}

+ (MyCityTag *)instanceFromDictionary:(NSDictionary *)aDictionary
{

    MyCityTag *instance = [[MyCityTag alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary
{

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.projectsId = [aDictionary objectForKey:@"Projects_id"];
    self.tag = [aDictionary objectForKey:@"tag"];
    self.myCityTagId = [aDictionary objectForKey:@"id"];
    self.timeStamp = [aDictionary objectForKey:@"time_stamp"];

}

- (NSDictionary *)dictionaryRepresentation
{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    if (self.projectsId) {
        [dictionary setObject:self.projectsId forKey:@"projectsId"];
    }

    if (self.tag) {
        [dictionary setObject:self.tag forKey:@"tag"];
    }

    if (self.myCityTagId) {
        [dictionary setObject:self.myCityTagId forKey:@"myCityTagId"];
    }

    if (self.timeStamp) {
        [dictionary setObject:self.timeStamp forKey:@"timeStamp"];
    }

    return dictionary;

}

@end
