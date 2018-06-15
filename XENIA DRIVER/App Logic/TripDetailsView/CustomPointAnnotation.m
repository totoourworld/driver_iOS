//
//  CustomPointAnnotation.m

//
//  Created by SFYT on 20/06/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import "CustomPointAnnotation.h"

@implementation CustomPointAnnotation

-(instancetype) initWithType:(NSString * ) type
{
    self = [super init];
    if (self) {
        self.type=type;
    }
    return self;
}
@end
