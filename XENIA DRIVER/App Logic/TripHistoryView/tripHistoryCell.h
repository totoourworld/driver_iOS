//
//  tripHistoryCell.h
//  TaxiDriver
//
//  Created by  CoolDev on 29/05/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripModel.h"
#import "ConstantModel.h"

@interface tripHistoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgRider;
@property (weak, nonatomic) IBOutlet UIImageView *imgCar;
@property (strong, nonatomic) IBOutlet UILabel *lblriderName;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblAmmount;
@property (weak, nonatomic) IBOutlet UILabel *lbPickUpAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbDropUpAddress;
-(void)setdataWithTripModel:(TripModel *)tripModel;
@property(nonatomic,strong) ConstantModel *constantModel;

@end
