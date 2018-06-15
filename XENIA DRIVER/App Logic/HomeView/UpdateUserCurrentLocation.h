//
//  UpdateUserCurrentLocation.h
//  TeamJoe
//
//  Created by SFYT on 24/05/16.
//  Copyright © 2016 ZappDesignTemplates. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateUserCurrentLocation : NSObject
+ (UpdateUserCurrentLocation *)sharedInstance ;
-(void) startUpdateCurrentLocation;
-(void) stopUpdateCurrentLocation;
-(void)updateLocationWhenLogin;
-(void) updateDriverAvailablity:(NSString *)available;
@end
