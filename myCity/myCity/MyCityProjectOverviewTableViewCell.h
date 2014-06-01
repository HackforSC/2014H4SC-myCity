//
//  MyCityProjectOverviewTableViewCell.h
//  myCity
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 myCity. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MyCityProjectOverviewCellHeight 450.0

@interface MyCityProjectOverviewTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *projectMastHead;
@property(nonatomic,strong)NSString *projectTitle;

@property(nonatomic,assign)int totalCashAmount;
@property(nonatomic,assign)int totalCashRaised;
@property(nonatomic,assign)int userCashRaised;
@property(nonatomic,assign)int totalBackers;

@property(nonatomic,assign)BOOL blockHighlight;

@end
