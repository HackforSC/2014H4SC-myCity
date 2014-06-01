//
//  MyCityCurrentData.h
//  
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 52apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCityCurrentData : NSObject <NSCoding> {

}

@property (nonatomic, strong) NSString *errorDetail;
@property (nonatomic, strong) NSString *errorReadable;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) NSString *status;

+ (MyCityCurrentData *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
