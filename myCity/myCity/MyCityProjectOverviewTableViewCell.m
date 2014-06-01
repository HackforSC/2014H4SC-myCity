//
//  MyCityProjectOverviewTableViewCell.m
//  myCity
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 myCity. All rights reserved.
//

#import "MyCityProjectOverviewTableViewCell.h"
#import "NSMutableAttributedString+AppendStringWithFormat.h"
#import "FTCustomDrawView.h"

@interface MyCityProjectOverviewTableViewCell ()

@property(nonatomic,strong)UILabel *totalCashBalanceLabel;
@property(nonatomic,strong)UILabel *backersLabel;
@property(nonatomic,strong)UILabel *projectTitleLabel;
@property(nonatomic,strong)FTCustomDrawView *barGraphView;
@property(nonatomic,strong)FTCustomDrawView *backgroundColorView;

@property(nonatomic,strong)UILabel *youBackedThisLabel;

@end

@implementation MyCityProjectOverviewTableViewCell

#define ProjectOverviewCellTitleFont  [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0]
#define ProjectOverviewDataHeaderFont  [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]
#define ProjectOverviewDataSubtitleFont  [UIFont fontWithName:@"HelveticaNeue-Thin" size:14.0]

#define ProjectOverviewDataHeaderColor [UIColor myCityDarkTextColor]
#define ProjectOverviewDataSubtitleColor [UIColor lightGrayColor]

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _backgroundColorView = [[FTCustomDrawView alloc] init];
        _backgroundColorView.backgroundColor = [UIColor whiteColor];
        [_backgroundColorView setCustomDrawBlock:^(CGRect rect, UIView *view)
        {
            [[UIColor myCityPanelDarkenedBackgroundColor] set];
            
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, 1.0);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), rect.size.width, 1.0);
            
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, rect.size.height-1.0);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), rect.size.width, rect.size.height-1.0);
            CGContextStrokePath(UIGraphicsGetCurrentContext());

        }];
        
        _projectMastHead = [[UIImageView alloc] init];
        _projectMastHead.contentMode = UIViewContentModeScaleAspectFill;
        _projectMastHead.clipsToBounds = YES;
        
        _projectTitleLabel = [[UILabel alloc] init];
        _projectTitleLabel.textAlignment = NSTextAlignmentCenter;
        _projectTitleLabel.numberOfLines = 0;
        
        _totalCashBalanceLabel = [[UILabel alloc] init];
        _totalCashBalanceLabel.numberOfLines = 0;
        
        _backersLabel = [[UILabel alloc] init];
        _backersLabel.numberOfLines = 0;
        
        _youBackedThisLabel = [[UILabel alloc] init];
        _youBackedThisLabel.text = @"✓ You've backed this!";
        _youBackedThisLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        _youBackedThisLabel.textColor = ProjectOverviewDataHeaderColor;
        _youBackedThisLabel.hidden = YES;
        
        __weak MyCityProjectOverviewTableViewCell *weakCell = self;
        
        _barGraphView = [[FTCustomDrawView alloc] init];
        _barGraphView.backgroundColor = [UIColor clearColor];
        [_barGraphView setCustomDrawBlock:^(CGRect rect, UIView *view){
            
            //Compute user percentage to show
            [[UIColor myCityGreenColor] set];
            UIBezierPath *totalPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(1, 1, (rect.size.width-2) * (((float)[weakCell totalCashRaised])/((float)[weakCell totalCashAmount])), 8) cornerRadius: 4];
            [totalPath fill];
            
            [[UIColor myCityOrangeColor] set];
            UIBezierPath *totalMinusPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(1, 1, (rect.size.width-2) * ((((float)[weakCell totalCashRaised])-((float)[weakCell userCashRaised]))/((float)[weakCell totalCashAmount])), 8) cornerRadius: 4];

            [totalMinusPath fill];
            
            [[UIColor myCityPanelDarkenedBackgroundColor] set];
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0/[[UIScreen mainScreen] scale]);
            UIBezierPath* backgroundPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(1, 1, rect.size.width-2, 8) cornerRadius: 4];
            [backgroundPath stroke];
        }];
        
        [self.contentView addSubview:_backgroundColorView];
        
        [self.contentView addSubview:_projectMastHead];
        [self.contentView addSubview:_projectTitleLabel];
        [self.contentView addSubview:_totalCashBalanceLabel];
        [self.contentView addSubview:_backersLabel];
        [self.contentView addSubview:_barGraphView];
        [self.contentView addSubview:_youBackedThisLabel];
        
        self.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _backgroundColorView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, 374);
    
    _projectMastHead.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, 240.0);
    
    _projectTitleLabel.frame = CGRectMake(22, 240.0, self.contentView.bounds.size.width-44.0, 66.0);
    
    _totalCashBalanceLabel.frame = CGRectMake(22.0, 314, 130.0, 60.0);
    
    _backersLabel.frame = CGRectMake(22.0+130.0+22.0, 314, 130.0, 60.0);
    
    _youBackedThisLabel.frame = CGRectMake(22.0, 374.0, self.contentView.bounds.size.width-44.0, 22.0);
    
    _barGraphView.frame = CGRectMake(20.0, 304.0, self.contentView.bounds.size.width-42.0, 12.0);
    [_barGraphView setNeedsDisplay];
    
//    CGRect titleLabelSize = [_projectTitleLabel.attributedText boundingRectWithSize:CGSizeMake(self.contentView.bounds.size.width, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//    
//    CGRect totalCashBalanceLabelSize = [_totalCashBalanceLabel.attributedText boundingRectWithSize:CGSizeMake(65.0, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//    
//    CGRect backersLabelSize = [_backersLabel.attributedText boundingRectWithSize:CGSizeMake(65.0, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if (selected && !_blockHighlight) {
        _backgroundColorView.backgroundColor = [UIColor myCityPanelBackgroundColor];
    }
    else
    {
        _backgroundColorView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    // Configure the view for the selected state
    
    if (highlighted && !_blockHighlight) {
        _backgroundColorView.backgroundColor = [UIColor myCityPanelBackgroundColor];
    }
    else
    {
        _backgroundColorView.backgroundColor = [UIColor whiteColor];
    }
}

-(void)setTotalBackers:(int)totalBackers
{
    _totalBackers = totalBackers;
    
    NSMutableAttributedString *displayString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d\n", _totalBackers] attributes:@{NSForegroundColorAttributeName: ProjectOverviewDataHeaderColor, NSFontAttributeName : ProjectOverviewDataHeaderFont}];
    
    [displayString appendString:@"backers" withAttributes:@{NSFontAttributeName: ProjectOverviewDataSubtitleFont, NSForegroundColorAttributeName : ProjectOverviewDataSubtitleColor}];
    
    _backersLabel.attributedText = displayString;
    
    [_barGraphView setNeedsDisplay];
}

-(void)setTotalCashAmount:(int)totalCashAmount
{
    _totalCashAmount = totalCashAmount;
    
    NSMutableAttributedString *displayString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%d US\n", _totalCashRaised] attributes:@{NSForegroundColorAttributeName: ProjectOverviewDataHeaderColor, NSFontAttributeName : ProjectOverviewDataHeaderFont}];
    
    [displayString appendString:[NSString stringWithFormat:@"pledged of $%d", _totalCashAmount] withAttributes:@{NSFontAttributeName: ProjectOverviewDataSubtitleFont, NSForegroundColorAttributeName : ProjectOverviewDataSubtitleColor}];
    
    _totalCashBalanceLabel.attributedText = displayString;
    
    [_barGraphView setNeedsDisplay];
}

-(void)setTotalCashRaised:(int)totalCashRaised
{
    _totalCashRaised = totalCashRaised;
    
    NSMutableAttributedString *displayString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%d US\n", _totalCashRaised] attributes:@{NSForegroundColorAttributeName: ProjectOverviewDataHeaderColor, NSFontAttributeName : ProjectOverviewDataHeaderFont}];
    
    [displayString appendString:[NSString stringWithFormat:@"pledged of $%d", _totalCashAmount] withAttributes:@{NSFontAttributeName: ProjectOverviewDataSubtitleFont, NSForegroundColorAttributeName : ProjectOverviewDataSubtitleColor}];
    
    _totalCashBalanceLabel.attributedText = displayString;
    
    [_barGraphView setNeedsDisplay];
}

-(void)setProjectTitle:(NSString *)projectTitle
{
    _projectTitle = projectTitle;
    
    _projectTitleLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:_projectTitle attributes:@{NSForegroundColorAttributeName : ProjectOverviewDataHeaderColor, NSFontAttributeName : ProjectOverviewCellTitleFont}];
}

-(void)setUserCashRaised:(int)userCashRaised
{
    _userCashRaised = userCashRaised;
    [_barGraphView setNeedsDisplay];
    
    if (_userCashRaised > 0.001) {
        _youBackedThisLabel.hidden = NO;
    }
    else
    {
        _youBackedThisLabel.hidden = YES;
    }

}

-(void)setNeedsDisplay
{
    [super setNeedsDisplay];
    
    [_barGraphView setNeedsDisplay];
}
@end
