//
//  GoogleDirectionSource.h
//  XENIA DRIVER
//
//  Created by SFYT on 12/06/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "DirectionModel.h"
@interface GoogleDirectionSource : NSObject
@property(strong,nonatomic) CLLocation * source;
@property(strong,nonatomic) CLLocation * destination;
@property(strong,nonatomic) NSString * dropAddress;
@property(strong,nonatomic) NSString * pickAddress;

-(instancetype)initWithSource:(CLLocation *) sourse destination:(CLLocation *) destination;

-(void) findDirectionWithCompletionBlock:(void (^)(id results, NSError *error)) block;
@end
