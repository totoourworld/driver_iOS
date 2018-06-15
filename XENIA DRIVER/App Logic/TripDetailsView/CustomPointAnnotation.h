//
//  CustomPointAnnotation.h

//
//  Created by SFYT on 20/06/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CustomPointAnnotation : MKPointAnnotation
@property(strong, nonatomic) NSString *type;
-(instancetype) initWithType:(NSString * ) type;

@end
