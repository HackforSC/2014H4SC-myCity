//
//  ProjectDetailTableViewController.h
//  myCity
//
//  Created by Brendan Lee on 5/31/14.
//  Copyright (c) 2014 myCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectDetailTableViewController : UITableViewController<UIAlertViewDelegate>

@property(nonatomic,strong)MyCityProject *currentProject;
@end
