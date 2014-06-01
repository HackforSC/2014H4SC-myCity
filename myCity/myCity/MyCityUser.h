//
//  MyCityUser.h
//  
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 52apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCityUser : NSObject <NSCoding> {

}

@property (nonatomic, strong) NSString *accessKey;
@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *myCityUserId;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *profileUrl;
@property (nonatomic, strong) NSString *timeStamp;

+ (MyCityUser *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
