//
//  UserModel.h
//  TaxiDriver
//
//  Created by SFYT on 22/06/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property(strong,nonatomic)  NSString *  userId;
@property(strong,nonatomic)  NSString *  u_fname;
@property(strong,nonatomic)  NSString *  u_lname;

@property(nonatomic,strong) NSString *deviceToken;
@property(nonatomic,strong) NSString *deviceType;

@property(assign,nonatomic) float rating;
@property(nonatomic,assign) double lat;
@property(assign,nonatomic) double lng;
@property(assign,nonatomic) float distance;
-(instancetype)initItemWithDict:(NSDictionary *)dict;
@end
