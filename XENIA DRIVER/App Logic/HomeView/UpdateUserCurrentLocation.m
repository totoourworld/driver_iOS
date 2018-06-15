//
//  UpdateUserCurrentLocation.m
//  TeamJoe
//
//  Created by SFYT on 24/05/16.
//  Copyright © 2016 ZappDesignTemplates. All rights reserved.
//
#import <GrepixKit/GrepixKit.h>
#import "UpdateUserCurrentLocation.h"
#import <MapKit/MapKit.h>
////#import "Constants.h"
#import "AppDelegate.h"
//#import "CallAPI.h"
#import "WebCallConstants.h"
#import "LeftViewController.h"
//#import "nsuserdefaults-helper.h"
@implementation UpdateUserCurrentLocation
{
    float distance;
    NSTimer *aTimer;
    int secondCount;
    int apiCount;
    CLLocation *preLocation;
    float angle;
    NSString  *isAvailable;
    BOOL isFatchingCountry;
    
    
}
+ (UpdateUserCurrentLocation *)sharedInstance {
    static UpdateUserCurrentLocation *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    
    return _sharedInstance;
}

-(void) startUpdateCurrentLocation
{
    isAvailable=@"1";
    isFatchingCountry=NO;
    angle=0;
    distance=0;
    [self stopUpdateCurrentLocation];
    aTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(updateLocation)
                                            userInfo:nil
                                             repeats:YES];
    //[self updateLocationAfterFiveM];
}



-(void) updateLocation
{
    
    angle=0;
    secondCount++;
    
    if([APP_DELEGATE currLoc].latitude>0)
    {
        CLLocation * loc=[[CLLocation alloc]  initWithLatitude:[APP_DELEGATE currLoc].latitude longitude:[APP_DELEGATE currLoc].longitude];
        
        if(preLocation!=nil)
        {
            
            
            distance =[self calculateDistanceInMilesFrom:preLocation to:loc];
        }
        if(preLocation==nil || distance>100)
        {
            
            if([APP_DELEGATE currLoc].latitude>0)
            {
                
                
                preLocation=loc;
                
                if (loc !=nil /*&& city.length>0 && country.length>0*/) {
                    
                    
                    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
                    
                    NSString *driverID = [dict1 objectForKey:P_DRIVER_ID];
                    
                    NSDictionary *dict;
                    
                    {
                        dict=@{P_DRIVER_LAT:@(preLocation.coordinate.latitude),
                               P_DRIVER_LNG:@(preLocation.coordinate.longitude),
                               P_DRIVER_ID:driverID,
                               
                               P_DRIVER_AVAILAILITY: isAvailable,
                               };
                    }
                    
                    [APP_CallAPI gcURL:BASE_URL_DRIVER app:UPDATE_DRIVER_PROFILE
                                  data:dict
                     isShowErrorAlert:NO
                       completionBlock:^(id results, NSError *error) {
                           apiCount++;
                           if (error == nil) {
                               secondCount=0;
                               apiCount =0;
                               
                              
                               
                           }
                           else{
                               if (apiCount<3) {
                                   
                                   [self updateLocation];
                               }
                           }
                       }];
                    
                }
                
            }
        }
        else{
            [self checkAndUpdateLocation];
        }
    }
    else{
        [self checkAndUpdateLocation];
    }
}

-(void)  checkAndUpdateLocation
{
    if(secondCount>(60*5))
    {
        [self updateLocationAfterFiveM];
        secondCount=0;
    }
}



-(void) updateLocationAfterFiveM
{
    apiCount =0;
    CLLocation * loc=[[CLLocation alloc]  initWithLatitude:[APP_DELEGATE currLoc].latitude longitude:[APP_DELEGATE currLoc].longitude];
    
    
    preLocation=loc;
    
    
    
    if ([APP_DELEGATE currLoc].latitude>0) {
        
        
        
        NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
        
        NSString *driverID = [dict1 objectForKey:P_DRIVER_ID];
        NSDictionary *dict;
        
        {
            dict=@{P_DRIVER_LAT:@(preLocation.coordinate.latitude),
                   P_DRIVER_LNG:@(preLocation.coordinate.longitude),
                   P_DRIVER_ID:driverID,
                   
                   P_DRIVER_AVAILAILITY:isAvailable,
                   };
        }
        
        [APP_CallAPI gcURL:BASE_URL_DRIVER app:UPDATE_DRIVER_PROFILE
                      data:dict
           isShowErrorAlert:NO
           completionBlock:^(id results, NSError *error) {
               if (error == nil) {
                   secondCount=0;
                   
                   
                   
               }
           }];
        
    }
}


-(void) updateLocationWhenLogin
{
    if([APP_DELEGATE currLoc].latitude>0)
    {

    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    NSString *driverID = [dict1 objectForKey:P_DRIVER_ID];
    
   
    NSDictionary *dict;
    if([APP_DELEGATE currLoc].latitude>0)
    {
        CLLocation * cLocation=[[CLLocation alloc]  initWithLatitude:[APP_DELEGATE currLoc].latitude longitude:[APP_DELEGATE currLoc].longitude];
        
       
        
        dict=@{P_DRIVER_LAT:@(cLocation.coordinate.latitude),
               P_DRIVER_LNG:@(cLocation.coordinate.longitude),
               P_DRIVER_ID:driverID};
    }
    /// CallAPI *callapi = [[CallAPI alloc] init];
    [APP_CallAPI gcURL:BASE_URL_DRIVER app:UPDATE_DRIVER_PROFILE
                  data:dict
       isShowErrorAlert:NO
       completionBlock:^(id results, NSError *error) {
           if (error == nil) {
               
               
           }
       }];
    //
        NSLog(@"updateLocation...............");
}
}





-(void) updateDriverAvailablity:(NSString *)available{
    
    isAvailable=available;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"change_switch" object:@{@"isAvailable":available}];
    
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    NSString *driverID = [dict1 objectForKey:P_DRIVER_ID];
    NSDictionary *dict;
    dict=@{
           P_DRIVER_AVAILAILITY:available, P_DRIVER_ID:driverID};
    
    
    [APP_CallAPI gcURL:BASE_URL_DRIVER app:UPDATE_DRIVER_PROFILE
                  data:dict
     isShowErrorAlert:NO 
       completionBlock:^(id results, NSError *error) {
           if (error == nil) {
               
               [APP_DELEGATE setUserDict:[results objectForKey:P_RESPONSE]];
               
               
           }
       }];
    
}





-(void)getLocation:(CLLocation *)locations withcompletionHandler : (void(^)(NSArray *arr))completionHandler{
    
    
    
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:locations completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks,
                                                                   NSError * _Nullable error) {
        
        completionHandler(placemarks);
        
    }];
    
}


- (float)calculateDistanceInMilesFrom:(CLLocation *)currentLocation
                                   to:(CLLocation *)destinationLocation {
    
    float distanceCovered =
    [currentLocation distanceFromLocation:destinationLocation];
    
    return distanceCovered;
}
-(void) stopUpdateCurrentLocation
{
    if([aTimer isValid])
    {
        [aTimer  invalidate];
        aTimer=nil;
    }
    preLocation=nil;
}
@end
