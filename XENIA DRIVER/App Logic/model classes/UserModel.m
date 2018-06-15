//
//  UserModel.m
//  TaxiDriver
//
//  Created by SFYT on 22/06/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
-(instancetype)initItemWithDict:(NSDictionary *)dict;
{
    self = [super init];
    if (self) {
        
        self.userId=[dict objectForKey:@"user_id"];
        self.u_fname=[dict objectForKey:@"u_fname"];
        self.u_lname=[dict objectForKey:@"u_lname"];
        
        self.deviceToken=[dict objectForKey:@"d_device_token"];
        self.deviceType=[dict objectForKey:@"d_device_type"];
        self.lat = [[dict objectForKey:@"u_lat"] doubleValue];
        self.lng = [[dict objectForKey:@"u_lng"] doubleValue];
        
        
        
        // km
        self.distance=[[dict objectForKey:@"distance"] floatValue];
    }
    return self;
}
@end
