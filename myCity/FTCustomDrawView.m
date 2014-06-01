//
//  FTCustomDrawView.m
//
//
//  Created by Brendan Lee on 1/1/14.
//  Copyright (c) 2014 52apps. All rights reserved.
//

#import "FTCustomDrawView.h"

@implementation FTCustomDrawView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    if (self.customDrawBlock) {
        self.customDrawBlock(rect, self);
    }
}

-(void)dealloc
{
    self.customDrawBlock = nil;
}


@end
