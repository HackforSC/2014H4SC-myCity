//
//  FTCustomDrawView.h
//
//  Created by Brendan Lee on 1/1/14.
//  Copyright (c) 2014 52apps. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CustomDrawBlock)(CGRect rect, UIView *view);

@interface FTCustomDrawView : UIView

@property(nonatomic,strong)CustomDrawBlock customDrawBlock;
@end
