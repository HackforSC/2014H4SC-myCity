//
//  MyCityTag.h
//  
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 52apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCityTag : NSObject <NSCoding> {

}

@property (nonatomic, strong) NSString *projectsId;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *myCityTagId;
@property (nonatomic, strong) NSString *timeStamp;

+ (MyCityTag *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
