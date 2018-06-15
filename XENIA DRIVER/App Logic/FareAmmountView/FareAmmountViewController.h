//
//  FareAmmountViewController.h
//  TaxiDriver
//
//  Created by  CoolDev on 29/05/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripModel.h"
#import "ConstantModel.h"

@interface FareAmmountViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lblFareAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblDriverCommision;
@property (strong, nonatomic) TripModel *curr_trip;
@property (strong, nonatomic) ConstantModel *constantModel;
@property (strong, nonatomic) IBOutlet UIButton *btnFarereview;
@property (strong, nonatomic) IBOutlet UIButton *btnHome;
@property (strong, nonatomic) IBOutlet UIButton *btnOffline;
@property (strong, nonatomic) IBOutlet UILabel *lblPromoAmount;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblHireMeCard;
@property (strong, nonatomic) IBOutlet UILabel *lblDriverAmountTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblAmountCollectedTitle;

@end
