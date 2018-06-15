//
//  SideMenuCell.h
//  Store_project
//
//  Created by  CoolDev on 22/02/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblMenu;
@property (strong, nonatomic) IBOutlet UIView *viewMenuBG;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *MenuBgtopConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *MenuBgHeightConstraints;
@property (strong, nonatomic) IBOutlet UIImageView *imgIcon;
@property (strong, nonatomic) IBOutlet UIView *viewSeparator;

@end
