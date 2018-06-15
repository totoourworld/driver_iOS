//
//  TripHistoryViewController.h
//  TaxiDriver
//
//  Created by  CoolDev on 24/05/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripHistoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *lblNoRec;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;

@end
