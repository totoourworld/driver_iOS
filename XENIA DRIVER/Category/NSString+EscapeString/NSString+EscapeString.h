//
//  NSString+EscapeString.h
//  Frankly_App
//
//  Created by   on 17/04/14.
//  Copyright (c) 2013  . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EscapeString)
+ (NSString*) GET_UN_ESCAPED_STRING:(NSString*) str;
+ (NSString*) GET_ESCAPED_STRING:(NSString*) str;
@end
