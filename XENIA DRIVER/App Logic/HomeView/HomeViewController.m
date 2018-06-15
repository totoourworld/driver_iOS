//
//  HomeViewController.m
//  Store_project
//
//  Created by  CoolDev on 22/05/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import <GrepixKit/GrepixKit.h>


#import "HomeViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "WebCallConstants.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "TripModel.h"
#import "AFHTTPRequestOperationManager.h"
#import "FareAmmountViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "UpdateUserCurrentLocation.h"
#import "GoogleDirectionSource.h"
#import "DirectionModel.h"
#import "ConstantModel.h"
#import "CategoryModel.h"
#import <CoreMotion/CoreMotion.h>
#import "CustomPointAnnotation.h"
#import "Utilities.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface HomeViewController ()
{
    double angle;
      AVAudioPlayer *audioPlayer;
    MKPointAnnotation *driverPin;
    TripModel *currTrip;
    NSTimer* progressTimer;
    
    int progCount;
    NSString *driverStatus;
    NSTimer* updateDriverTimer;
    NSTimer* nearbyTimer;
    NSTimer* timeDisTimer;
    NSTimer* timeTraveling;
    
    NSString *reasonString;
    
    NSString *distance;
    NSMutableArray *arrManeuver;
    BOOL isFirstLoad;
    CLLocation *lastLoc;
    NSArray * arrayAnotations;
    NSMutableArray * arraynearbyAnnotations;
    int apiCallAttempt;//, count;
    ConstantModel *constantTaxiModel;
    NSMutableArray *arrayCagetgory;
    BOOL StartLocationTaken;
    CLLocation *StartLocation,*CurrentLocation,*OldLocation,*NewLocaton;
    float TotalM,TotalTripDIstance;
    NSString *_activtiyNameDetactor;
    NSMutableArray *arrTravelledWayPoints;
    NSMutableArray *arrWayPoints;
    BOOL isTravelled;
    BOOL isFirstDis;
    NSMutableArray *arrTemp;
    CLLocation *prevLocation;
    
    float distancePickDrop;
    CLLocation * sourcePoint;
    CLLocation * destPoint;
    BOOL isDiverted;
    CustomPointAnnotation * pickUpPin;
    CustomPointAnnotation * dropPin;
    
    int acceptTime;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setThemeConstants];
    apiCallAttempt=0;
    TotalM =0.0;
    TotalTripDIstance=0.0;
    
    acceptTime = accept_time;
    // Do any additional setup after loading the view.p
    lastLoc =  [[CLLocation alloc]initWithLatitude:0.0 longitude:0.0];
    arraynearbyAnnotations =[[NSMutableArray alloc]init];
    arrayCagetgory =[[NSMutableArray alloc]init];
    
    
    arrTemp = [[NSMutableArray alloc]init];
    progCount =0;
    
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.delegate=self;
    tap.numberOfTouchesRequired=1;
    [_viewMessage  addGestureRecognizer:tap];
    
    //defaults_remove(DRIVER_STATUS);
    [self initMapView];
    arrManeuver=[[NSMutableArray alloc] init];
    
    // [self getDirections:@"28.53558637" lng:@"77.25960467"];
    
    [self getCategoryFormServer];
    [self getTaxiConstant];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    TotalTripDIstance=0.0;
    apiCallAttempt =0;
    
    arrTravelledWayPoints =[[NSMutableArray alloc]init];
    arrWayPoints =[[NSMutableArray alloc]init];
    NSString *status =defaults_object(DRIVER_STATUS);
    
    if ( status ==nil ||[status isEqualToString:TS_WAITING] || [status isEqualToString:TS_REQUEST] || [status isEqualToString:TS_END] || [status isEqualToString:TS_DRIVER_CANCEL_AT_PICKUP] || [status isEqualToString:TS_DRIVER_CANCEL_AT_DROP]) {
        [self invalidateNearByTimer];
        nearbyTimer = [NSTimer scheduledTimerWithTimeInterval: 15.0 target: self
                                                     selector: @selector(getNearByRiders) userInfo: nil repeats: YES];
    }
    [[UpdateUserCurrentLocation sharedInstance] startUpdateCurrentLocation];
    [self ButtonGpsPressed:nil];
    isTravelled =NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [self stopMusic];
    [self invalidateNearByTimer];
    [[UpdateUserCurrentLocation sharedInstance] stopUpdateCurrentLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setThemeConstants{
    
    _viewStatusBar.backgroundColor = CONSTANT_THEME_COLOR1;
    _addressViewTop.backgroundColor = CONSTANT_THEME_COLOR1;
    _progressBgView.backgroundColor =CONSTANT_THEME_COLOR1;
    _timerBgBottomView.backgroundColor =CONSTANT_THEME_COLOR1;
    _lblLocationTitle.textColor =CONSTANT_THEME_COLOR2;
    _btnGoPopUP.backgroundColor =CONSTANT_THEME_COLOR2;
    _btnAccept.backgroundColor =CONSTANT_THEME_COLOR2;
     [_btnAccept setTitleColor:CONSTANT_TEXT_COLOR_BUTTONS forState:UIControlStateNormal];
    _btnBeginTrip.backgroundColor =CONSTANT_THEME_COLOR2;
    [_btnBeginTrip setTitleColor:CONSTANT_TEXT_COLOR_BUTTONS forState:UIControlStateNormal];
    [_btnGoPopUP setTitleColor:CONSTANT_TEXT_COLOR_BUTTONS forState:UIControlStateNormal];
    [_lblProgressTime setFont:FONTS_THEME_REGULAR(17)];
     [_lblLocationTitle setFont:FONTS_THEME_REGULAR(17)];
     [_lblAddressTop setFont:FONTS_THEME_REGULAR(17)];
     [_lblAddress setFont:FONTS_THEME_REGULAR(17)];
     [_lblExpectedTime setFont:FONTS_THEME_REGULAR(17)];
     [_lblExpArrivaltime setFont:FONTS_THEME_REGULAR(17)];
     [_lblExpArrivaltime setFont:FONTS_THEME_REGULAR(17)];
     [_lblEstimatedTime setFont:FONTS_THEME_REGULAR(17)];
     [_lblEstimatedDistance setFont:FONTS_THEME_REGULAR(17)];
     [_lblAcceptTitle setFont:FONTS_THEME_REGULAR(17)];
    [_btnAccept.titleLabel setFont:FONTS_THEME_REGULAR(17)];
    [_btnDecline.titleLabel setFont:FONTS_THEME_REGULAR(17)];
    [_lblWhyNot setFont:FONTS_THEME_REGULAR(17)];
    [_txtViewMessage setFont:FONTS_THEME_REGULAR(15)];
    [_btnOK.titleLabel setFont:FONTS_THEME_REGULAR(15)];
    [_btnGoPopUP.titleLabel setFont:FONTS_THEME_REGULAR(17)];
    [_btnBeginTrip.titleLabel setFont:FONTS_THEME_REGULAR(17)];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //  Get the new view controller using [segue destinationViewController].
    //  Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"FareAmmountViewController"]) {
        
        FareAmmountViewController *fareView =(FareAmmountViewController *)[segue destinationViewController];
        fareView.curr_trip = currTrip;
        fareView.constantModel = constantTaxiModel;
    }
}


#pragma Buttons Action

- (IBAction)ButtonMenuPressed:(id)sender {
      [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
     //[self getNewOrderRequest];
}
- (IBAction)ButtonGpsPressed:(id)sender {
    
    AppDelegate *appdelegate =APP_DELEGATE;
    
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(appdelegate.currLoc, 600, 600);
    
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}


- (IBAction)ButtonAcceptPressed:(UIButton *)sender {
     NSString *str = NSLocalizedString(@"Accept", @"");
    
    if ([sender.titleLabel.text isEqualToString:str]) {
        
        [self sendtripaccept];
    }
    else{
        
        if ([driverStatus isEqualToString:TS_ARRIVE]) {
            driverStatus = TS_PICKED;
            defaults_set_object(DRIVER_STATUS, driverStatus);
            _acceptDeclineView.hidden=YES;
            _btnBeginTrip.hidden=NO;
            NSString *str = NSLocalizedString(@"DROP LOCATION", @"");
            _lblLocationTitle.text=str;
            _lblAddressTop.text =currTrip.trip_drop_loc;
            _timerBgBottomView.hidden=NO;
            [self drawroute:NO isAccept:NO isDivert:NO];
            
        }
        else{
            
            
            [self updateTripStatus:TS_END];
        }
    }
}
- (IBAction)ButtonDeclinePressed:(UIButton *)sender {
    
     NSString *str = NSLocalizedString(@"Decline", @"");
    
    if ([sender.titleLabel.text isEqualToString:str]) {
        [self setDriverFree];
        [self settoInitialState];
    }
    else{
        _acceptDeclineView.hidden=YES;
        _viewMessage.hidden=NO;
    }
    
}


- (IBAction)ButtonMessageOKPressed:(id)sender {
    
    NSString *message = [_txtViewMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
    NSString *trimmedString = [message stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    reasonString = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (reasonString.length==0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning!", @"")
                                                                                 message:NSLocalizedString(@"write_reason", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        
        if ([driverStatus isEqualToString:TS_ARRIVE]) {
            
            [self updateTripStatus:TS_DRIVER_CANCEL_AT_PICKUP];
        }
        else if ([driverStatus isEqualToString:TS_BEGIN]){
            
            [self updateTripStatus:TS_DRIVER_CANCEL_AT_DROP];
        }
        
        
    }
}

- (IBAction)btnBeginTripPressed:(UIButton *)sender {
    
    NSString *str1 = NSLocalizedString(@"Begin Trip", @"");
    if ([sender.titleLabel.text isEqualToString:str1]) {
        
        [self updateTripStatus:TS_BEGIN];
    }
    else{
        if ([P_IS_SHOW_EXTRA_POPUP isEqualToString:@"No"]) {
            //_btnBeginTrip.hidden =YES;
            [self updateTripStatus:TS_END];
            
        }
        else{
            _btnBeginTrip.hidden =YES;
            _lblAcceptTitle.text =NSLocalizedString(@"Client reached destination ?", @"");
            _acceptDeclineView.hidden=NO;
        }
    }
}

-(void)tapAction{
    
    [_txtViewMessage resignFirstResponder];
    
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied ||
        status == kCLAuthorizationStatusRestricted) {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert !", @"")
                                                                                 message:@"Location tracking disabled, please go to Settings "
                                              @"to adjust it"                                                                         preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    } else if (status == kCLAuthorizationStatusAuthorizedAlways) { //kCLAuthorizationStatusAuthorized = kCLAuthorizationStatusAuthorizedAlways  update for ios 9.0
        if (self.locationManager) {
            
        }
    }
}
-(void)initMapView
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewOrderRequest) name:@"NotificationReceived" object:nil];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    AppDelegate *appdelegate =APP_DELEGATE;
    
    // CLLocationCoordinate2DMake(CLLocationDegrees , CLLocationDegrees longitude);
    NSDictionary *lastloc = defaults_object(@"curr_loc");
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[lastloc objectForKey:@"lat"] floatValue], [[lastloc objectForKey:@"lng"] floatValue]);
    appdelegate.currLoc=coordinate;
    
    
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    _locationManager.distanceFilter = 10.0;
  
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startUpdatingLocation];
    [_locationManager setPausesLocationUpdatesAutomatically:NO];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.showsCompass = YES;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(appdelegate.currLoc, 600, 600);
   // [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    if( coordinate.longitude > -89 && coordinate.longitude < 89 && coordinate.longitude > -179 && coordinate.longitude < 179 ){
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    }
    
    [self settoInitialState];
    
    NSString *status =defaults_object(DRIVER_STATUS);
    
    NSString *driverAvailability =@"1";
    if ( status ==nil ||[status isEqualToString:TS_WAITING] || [status isEqualToString:TS_REQUEST] || [status isEqualToString:TS_END] || [status isEqualToString:TS_DRIVER_CANCEL_AT_PICKUP] || [status isEqualToString:TS_DRIVER_CANCEL_AT_DROP] ) {
        
        if (appdelegate.isFromInactive){
            NSLog(@"*****************  getTripCall called11");
            if (appdelegate.trip_id.length>0) {
                
                appdelegate.isFromInactive =NO;
                driverStatus =TS_WAITING;
                [self getNewOrderRequest];
                NSLog(@"*****************  getTripCall called12");
            }
            else{
                
                NSLog(@"*****************  getTripCall called");
                // [self getTripCall];
            }
            
        }
        
        driverStatus =TS_WAITING;
        defaults_set_object(DRIVER_STATUS, driverStatus);
        
        
        if (![status isEqualToString:TS_END]){
            
            [[UpdateUserCurrentLocation sharedInstance]  updateDriverAvailablity:driverAvailability];
        }
    }
    
    else{
        
        driverStatus=status;
        NSString *tripId = defaults_object(TRIP_ID);
        appdelegate.trip_id = tripId;
        [self gettripDetails:status];
    }
    
    
    
}

-(void)settoInitialState{
    
     [self stopMusic];
    TotalTripDIstance =0.0;
    TotalM =0.0;
    //    AppDelegate *appdelegate =APP_DELEGATE;
    
    arrWayPoints =[[NSMutableArray alloc]init];
    arrTravelledWayPoints =[[NSMutableArray alloc]init];
    isTravelled=NO;
    _addressViewTop.hidden=YES;
    _timerBgBottomView.hidden=YES;
    
    progCount = 0;
    _progressView.progress=1;
    [progressTimer invalidate];
    progressTimer =nil;
    
    [self removeDisTimer];
    
    
    
    [updateDriverTimer invalidate];
    updateDriverTimer =nil;
    
    [self invalidateNearByTimer];
    
    _lblProgressTime.text =[NSString stringWithFormat:@"Touch in %d sec to accept.",accept_time];
    
    _lblExpArrivaltime.text=@"";
    _lblExpectedDistance.text =@"";
    _lblExpArrivaltime.text=@"";
    _lblEstimatedDistance.text=@"";
    _lblEstimatedTime.text=@"";
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    NSString *str = NSLocalizedString(@"Accept", @"");
    
    [_btnAccept setTitle:str forState:UIControlStateNormal];
    NSString *str1 = NSLocalizedString(@"Decline", @"");
    [_btnDecline setTitle:str1 forState:UIControlStateNormal];
    NSString *str2 = NSLocalizedString(@"Begin Trip", @"");
    
    [_btnBeginTrip setTitle:str2 forState:UIControlStateNormal];
    NSString *str3 = NSLocalizedString(@"Go", @"");
    
    [_btnGoPopUP setTitle:str3 forState:UIControlStateNormal];
   
    
    [self showAcceptView:YES];
    
    
    
    
}

#pragma mark - CLLocationManager Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *loc = locations.lastObject;
    
    CurrentLocation = loc;
    
    NSLog(@"loc manager 2 : %f", loc.coordinate.latitude);
    
    
    
    /////////////////////////////////////////////////////   // shifted code
    [self setDriverPin:loc];
    
}

-(void)setDriverPin:(CLLocation *)loc{
    AppDelegate *appdelegate= APP_DELEGATE;
    
    appdelegate.currLoc = loc.coordinate;
    
    
    NSDictionary * dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",appdelegate.currLoc.latitude],@"lat",[NSString stringWithFormat:@"%f",appdelegate.currLoc.longitude ],@"lng", nil];
    defaults_set_object(@"curr_loc", dict);
    
    //NSLog(@"map curr loc  : %f",loc.coordinate.latitude);
    
    [self.mapView removeAnnotation:driverPin];
    
    driverPin = [[MKPointAnnotation alloc] init];
    
    driverPin.coordinate = appdelegate.currLoc;
    // driverPin=YES;
    [self.mapView addAnnotation:driverPin];
    
    //[self checkPoints];
    
    
    
    
    if (!isFirstLoad) {
        isFirstLoad =YES;
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc.coordinate, 600, 600);
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
        
        
    }
    
    
    if ([driverStatus isEqualToString:TS_BEGIN ]) {
        if (StartLocationTaken == FALSE) {
            StartLocationTaken = TRUE;
            StartLocation = [[CLLocation alloc] initWithLatitude:CurrentLocation.coordinate.latitude longitude:CurrentLocation.coordinate.longitude];
            
            NewLocaton = [[CLLocation alloc] init];
            OldLocation = [[CLLocation alloc] init];
            
            OldLocation = StartLocation;
        }
        else{
            
            
            
            BOOL b = [CMMotionActivityManager isActivityAvailable];
            if(b)
            {
                if([_activtiyNameDetactor isEqualToString:@"Not Walking"] || [_activtiyNameDetactor isEqualToString:@"stationary"])
                {
                    
                    return;
                    //
                }
                
            }
            else{
                if(CurrentLocation.horizontalAccuracy>20)
                {
                    return;
                }
            }
            
            
            NewLocaton = CurrentLocation;
            
            float dis = [NewLocaton distanceFromLocation:OldLocation];
            
            if (dis >50) {
                
                TotalM = TotalM+dis;
                
                
                
                TotalTripDIstance = (TotalM / 1000.0); //Converting Meters to KM
                
                NSString *dist =[NSString stringWithFormat:@"%f",TotalTripDIstance];
                defaults_set_object(@"total_travelled_distance",dist );
                
                
                
                
                
                OldLocation = NewLocaton;
            }
            
        }
        
       
        
        
    }
    
    
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.userInfo);
    
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"permission_denied", @"")
                                                                                     message:NSLocalizedString(@"location_turn_on", @"")
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            //We add buttons to the alert controller by creating UIAlertActions:
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil]; //You can use a block here to handle a press on this button
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

#pragma mark mapview delegates


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];;
    NSLog(@"map curr loc 1  : %f",userLocation.coordinate.latitude);
    CurrentLocation = loc;
    [self setDriverPin:loc];
    
}


- (void)zoomToFitMapAnnotationsWith:(GoogleDirectionSource * )directionSource {
    
    
    [self .mapView removeAnnotations:self.mapView.annotations];
    pickUpPin=[[CustomPointAnnotation alloc]  initWithType:@"pick"];
    pickUpPin.coordinate= directionSource.source.coordinate;
    pickUpPin.type=@"start";
    [self.mapView addAnnotation:pickUpPin];
    
    
    dropPin=[[CustomPointAnnotation alloc]  initWithType:@"drop"];
    dropPin.coordinate= directionSource.destination.coordinate;
    dropPin.type=@"end";
    [self.mapView addAnnotation:dropPin];
    
    arrayAnotations=@[pickUpPin,dropPin];
    
}



-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    angle = (double)newHeading.magneticHeading;
}


-(void) playVoiceManever:(CLLocation *) location
{
    
    
    NSLog(@"Current Location %@",location);
    for (NSDictionary * dict in arrManeuver) {
        CLLocation * statLocation=[dict objectForKey:@"start_location"];
        double distanceTemp=[statLocation distanceFromLocation:location];
        if(distanceTemp<500)
        {
            
            if(distanceTemp<200)
            {
                
            }else if(distanceTemp<100)
            {
                
            }
            else if(distanceTemp<50)
            {
                
            }
            else{
                //             [self speakInstructions:[dict objectForKey:@"Manever"]];
            }
            [self speakInstructions:[dict objectForKey:@"Maneuver"]];
            break;
        }
    }
}


-(void) speakInstructions:(NSString *)instructions
{
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
    
    AVSpeechUtterance *speechutt = [AVSpeechUtterance speechUtteranceWithString:instructions];
    [speechutt setRate:0.3f];
    speechutt.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-us"];
    [synthesizer speakUtterance:speechutt];
    
}



-(void)showAllUsers:(NSArray *)arrUsers
{
    // [self setDriverLocation];
    
    [self.mapView removeAnnotations:arraynearbyAnnotations];
    
    arraynearbyAnnotations = [[NSMutableArray alloc]init];
    for(int i = 0; i < arrUsers.count; i++)
    {
        double latitude = [[[arrUsers objectAtIndex:i] objectForKey:@"u_lat"] doubleValue];
        double longitude = [[[arrUsers objectAtIndex:i] objectForKey:@"u_lng"] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
        mapPin.coordinate = coordinate;
        
        [arraynearbyAnnotations addObject:mapPin];
        [self.mapView addAnnotation:mapPin];
        
    }
    
    //[self zoomToFitMapAnnotations];
    
    
}

-(void)setDriverLocation{
    
    AppDelegate *appdelegate =APP_DELEGATE;
    
    
    if(appdelegate.currLoc.latitude !=0)
    {
        
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        driverPin = [[MKPointAnnotation alloc] init];
        
        driverPin.coordinate = appdelegate.currLoc;
        // driverPin=YES;
        [self.mapView addAnnotation:driverPin];
        
    }
    
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    
    MKAnnotationView *pinView = nil;
    if(annotation != self.mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.driver.pin";
        pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        if (annotation == driverPin) {
            pinView.image = [UIImage imageNamed:@"car3"];
            //driverPin=NO;
        }
        else if([annotation isKindOfClass:[CustomPointAnnotation class]])
        {
            CustomPointAnnotation  *mAnno=(CustomPointAnnotation *) annotation;
            if([mAnno.type isEqualToString:@"start"])
            {
                pinView.image = [UIImage imageNamed:@"PIN"];
            }else{
                pinView.image = [UIImage imageNamed:@"pin-red"];
            }
            
        }
    }
    else {
        
        [self.mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *ulv = [mapView viewForAnnotation:mapView.userLocation];
    ulv.hidden = YES;
}

#pragma api calls

-(void)getNewOrderRequest {
    
    
    AppDelegate *appdelegate = APP_DELEGATE;
    //appdelegate.trip_id = @"8";
    //appdelegate.trip_status = TS_REQUEST;
    
    defaults_set_object(TRIP_ID, appdelegate.trip_id);
    
    
    NSLog(@"***** 1 ===%@ 2====%@ 3=====%f",driverStatus,appdelegate.trip_status,appdelegate.currLoc.latitude);
    
    if ([driverStatus isEqualToString:TS_WAITING] && appdelegate.currLoc.latitude !=0 &&  [appdelegate.trip_status isEqualToString:TS_REQUEST]) {
        
        
        
        NSString *driverAvailability =@"0";
        [[UpdateUserCurrentLocation sharedInstance]  updateDriverAvailablity:driverAvailability];
        driverStatus =TS_REQUEST;
        defaults_set_object(DRIVER_STATUS, driverStatus);
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    
                                                                                    TRIP_ID :appdelegate.trip_id,
                                                                                    
                                                                                    }];
        apiCallAttempt=0;
        [self getTripOnNotification:dict isShowLoderErrorAlert:NO];
    }
}



-(void)  getTripOnNotification :(NSDictionary *) dict  isShowLoderErrorAlert:(BOOL) isShowLoderErrorAlert
{
    
    [APP_CallAPI gcURL:BASE_URL_DRIVER app:TRIP_GETTRIP
                  data:dict
      isShowErrorAlert:NO
       completionBlock:^(id results, NSError *error) {
           apiCallAttempt++;
           if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]&& [[results objectForKey:P_RESPONSE] isKindOfClass:[NSArray class]]) {
               // success
               
               currTrip = [[TripModel alloc] initItemWithDict:[[results objectForKey:P_RESPONSE]objectAtIndex:0]];
               if([currTrip.trip_Status isEqualToString:TS_REQUEST])
               {
                   [self.navigationController popToRootViewControllerAnimated:NO];
               }
               [self acceptProgress];
               
           }
           else{
               if(apiCallAttempt<3)
               {
                   [self getTripOnNotification:dict isShowLoderErrorAlert:NO];
               }
           }
       }];
}
-(void)gettripDetails:(NSString *)status{
    
    
    AppDelegate *appdelegate =APP_DELEGATE;
    
    defaults_set_object(TRIP_ID, appdelegate.trip_id);
    
    
    if ( appdelegate.currLoc.latitude !=0 ) {
        
        NSString *driverAvailability =@"0";
        [[UpdateUserCurrentLocation sharedInstance]  updateDriverAvailablity:driverAvailability];
        
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    
                                                                                    TRIP_ID :appdelegate.trip_id,
                                                                                    
                                                                                    }];
        [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
        
        [APP_CallAPI gcURL:BASE_URL_DRIVER app:TRIP_GETTRIP
                      data:dict
         isShowErrorAlert:NO
           completionBlock:^(id results, NSError *error) {
               if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                   // success
                   
                   currTrip = [[TripModel alloc] initItemWithDict:[[results objectForKey:P_RESPONSE]objectAtIndex:0]];
                   
                   if ([status isEqualToString:TS_ACCEPTED]) {
                       
                       [self showAcceptView:YES];
                       driverStatus =TS_ACCEPTED;
                       _goPopUpView.hidden=NO;
                       defaults_set_object(DRIVER_STATUS, driverStatus);
                       NSString *str = NSLocalizedString(@"PICKUP LOCATION", @"");
                       _lblLocationTitle.text =str;
                       _lblAddressTop.text =currTrip.trip_pick_loc;
                       _goPopUpView.hidden=NO;
                       progCount =0;
                       _progressView.progress=1;
                       [progressTimer invalidate];
                       progressTimer=nil;
                       
                       [self drawroute:YES isAccept:NO isDivert:NO];
                       
                       
                   }
                   else if([status isEqualToString:TS_ARRIVE]){
                       
                       driverStatus = TS_ARRIVE;
                       defaults_set_object(DRIVER_STATUS, driverStatus);
                       
                       NSString *str = NSLocalizedString(@"PICKUP LOCATION", @"");
                       _lblLocationTitle.text =str;
                       _lblAddressTop.text =currTrip.trip_pick_loc;
                       _goPopUpViewBottomConstraints.constant=_timerBgBottomView.frame.size.height;
                       _addressViewTop.hidden=NO;
                       _goPopUpView.hidden=NO;
                       
                       NSString *str1 = NSLocalizedString(@"Pick", @"");
                       
                       
                       [_btnGoPopUP setTitle:str1 forState:UIControlStateNormal];
                       
                       [self drawroute:YES isAccept:NO isDivert:NO];
                       [self removeDisTimer];
                       
                       [self getDistanceTime];
                       _timerBgBottomView.hidden=NO;
                   }
                   else if ([status isEqualToString:TS_PICKED]){
                       
                       driverStatus = TS_PICKED;
                       defaults_set_object(DRIVER_STATUS, driverStatus);
                       _acceptDeclineView.hidden=YES;
                       _btnBeginTrip.hidden=NO;
                       NSString *str = NSLocalizedString(@"DROP LOCATION", @"");
                       _lblLocationTitle.text=str;
                       _lblAddressTop.text =currTrip.trip_drop_loc;
                       _addressViewTop.hidden=NO;
                       [_btnAccept setTitle:NSLocalizedString(@"Yes", @"") forState:UIControlStateNormal];
                       [_btnDecline setTitle:NSLocalizedString(@"No", @"") forState:UIControlStateNormal];
                       _lblAcceptTitle.text =NSLocalizedString(@"Client reached destination ?", @"");
                       
                       [self drawroute:NO isAccept:NO isDivert:NO];
                       [self removeDisTimer];
                       [self getDistanceTime];
                       _timerBgBottomView.hidden=NO;
                       
                       NSString *dis =defaults_object(@"total_travelled_distance");
                       TotalM = [dis floatValue]*1000;
                       TotalTripDIstance = [dis floatValue];
                       
                   }
                   else if ([status isEqualToString:TS_BEGIN]){
                       
                       driverStatus = TS_BEGIN;
                       defaults_set_object(DRIVER_STATUS, driverStatus);
                       [_btnBeginTrip setTitle:@"End Trip" forState:UIControlStateNormal]; NSString *str1 = NSLocalizedString(@"End Trip", @"");
                       [_btnBeginTrip setTitle:str1 forState:UIControlStateNormal];
                       _btnBeginTrip.hidden=NO;
                       NSString *str = NSLocalizedString(@"DROP LOCATION", @"");
                       _lblLocationTitle.text=str;
                       _lblAddressTop.text =currTrip.trip_drop_loc;
                       _addressViewTop.hidden=NO;
                       [_btnAccept setTitle:NSLocalizedString(@"Yes", @"") forState:UIControlStateNormal];
                       [_btnDecline setTitle:NSLocalizedString(@"No", @"") forState:UIControlStateNormal];
                       _lblAcceptTitle.text =NSLocalizedString(@"Client reached destination ?", @"");
                       [self drawroute:NO isAccept:NO isDivert:NO];
                       [self removeDisTimer];
                       [self getDistanceTime];
                       _timerBgBottomView.hidden=NO;
                       
                       NSString *dis =defaults_object(@"total_travelled_distance");
                       TotalM = [dis floatValue]*1000;
                       TotalTripDIstance = [dis floatValue];
                       
                   }
               }
               
               
               NSLog(@"11 %@", defaults_object(@"total_travelled_distance"));
               
               [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
           }];
    }
    
    
    
}

-(void)removeDisTimer{
    if (timeDisTimer.isValid) {
        [timeDisTimer invalidate];
        timeDisTimer =nil;
    }
    
}

-(void)drawroute:(BOOL)isPick isAccept:(BOOL)accept isDivert:(BOOL)isDivert{
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    
    AppDelegate *appdelegate =APP_DELEGATE;
    
    if (isPick) {
        
        sourcePoint=[[CLLocation alloc]   initWithLatitude:appdelegate.currLoc.latitude  longitude:appdelegate.currLoc.longitude];
        
        destPoint=[[CLLocation alloc]  initWithLatitude:[currTrip.trip_pick_lat doubleValue] longitude:[currTrip.trip_pick_long doubleValue]];
        
        distancePickDrop = [sourcePoint distanceFromLocation:destPoint];
    }
    else{
        
        if (isDivert) {
            
            sourcePoint = [[CLLocation alloc]   initWithLatitude:appdelegate.currLoc.latitude  longitude:appdelegate.currLoc.longitude];
        }
        else{
            
            sourcePoint=[[CLLocation alloc]   initWithLatitude:[currTrip.trip_pick_lat doubleValue]  longitude:[currTrip.trip_pick_long doubleValue]];
        }
        
        destPoint=[[CLLocation alloc]  initWithLatitude:[currTrip.trip_drop_lat doubleValue] longitude:[currTrip.trip_drop_long doubleValue]];
        distancePickDrop = [sourcePoint distanceFromLocation:destPoint];
    }
    
    GoogleDirectionSource * userDriverLocationRoute=[[GoogleDirectionSource alloc]  initWithSource:sourcePoint destination:destPoint];
    [userDriverLocationRoute  findDirectionWithCompletionBlock:^(id results, NSError *error) {
        if([results isKindOfClass:[DirectionModel class]])
        {
            
            DirectionModel  *dModel=(DirectionModel *)results;
            
            if (isPick) {
                
                NSArray * arr = defaults_object(@"constantResponse");
                ConstantModel *constantModel =[[ConstantModel alloc]initItemWithDict:arr];
                NSString *dis;
                NSString *tripDis;
                if ([[constantModel.constant_distance capitalizedString] isEqualToString:@"Km"]) {
                    dis =@"km";
                    tripDis = [NSString stringWithFormat:@"%.2f",dModel.distance];
                }
                else{
                    dis =@"mi";
                    float miles = dModel.distance *0.621371192;
                    tripDis = [NSString stringWithFormat:@"%.1f", miles];
                    
                }
                
                _lblEstimatedTime.text = [NSString stringWithFormat:@"%.01f min",dModel.duration];
                _lblEstimatedDistance.text = [NSString stringWithFormat:@"%@ %@",tripDis,dis];
            }
            
            [self zoomToFitMapAnnotationsWith:userDriverLocationRoute];
            
            arrWayPoints = dModel.arrDirectionLatLng;
            
            [_mapView addOverlay:[dModel getPolyline] level:MKOverlayLevelAboveRoads];
            isDiverted =NO;
            //[self checkPoints];
            [dModel zoomToPolyLine:self.mapView polyline:[dModel getPolyline] animated:YES];
            
        }
        else {
           
        }
    }];
}

-(void)sendtripaccept{
    
    
    //AppDelegate *appdelegate =APP_DELEGATE;
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                
                                                                                P_DRIVER_ID         :[dict1 objectForKey:P_DRIVER_ID],
                                                                                TRIP_STATUS         :TS_ACCEPTED,
                                                                                TRIP_ID             :currTrip.trip_Id,
                                                                                }];
    
    [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    
    [APP_CallAPI gcURL:BASE_URL_DRIVER app:trip_accept
                  data:dict
     isShowErrorAlert:NO
       completionBlock:^(id results, NSError *error) {
           if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
               // success
               
               NSLog(@"***** %@",[results objectForKey:P_STATUS]);
               currTrip = [[TripModel alloc] initItemWithDict:[results objectForKey:P_RESPONSE]];
               
               [self showAcceptView:YES];
               driverStatus = TS_ACCEPTED;
               _goPopUpView.hidden=NO;
               defaults_set_object(DRIVER_STATUS, driverStatus);
               [self stopMusic];
               progCount =0;
               _progressView.progress=1;
               [progressTimer invalidate];
               progressTimer=nil;
               [self sendNotification:TS_ACCEPTED];
               
               
           }
           else{
               
               UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"too_late", @"")
                                                                                        message:NSLocalizedString(@"another_driver_accepted", @"")                                                                          preferredStyle:UIAlertControllerStyleAlert];
               //We add buttons to the alert controller by creating UIAlertActions:
               UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                                  style:UIAlertActionStyleDefault
                                                                handler:nil]; //You can use a block here to handle a press on this button
               [alertController addAction:actionOk];
               [self presentViewController:alertController animated:YES completion:nil];
               
               progCount =0;
               _progressView.progress=1;
               [progressTimer invalidate];
               progressTimer=nil;
               
               [self setDriverFree];
               [self settoInitialState];
           }
           
           [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
           
       }];
    
}

-(void)getNearByRiders{
    
    AppDelegate *appdelegate =APP_DELEGATE;
    
    
    if (appdelegate.currLoc.latitude> 0 && [driverStatus isEqualToString:TS_WAITING]) {
        
        //NSLog(@" ********* api count %d",count++);
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    @"lat"                : [NSString stringWithFormat:@"%f",appdelegate.currLoc.latitude],
                                                                                    @"lng"                : [NSString stringWithFormat:@"%f",appdelegate.currLoc.longitude],
                                                                                    
                                                                                    }];
        
        if (constantTaxiModel.constant_driver_radius ==nil) {
            
            [dict setObject:@"2" forKey:@"miles"];
        }
        else{
            
            [dict setObject:constantTaxiModel.constant_driver_radius forKey:@"miles"];
        }
        
        [APP_CallAPI gcURL:BASE_URL_DRIVER app:GET_USERS_NEARBY
                      data:dict
         isShowErrorAlert:NO
           completionBlock:^(id results, NSError *error) {
               if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                   // success
                   
                   
                   NSArray *ridersArray = [results objectForKey:P_RESPONSE];
                   
                   if (ridersArray.count>0) {
                       
                       [self showAllUsers:ridersArray];
                   }
                   
               }
               
           }];
    }
    
    else{
        
        [self invalidateNearByTimer];
        //NSLog(@" ********* api count %d",count++);
        nearbyTimer = [NSTimer scheduledTimerWithTimeInterval: 15.0 target: self
                                                     selector: @selector(getNearByRiders) userInfo: nil repeats: YES];
    }
}

-(void)invalidateNearByTimer{
    [nearbyTimer invalidate];
    nearbyTimer = nil;
}


-(void)updateTripStatus:(NSString *)status{
    
    //AppDelegate *appdelegate =APP_DELEGATE;
    
    NSString *trip_fare;
    NSString *taxAmt;
    NSString *pickTime;
    NSString *dropTime;
    float distance1=0.0;
    
    NSArray * arr = defaults_object(@"constantResponse");
    ConstantModel *constantModel =[[ConstantModel alloc]initItemWithDict:arr];
    
    if ([[constantModel.constant_distance capitalizedString] isEqualToString:@"Km"]) {
        
        distance1 = TotalTripDIstance;
    }
    else{
        
        distance1 = TotalTripDIstance *0.621371192;
        
    }
    
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                
                                                                                P_DRIVER_ID         :[dict1 objectForKey:P_DRIVER_ID],
                                                                                TRIP_STATUS         :status,
                                                                                TRIP_ID             : currTrip.trip_Id,
                                                                                }];
    
    if (self.carCategory ==nil) {
        NSArray * arrCateResponse=defaults_object(@"categoryResponse");
        if(arrCateResponse)
        {
            arrayCagetgory=[CategoryModel parseResponse:arrCateResponse];
        }
        
        
        int catId = currTrip.driver.category_id;
        for (CategoryModel * category in arrayCagetgory) {
            if(category.categoryId == catId )
            {
                self.carCategory = category;
                
            }
        }
    }

    
    if ([status isEqualToString:TS_DRIVER_CANCEL_AT_DROP] ) {
        [dict setObject:reasonString forKey:TRIP_REASON];
        dropTime = [NSString stringWithFormat:@"%@",[Utilities getStringFromDate:[NSDate date]]];
        
        [dict  setObject:dropTime forKey:@"trip_drop_time"];
        
        NSDate *date1 = [Utilities GetGMTDatetoLocalTZ1:currTrip.trip_pickup_time];//[self ExtractDateFromStringTimestamp:currTrip.trip_pickup_time];
        NSDate *date2 = [Utilities GetGMTDatetoLocalTZ1:dropTime];//[self ExtractDateFromStringTimestamp:dropTime];
        
        NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];
        
        float minutes = secondsBetween / 60;
        
        NSDictionary *dict1 = [self.carCategory  calculatePrice:distance1 time:minutes];
        
        trip_fare = [dict1 objectForKey:@"total_amt"];
        taxAmt = [dict1 objectForKey:@"tax_amt"];
        [dict  setObject:trip_fare  forKey:@"trip_pay_amount"];
        
        [dict setObject:taxAmt forKey:@"tax_amt"];
        [dict setObject:[NSString stringWithFormat:@"%.2f",TotalTripDIstance] forKey:@"trip_distance"];
    }
    else if ([status isEqualToString:TS_DRIVER_CANCEL_AT_PICKUP]){
        
        NSLog(@"****** pickup");
        
        [dict setObject:reasonString forKey:TRIP_REASON];
        
        [dict  setObject:@"0.00"  forKey:@"trip_pay_amount"];
        
        [dict setObject:@"0.00" forKey:@"tax_amt"];
        [dict setObject:@"0.00" forKey:@"trip_distance"];
        
    }
    
    else if ([status isEqualToString:TS_END]){
        
        
        dropTime = [NSString stringWithFormat:@"%@",[Utilities getStringFromDate:[NSDate date]]];
        
        [dict  setObject:dropTime forKey:@"trip_drop_time"];
        
        NSDate *date1 = [Utilities GetGMTDatetoLocalTZ1:currTrip.trip_pickup_time];// [self ExtractDateFromStringTimestamp:currTrip.trip_pickup_time];
        NSDate *date2 = [Utilities GetGMTDatetoLocalTZ1:dropTime];//[self ExtractDateFromStringTimestamp:dropTime];
        
        NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];
        
        float minutes = secondsBetween / 60.0;
        
        NSDictionary *dict1 = [self.carCategory  calculatePrice:distance1 time:minutes];
        
        trip_fare = [dict1 objectForKey:@"total_amt"];
        taxAmt = [dict1 objectForKey:@"tax_amt"];
        [dict  setObject:trip_fare  forKey:@"trip_pay_amount"];
        
        [dict setObject:taxAmt forKey:@"tax_amt"];
        [dict setObject:[NSString stringWithFormat:@"%.2f",TotalTripDIstance] forKey:@"trip_distance"];
        
        
        
    }
    
    if ([status isEqualToString:TS_BEGIN] && distance) {
        
        pickTime = [NSString stringWithFormat:@"%@",[Utilities getStringFromDate:[NSDate date]]];
        
        [dict  setObject:pickTime forKey:@"trip_pickup_time"];
    }
    
    [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    
    [APP_CallAPI gcURL:BASE_URL_DRIVER app:TRIP_UPDATE
                  data:dict
            isShowErrorAlert:NO
       completionBlock:^(id results, NSError *error) {
           if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
               // success
               NSLog(@"**** update trip");
               // currTrip = [[TripModel alloc] initItemWithDict:[results objectForKey:P_RESPONSE]];
               
               if ([status isEqualToString:TS_ARRIVE]) {
                   
                   [self handleArriveNowState];
               }
               else if ([status isEqualToString:TS_BEGIN]){
                   driverStatus = TS_BEGIN;
                   defaults_set_object(DRIVER_STATUS, driverStatus);
                   NSString *str1 = NSLocalizedString(@"End Trip", @"");
                   [_btnBeginTrip setTitle:str1 forState:UIControlStateNormal];
                   defaults_set_object(@"begin_date", [NSDate date]);
                   
                  
                   
                   [self sendNotification:TS_BEGIN];
                   
                   currTrip.trip_pickup_time = pickTime;
                   [self startMotionDetection];
                   [self removeDisTimer];
                   [self getDistanceTime];
               }
               else if ([status isEqualToString:TS_END]){
                   
                   currTrip.trip_fare = trip_fare;
                   currTrip.trip_drop_time = dropTime ;
                   currTrip.tax_amount = taxAmt;
                   [self handleEndTrip];
               }
               
               else if ([status isEqualToString:TS_DRIVER_CANCEL_AT_PICKUP]){
                   NSLog(@"****** pickup1");
                   [self handleDriverCancel:status];
               }
               else if ([status isEqualToString:TS_DRIVER_CANCEL_AT_DROP]){
                   
                   currTrip.trip_fare = trip_fare;
                   currTrip.trip_drop_time = dropTime ;
                   currTrip.tax_amount = taxAmt;
                   [self handleDriverCancel:status];
               }
               
           }
           
           [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
           
       }];
}

#pragma API CALLS

-(void)getCategoryFormServer
{
    [APP_CallAPI gcURL:BASE_URL_DRIVER app:CAR_GETCATEGORY
                  data:nil
      isShowErrorAlert:NO
       completionBlock:^(id results, NSError *error) {
           apiCallAttempt++;
           if([[results objectForKey:P_STATUS] isEqualToString:@"OK"])
           {
               defaults_set_object(@"categoryResponse", [results objectForKey:P_RESPONSE]);
               arrayCagetgory=[CategoryModel parseResponse:[results objectForKey:P_RESPONSE]];
               
               
               NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
               
               int catId = (int)[dict1 objectForKey:P_CATEGORY_ID];
               for (CategoryModel * category in arrayCagetgory) {
                   if(category.categoryId == catId )
                   {
                       self.carCategory=category;
                       
                   }
               }
           }
           else{
               if(apiCallAttempt<3){
                   [self getCategoryFormServer];
               }
               
           }
       }];
    
}

-(void)getTaxiConstant
{
    [APP_CallAPI gcURL:BASE_URL_DRIVER app:API_GET_TAXI_CONSTANT
                  data:nil
      isShowErrorAlert:NO
       completionBlock:^(id results, NSError *error) {
           if([[results objectForKey:P_STATUS] isEqualToString:@"OK"])
           {
               defaults_set_object(@"constantResponse", [results objectForKey:P_RESPONSE]);
               constantTaxiModel = [[ConstantModel alloc]initItemWithDict:[results objectForKey:P_RESPONSE]];
           }
       }];
    
}


-(void)acceptProgress{
    
    [self invalidateNearByTimer];
    
    [self showAcceptView:NO];
    _lblAddress.text = currTrip.trip_pick_loc;
    _lblAcceptTitle.text =@"";
    
    
     [self startMusic];
    
    [self drawroute:YES isAccept:YES isDivert:NO];
    
    
    [self.progressView setTransform:CGAffineTransformMakeScale(1.0, 15.0)];
    
    
    progressTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self
                                                   selector: @selector(onUpdateTimer) userInfo: nil repeats: YES];
    
    
    
}

-(void)onUpdateTimer{
    
    
    
    if (progCount<acceptTime) {
        
        
        [self.progressView setProgress:(100-3.3*progCount)/100.0];
        
        _lblProgressTime.text =[NSString stringWithFormat:@"Touch in %d sec to accept.",acceptTime-progCount];
        
        progCount= progCount+1;
    }
    else{
        
        [progressTimer invalidate];
        progressTimer =nil;
        [self.progressView setProgress:0];
        [self showAcceptView:YES];
        [self setDriverFree];
        [self settoInitialState];
        
    }
    
}


-(void)showAcceptView:(BOOL)sender {
    
    _acceptDeclineView.hidden=sender;
    _addressBgView.hidden = sender;
    _timeDistanceView.hidden=sender;
    _progressBgView.hidden=sender;
    _btnMenu.hidden=!sender;
}



- (IBAction)ButtonGoPressed:(UIButton *)sender {
    
     NSString *str1 = NSLocalizedString(@"Pick", @"");
    if ([sender.titleLabel.text isEqualToString:str1]) {
        
        [self handlePick];
        
    }
    
    else{
        
        [self updateTripStatus:TS_ARRIVE];
    }
    
}




-(void)setDistanceTime:(NSString *)time dis:(NSString *)distance1{
    
    NSArray * arr = defaults_object(@"constantResponse");
    ConstantModel *constantModel =[[ConstantModel alloc]initItemWithDict:arr];
    NSString *dist;
    NSString *tripDis;
    if ([[constantModel.constant_distance capitalizedString] isEqualToString:@"Km"]) {
        dist =@"km";
        tripDis = distance1;
    }
    else{
        dist =@"mi";
        float miles = [distance1 floatValue]*0.621371192;
        tripDis = [NSString stringWithFormat:@"%.2f",miles];
        
    }
    
    _lblExpectedDistance.text=[NSString stringWithFormat:@"%@ %@",tripDis,dist];
    _lblExpectedTime.text = [NSString stringWithFormat:@"%@ min",time];
    
    int totalSeconds = [time doubleValue]*60;
    
    NSDate *date =[NSDate dateWithTimeIntervalSinceNow:totalSeconds];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm a"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *arrTime = [formatter stringFromDate:date];
    
    _lblExpArrivaltime.text =[NSString stringWithFormat:@"%@ ETA",arrTime];
    
}



#pragma mark - MKMapViewDelegate methods

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    if (!isTravelled){
        renderer.strokeColor = [UIColor colorWithRed:0.0/255.0 green:171.0/255.0 blue:253.0/255.0 alpha:1.0];
    }
    else{
        renderer.strokeColor = [UIColor redColor];
    }
    
    renderer.lineWidth = 2.0;
    
    return  renderer;
}


#pragma handle driver states

-(void)handleDriverCancel:(NSString *)status{
    
    
    _txtViewMessage.text=@"";
    _viewMessage.hidden=YES;
    
    if ([status isEqualToString:TS_DRIVER_CANCEL_AT_PICKUP]) {
        
        NSLog(@"****** pickup2");
        
        [self sendNotification:TS_DRIVER_CANCEL_AT_PICKUP];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        
        [self sendNotification:TS_DRIVER_CANCEL_AT_DROP];
        [self performSegueWithIdentifier:@"FareAmmountViewController" sender:nil];
    }
    
    driverStatus = status;
    defaults_set_object(DRIVER_STATUS, driverStatus);
    [self settoInitialState];
    [self setDriverFree];
    
}

-(void)handlePick{
    
    self.goPopUpViewBottomConstraints.constant=0;
    _goPopUpView.hidden=YES;
    
    // driverStatus = TS_PICKED;
    //defaults_set_object(DRIVER_STATUS, driverStatus);
    
    if ([P_IS_SHOW_EXTRA_POPUP isEqualToString:@"No"]) {
        
        driverStatus = TS_PICKED;
        defaults_set_object(DRIVER_STATUS, driverStatus);
        _acceptDeclineView.hidden=YES;
        _btnBeginTrip.hidden=NO;
        NSString *str = NSLocalizedString(@"DROP LOCATION", @"");
        _lblLocationTitle.text=str;
        _lblAddressTop.text =currTrip.trip_drop_loc;
        _timerBgBottomView.hidden=NO;
        [self drawroute:NO isAccept:NO isDivert:NO];
    }
    else{
        
        [self removeDisTimer];
        
        [_btnAccept setTitle:NSLocalizedString(@"Yes", @"")  forState:UIControlStateNormal];
        [_btnDecline setTitle:NSLocalizedString(@"No", @"") forState:UIControlStateNormal];
        _lblAcceptTitle.text = NSLocalizedString(@"Client Picked Up ?", @"");
        _acceptDeclineView.hidden =NO;
    }
    
}

-(void)handleEndTrip{
    [self sendNotification:TS_END];
    driverStatus = TS_END;
    defaults_set_object(DRIVER_STATUS, driverStatus);
    
    [self removeDisTimer];
    _btnBeginTrip.hidden =YES;
    [self settoInitialState];
    [self setDriverFree];
    [self performSegueWithIdentifier:@"FareAmmountViewController" sender:nil];
    
}

-(void)handleArriveNowState{
    _timerBgBottomView.hidden=NO;
    
    driverStatus = TS_ARRIVE;
    defaults_set_object(DRIVER_STATUS, driverStatus);
    
    NSString *str = NSLocalizedString(@"PICKUP LOCATION", @"");
    _lblLocationTitle.text =str;
    _lblAddressTop.text =currTrip.trip_pick_loc;
    _goPopUpViewBottomConstraints.constant=_timerBgBottomView.frame.size.height;
    _addressViewTop.hidden=NO;
    
    [self removeDisTimer];
    
    [self getDistanceTime];
    NSString *str1 = NSLocalizedString(@"Pick", @"");
    [_btnGoPopUP setTitle:str1 forState:UIControlStateNormal];
    
    [self sendNotification:TS_ARRIVE];
    
    if ([P_IS_SHOW_EXTRA_POPUP isEqualToString:@"No"]) {
        
        [self handlePick];
    }
    
}


-(void)getDistanceTime{
    
    
    AppDelegate *appdelegate =APP_DELEGATE;
    
    CLLocation * source;
    CLLocation * dest;
    
    
    if ([driverStatus isEqualToString:TS_ARRIVE]) {
        
        source=[[CLLocation alloc]   initWithLatitude:appdelegate.currLoc.latitude  longitude:appdelegate.currLoc.longitude];
        
        dest=[[CLLocation alloc]  initWithLatitude:[currTrip.trip_pick_lat doubleValue] longitude:[currTrip.trip_pick_long doubleValue]];
    }
    else{
        
        source=[[CLLocation alloc]   initWithLatitude:appdelegate.currLoc.latitude  longitude:appdelegate.currLoc.longitude];
        
        dest=[[CLLocation alloc]  initWithLatitude:[currTrip.trip_drop_lat doubleValue] longitude:[currTrip.trip_drop_long doubleValue]];
        
    }
    
    
    GoogleDirectionSource * userDriverLocationRoute=[[GoogleDirectionSource alloc]  initWithSource:source destination:dest];
    [userDriverLocationRoute  findDirectionWithCompletionBlock:^(id results, NSError *error) {
        if([results isKindOfClass:[DirectionModel class]])
        {
            
            DirectionModel  *dModel=(DirectionModel *)results;
            
            distance = [NSString stringWithFormat:@"%.02f",dModel.distance] ;
            
            [self setDistanceTime:[NSString stringWithFormat:@"%.01f",dModel.duration]  dis:[NSString stringWithFormat:@"%.01f",dModel.distance]];
            [self removeDisTimer];
            timeDisTimer = [NSTimer scheduledTimerWithTimeInterval: 50.0 target: self
                                                          selector: @selector(getDistanceTime) userInfo: nil repeats: YES];
            
            
        }
    }];
    
}

#pragma send notifications

-(void)sendNotification:(NSString *)status{
    NSString *message;
    
    if ( [status isEqualToString:TS_DRIVER_CANCEL_AT_DROP] ) {
        message = MESSAGE_END;
    }
    else if ([status isEqualToString:TS_DRIVER_CANCEL_AT_PICKUP]){
        
        message =MESSAGE_DRIVER_CANCEL;
    }
    else if ([status isEqualToString:TS_ACCEPTED]){
        
        message = MESSAGE_ACCEPTED;
    }
    else if ([status isEqualToString:TS_ARRIVE]) {
        message = MESSAGE_ARRIVE;
    }
    else if ([status isEqualToString:TS_END]){
        message = MESSAGE_END;
    }
    else if ([status isEqualToString:TS_BEGIN]){
        message = MESSAGE_BEGIN;
    }
    else if ([status isEqualToString:TS_REJECTED])  {
        message = MESSAGE_REJECTED;
    }
    
    /// AppDelegate *appdelegate =APP_DELEGATE;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                
                                                                                @"message"       :message,
                                                                                TRIP_STATUS      :status,
                                                                                TRIP_ID          :currTrip.trip_Id,
                                                                                @"content-available":@"1",
                                                                                
                                                                                }];
    
    if ([currTrip.trip_user_device_type isEqualToString:@"ios"]) {
        
        [dict setObject:currTrip.trip_user_device_token forKey:@"ios"];
    }
    else{
        
        [dict setObject:currTrip.trip_user_device_token forKey:@"android"];
    }
    
    //[UtilityClass SetLoaderHidden:NO withTitle:@"Loading..."];
    
    if (currTrip.trip_user_device_token.length>0 ) {
        
    
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
    
    
}


- (void)startMotionDetection {
    
    BOOL b = [CMMotionActivityManager isActivityAvailable];
    
    
    
    if (!b)
    {
       
        return;
    }
    
    CMMotionActivityManager *motionActivityManager =
    [[CMMotionActivityManager alloc] init];
    // register for coremotion notification
    
    [motionActivityManager
     startActivityUpdatesToQueue:[NSOperationQueue mainQueue]
     withHandler:^(CMMotionActivity *activity) {
         
         
         if (activity.unknown)
         {
             _activtiyNameDetactor=@"Not walking";
            
         }
         else if (activity.stationary)
         {
             _activtiyNameDetactor=@"stationary";
           
         }
        
         else if (activity.walking)
         {
             _activtiyNameDetactor=@"Walking";
            
         }
         
         else if (activity.running)
         {
             _activtiyNameDetactor=@"Run";
           
         }
      
         else if (activity.cycling)
         {
             _activtiyNameDetactor=@"Cycling";
             
         }
        
         else if (activity.automotive)
         {
             _activtiyNameDetactor=@"automotive";
            
         }
        
     }];
}



-(MKPolyline *) getPolylineFromArray:(NSMutableArray *)arrDirection
{
    CLLocationCoordinate2D coords[arrDirection.count];
    
    for (int i = 0; i < arrDirection.count; i++) {
        CLLocation *location = [arrDirection objectAtIndex:i];
        coords[i] = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
    }
    
    return   [MKPolyline polylineWithCoordinates:coords count:arrDirection.count];
}

-(float)kilometersfromPlace:(CLLocationCoordinate2D)from andToPlace:(CLLocationCoordinate2D)to  {
    
    CLLocation *userloc = [[CLLocation alloc]initWithLatitude:from.latitude longitude:from.longitude];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:to.latitude longitude:to.longitude];
    
    CLLocationDistance dist = [userloc distanceFromLocation:dest];
    
    //NSLog(@"%f",dist);
    NSString *distance2 = [NSString stringWithFormat:@"%f",dist];
    
    return [distance2 floatValue];
    
}

-(void)setDriverFree{
    
    driverStatus = TS_WAITING;
    defaults_set_object(DRIVER_STATUS, driverStatus);
    defaults_remove(TRIP_ID);
    defaults_remove(@"total_travelled_distance");
    NSString *driverAvailability =@"1";
    [[UpdateUserCurrentLocation sharedInstance]  updateDriverAvailablity:driverAvailability];
}

- (void)stopMusic
{
    [audioPlayer stop];
    
}


- (void)startMusic
{
    
    
    //where you are about to add sound
    
    NSString *path =[[NSBundle mainBundle] pathForResource:@"final tone" ofType:@"mp3"];
    
    NSURL * url = [NSURL fileURLWithPath:path];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    [audioPlayer setVolume:1.0];
    audioPlayer.numberOfLoops = -1;
    [audioPlayer play];
    
}


@end
