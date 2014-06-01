//
//  UIColor+AppStyles.h
//  myCity
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 myCity. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface UIColor (AppStyles)

+(UIColor*)myCityDarkTextColor;
+(UIColor*)myCityOrangeColor;
+(UIColor*)myCityPanelBackgroundColor;
+(UIColor*)myCityGreenColor;
+(UIColor*)myCityPanelDarkenedBackgroundColor;

@end
