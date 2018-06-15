//
//  DirectionModel.h

//
//  Created by SFYT on 12/06/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface DirectionModel : NSObject
@property(assign,nonatomic) float distance; // miles
@property(assign,nonatomic) float duration;
@property(strong,nonatomic) NSMutableArray * arrDirectionLatLng;
@property(strong,nonatomic) NSMutableArray * arrManeuvers;

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView    currentLocation:(CLLocation *)currentLocation;
-(void)zoomToPolyLine: (MKMapView*)map polyline: (MKPolyline*)polyline animated: (BOOL)animated;

-(MKPolyline *) getPolyline;
@end
