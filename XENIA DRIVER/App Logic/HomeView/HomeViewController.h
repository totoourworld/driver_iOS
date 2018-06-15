//
//  HomeViewController.h
//  Store_project
//
//  Created by  CoolDev on 22/05/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CategoryModel.h"

@interface HomeViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UIView *progressBgView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *lblProgressTime;
@property (strong, nonatomic) IBOutlet UIView *addressViewTop;
@property (strong, nonatomic) IBOutlet UIView *acceptDeclineView;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnAccept;
@property (strong, nonatomic) IBOutlet UIButton *btnDecline;
@property (strong, nonatomic) IBOutlet UIView *timeDistanceView;
@property (strong, nonatomic) IBOutlet UILabel *lblEstimatedTime;
@property (strong, nonatomic) IBOutlet UILabel *lblEstimatedDistance;
@property (strong, nonatomic) IBOutlet UILabel *lblAcceptTitle;
@property (strong, nonatomic) IBOutlet UIView *addressBgView;
@property (strong, nonatomic) IBOutlet UIView *viewMessage;
@property (strong, nonatomic) IBOutlet UITextView *txtViewMessage;
@property (strong, nonatomic) IBOutlet UIView *goPopUpView;

@property (strong,nonatomic) MKPlacemark *source;
@property (strong, nonatomic) MKPlacemark *destination;
@property (strong, nonatomic) IBOutlet UIButton *btnGoPopUP;
@property (strong, nonatomic) IBOutlet UIView *timerBgBottomView;
@property (strong, nonatomic) IBOutlet UILabel *lblExpectedTime;
@property (strong, nonatomic) IBOutlet UILabel *lblExpectedDistance;
@property (strong, nonatomic) IBOutlet UILabel *lblExpArrivaltime;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *goPopUpViewBottomConstraints;
@property (strong, nonatomic) IBOutlet UILabel *lblAddressTop;
@property (strong, nonatomic) IBOutlet UILabel *lblLocationTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnBeginTrip;
@property(strong,nonatomic) CategoryModel * carCategory;
@property (strong, nonatomic) IBOutlet UIView *viewStatusBar;
@property (strong, nonatomic) IBOutlet UILabel *lblWhyNot;
@property (strong, nonatomic) IBOutlet UIButton *btnOK;

@end
