//
//  NSMutableAttributedString+AppendStringWithFormat.m
//  CommandPost
//
//  Created by Brendan Lee on 2/6/14.
//  Copyright (c) 2014 52apps. All rights reserved.
//

#import "NSMutableAttributedString+AppendStringWithFormat.h"

@implementation NSMutableAttributedString (AppendStringWithFormat)

-(void)appendString:(NSString*)string withAttributes:(NSDictionary *)attributes
{
    NSAttributedString *newString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    
    [self appendAttributedString:newString];
}

@end
