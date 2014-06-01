//
//  NSMutableAttributedString+AppendStringWithFormat.h
//  CommandPost
//
//  Created by Brendan Lee on 2/6/14.
//  Copyright (c) 2014 52apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (AppendStringWithFormat)

-(void)appendString:(NSString*)string withAttributes:(NSDictionary *)attributes;

@end
