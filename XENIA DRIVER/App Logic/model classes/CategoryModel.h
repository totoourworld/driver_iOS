//
//  CategoryModel.h

//
//  Created by SFYT on 15/06/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject
@property(assign, nonatomic) int categoryId;
@property(assign, nonatomic) float cat_base_price;
@property(assign, nonatomic) float cat_fare_per_km;
@property(assign, nonatomic) float cat_fare_per_min;
@property(assign, nonatomic) float service_tax_percentage;
@property(assign, nonatomic) BOOL cat_is_fixed_price;
@property(assign,nonatomic) float cat_prime_time_percentage;
@property(strong,nonatomic) NSString *cat_name;


-(instancetype) initWithDict:(NSDictionary *) dict;

-(NSDictionary *) calculatePrice:(float )distance time:(float)min;
+(NSMutableArray * ) parseResponse:(NSArray * ) arrCategory;
@end
