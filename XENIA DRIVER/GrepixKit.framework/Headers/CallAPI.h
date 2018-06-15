//
//  CallAPI.h
//  Application
//
//  Created by Grepix Infotech.
//  Copyright (c) 2017 Grepix Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CallAPI : NSObject
    
- (void) gcURL:(NSString*)bURL app:(NSString*)aURL
          data:(NSDictionary*)data
        completionBlock:(void (^)(id results, NSError *error)) block;
    
    
- (void)gcURL:(NSString*)bUrl  app:(NSString *)aURL
             data:(NSDictionary *)data isShowErrorAlert:(BOOL) isShowErrorAlert
  completionBlock:(void (^)(id results, NSError *error))block;

    
//- (void) WebCallWithURL:(NSString*)BaseUrl url:(NSString*) strURL ForDict:(NSDictionary*) dict
//        completionBlock:(void (^)(id results, NSError *error)) block;

//- (void)WebCallWithURL:(NSString*)BaseUrl  url:(NSString *)strURL
//               ForDict:(NSDictionary *)dict isShowErrorAlert:(BOOL) isShowErrorAlert
//       completionBlock:(void (^)(id results, NSError *error))block;
- (void) CancelRequest;
    
    

@end
