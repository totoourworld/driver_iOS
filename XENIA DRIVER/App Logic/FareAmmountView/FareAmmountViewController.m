//
//  FareAmmountViewController.m
//  TaxiDriver
//
//  Created by  Appicial on 29/05/17.
//  Copyright © 2017 Appicial. All rights reserved.
//

#import "FareAmmountViewController.h"
//#import "CallAPI.h"
#import "WebCallConstants.h"
#import <GrepixKit/GrepixKit.h>
#import "AppDelegate.h"
#import "RootViewController.h"
#import "FareReviewViewController.h"
#import "UpdateUserCurrentLocation.h"
#import "CategoryModel.h"




@interface FareAmmountViewController ()
{
    double driverComm;
    BOOL isPaid;
    NSTimer * timerGetTripDetail;
    BOOL isViewDisAppearCalled;
    NSMutableArray *arrCategory;
    CategoryModel *carCategory;
    
}

@end

@implementation FareAmmountViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // AppDelegate *delegate = APP_DELEGATE;
    [self setThemeConstants];
    NSArray * arrCateResponse=defaults_object(@"categoryResponse");
    if(arrCateResponse)
    {
        arrCategory=[CategoryModel parseResponse:arrCateResponse ];
    }
    
    
    float TripFare = [_curr_trip.trip_fare doubleValue];
    
    _lblFareAmt.text = [NSString stringWithFormat:@"%@%.02f",_constantModel.constant_currency,TripFare];
    
    driverComm = TripFare - TripFare*_constantModel.connstant_appicial_commission/100;
    
    _lblDriverCommision.text = [NSString stringWithFormat:@"%@%.02f",_constantModel.constant_currency, driverComm];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification) name:@"NotificationReceived" object:nil];
    
    [self getTripDetails:NO];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isViewDisAppearCalled=NO;
    
    
}
-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    isViewDisAppearCalled=YES;
    if(timerGetTripDetail)
    {
        [timerGetTripDetail  invalidate];
        timerGetTripDetail=nil;
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setThemeConstants{
    
    _viewHeader.backgroundColor = CONSTANT_THEME_COLOR1;
     _lblHeader.textColor =CONSTANT_TEXT_COLOR_HEADER;
    [_lblHeader setFont:FONTS_THEME_REGULAR(19)];
    [_lblHireMeCard setFont:FONTS_THEME_REGULAR(18)];
    [_lblDriverAmountTitle setFont:FONTS_THEME_REGULAR(16)];
    [_lblDriverCommision setFont:FONTS_THEME_REGULAR(24)];
    [_lblAmountCollectedTitle setFont:FONTS_THEME_REGULAR(16)];
     [_lblFareAmt setFont:FONTS_THEME_REGULAR(24)];
     [_lblPromoAmount setFont:FONTS_THEME_REGULAR(13)];
    [_btnHome.titleLabel setFont:FONTS_THEME_REGULAR(16)];
     [_btnOffline.titleLabel setFont:FONTS_THEME_REGULAR(16)];
     [_btnFarereview.titleLabel setFont:FONTS_THEME_REGULAR(16)];
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"FareReviewViewController"]) {
        
        FareReviewViewController *farerev =(FareReviewViewController *)[segue destinationViewController];
        farerev.cur_trip =_curr_trip;
    }
}


-(void)getNotification {
    
    AppDelegate *appdelegate =APP_DELEGATE;
    
    if ( [appdelegate.trip_status isEqualToString:CASH_PAY] || [appdelegate.trip_status isEqualToString:PAYPAL_PAY] || [appdelegate.trip_status isEqualToString:PROMO_PAY_ACCEPT]) {
        
        if (timerGetTripDetail && timerGetTripDetail.isValid) {
            [timerGetTripDetail invalidate];
            timerGetTripDetail=nil;
        }
        if (!isPaid) {
            
            [self getTripDetails:YES];
            
        }
        
        
    }
}

-(void)getTripDetails:(BOOL) Showloader{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                
                                                                                @"trip_id" :_curr_trip.trip_Id,
                                                                                
                                                                                
                                                                                }];
    
    if (Showloader) {
        
        [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    }
    
    
    [APP_CallAPI gcURL:BASE_URL_DRIVER app:TRIP_GETTRIP
                  data:dict
     isShowErrorAlert:NO
       completionBlock:^(id results, NSError *error) {
           if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
               // success
               
               _curr_trip = [[TripModel alloc] initItemWithDict:[[results objectForKey:P_RESPONSE]objectAtIndex:0]];
               
               if ([_curr_trip.trip_pay_status isEqualToString:TS_PAID]) {
                   
                   
                   
                   isPaid =YES;
                   
                   if ([_curr_trip.trip_promo_amt doubleValue] >0) {
                       
                       
                       
                       double amt = [_curr_trip.trip_fare doubleValue] - [_curr_trip.trip_promo_amt doubleValue];
                       
                       if (amt<=0) {
                           
                           _lblFareAmt.text = [NSString stringWithFormat:@"%@0.0",_constantModel.constant_currency];
                           _lblPromoAmount.hidden =YES;
                       }
                       else{
                           
                           _lblFareAmt.text =[NSString stringWithFormat:@"%@%.02f", _constantModel.constant_currency,amt];
                           
                           [_lblPromoAmount setText:[NSString stringWithFormat:@"%@ %@%.2f",NSLocalizedString(@"Promo Code Applied:", @""),_constantModel.constant_currency,[self.curr_trip.trip_promo_amt doubleValue]]];
                           _lblPromoAmount.hidden =NO;
                       }
                   }
                   
                   if ([_curr_trip.trip_pay_mode isEqualToString:PAYPAL_PAY]) {
                       
                       UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                                message:NSLocalizedString(@"MESSAGE_PAYPAL", @"")
                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                       
                       //
                       
                       //We add buttons to the alert controller by creating UIAlertActions:
                       UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                                          style:UIAlertActionStyleDefault
                                                                        handler:^(UIAlertAction * action) {
                                                                            //Handle your yes please button action here
                                                                            [self sendNotification];
                                                                            [self updatePaymentAmmount];
                                                                            
                                                                        }];
                       
                       [alertController addAction:actionOk];
                       [self presentViewController:alertController animated:YES completion:nil];
                       
                   }
                   else if ([_curr_trip.trip_pay_mode isEqualToString:CASH_PAY]){
                       
                       UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                                message:NSLocalizedString(@"MESSAGE_CASH", @"")
                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                       //We add buttons to the alert controller by creating UIAlertActions:
                       UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                                          style:UIAlertActionStyleDefault
                                                                        handler:^(UIAlertAction * action) {
                                                                            //Handle your yes please button action here
                                                                            [self sendNotification];
                                                                            [self updatePaymentAmmount];
                                                                            
                                                                        }];
                       
                       [alertController addAction:actionOk];
                       [self presentViewController:alertController animated:YES completion:nil];
                   }
                    [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
               }
               else{
                   [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                   if ([_curr_trip.trip_promo_amt doubleValue] >0) {
                       
                       double amt = [_curr_trip.trip_fare doubleValue] - [_curr_trip.trip_promo_amt doubleValue];
                       
                       if (amt<=0) {
                           
                           _lblFareAmt.text = [NSString stringWithFormat:@"%@0.0",_constantModel.constant_currency];
                           _lblPromoAmount.hidden =YES;
                       }
                       else{
                           
                           _lblFareAmt.text =[NSString stringWithFormat:@"%@%.02f",_constantModel.constant_currency, amt];
                           [_lblPromoAmount setText:[NSString stringWithFormat:@"%@ %@%.2f",NSLocalizedString(@"Promo Code Applied:", @""),_constantModel.constant_currency,[self.curr_trip.trip_promo_amt doubleValue]]];
                           _lblPromoAmount.hidden =NO;
                       }
                   }
                   
                   if(!isViewDisAppearCalled)
                   {
                       timerGetTripDetail=[NSTimer scheduledTimerWithTimeInterval: 5.0 target: self selector: @selector(timerFired:) userInfo: @(NO) repeats: NO];
                   }
               }
           }
       }];
}

-(void)timerFired:(NSTimer *)sender {
    
    [self getTripDetails:[sender.userInfo boolValue]];
}

-(void)updatePaymentAmmount {
    
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                
                                                                                @"trip_driver_commision"        :[NSString stringWithFormat:@"%f",driverComm],
                                                                                @"trip_id"                      : _curr_trip.trip_Id,
                                                                                }];
    
    
    // [UtilityClass SetLoaderHidden:NO withTitle:@"Loading..."];
    
    [APP_CallAPI gcURL:BASE_URL_DRIVER app:TRIP_UPDATE
                  data:dict
         isShowErrorAlert:NO
       completionBlock:^(id results, NSError *error) {
           if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
               // success
               
               //currTrip = [[TripModel alloc] initItemWithDict:[results objectForKey:P_RESPONSE]];
               
               //[self unhideViews];
           }
           
           
           [self unhideViews];
           [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
           
       }];
}

-(void)sendNotification{
    
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"trip_id":_curr_trip.trip_Id,
                                                                                @"trip_status":@"Paid",
                                                                                @"message"          :NSLocalizedString(@"MESSAGE_PAID", @""),
                                                                                @"content-available":@"1",
                                                                                
                                                                                }];
    
    if ([_curr_trip.trip_user_device_type isEqualToString:@"ios"]) {
        
        [dict setObject:_curr_trip.trip_user_device_token forKey:@"ios"];
    }
    else{
        
        [dict setObject:_curr_trip.trip_user_device_token forKey:@"android"];
    }
    
    //[UtilityClass SetLoaderHidden:NO withTitle:@"Loading..."];
    
    [APP_CallAPI gcURL:url_notification app:send_user_notification
                  data:dict
     isShowErrorAlert:NO 
       completionBlock:^(id results, NSError *error) {
           if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
               
               NSLog(@"notification success");
               
           }
           
           // [UtilityClass SetLoaderHidden:YES withTitle:@"Loading..."];
           
       }];
    
    
}

-(void)unhideViews {
    NSString *driverStatus =TS_WAITING;
    defaults_set_object(DRIVER_STATUS, driverStatus);
    _btnHome.hidden=NO;
    _btnOffline.hidden=NO;
    _btnFarereview.hidden=NO;
}

- (IBAction)ButtonOffline:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:NSLocalizedString(@"offline_alert_message", @"")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes", @"")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          //Handle your yes please button action here
                                                          
                                                          [self updateDriverStatus];
                                                          
                                                      }];
    
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:NSLocalizedString(@"No", @"")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                         
                                                         
                                                         
                                                     }];
    
    [alertController addAction:actionYes];
    [alertController addAction:actionNo];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)ButtonFarereviewPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"FareReviewViewController" sender:nil];
}
- (IBAction)ButtonHome:(id)sender {
    
    [[UpdateUserCurrentLocation sharedInstance]  updateDriverAvailablity:@"1"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateDriverStatus{
    
    //[[UpdateUserCurrentLocation sharedInstance]  updateDriverAvailablity:@"0"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"change_switch1" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    // [[NSUserDefaults standardUserDefaults]removeObjectForKey:P_API_KEY];
    // RootViewController *loginViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
    
    // UIWindow *window = UIApplication.sharedApplication.delegate.window;
    // window.rootViewController = loginViewController;
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
    
}



@end
