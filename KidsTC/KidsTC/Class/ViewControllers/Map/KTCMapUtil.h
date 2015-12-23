//
//  KTCMapUtil.h
//  KidsTC
//
//  Created by Altair on 12/16/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTCMapService.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

extern NSString *const kRouteDescriptionKey;
extern NSString *const kRouteDurationDescriptionKey;
extern NSString *const kRouteLineStepsKey;

@interface KTCMapUtil : NSObject

+ (NSDictionary *)drawRoutePolyLineOnMapView:(BMKMapView *)mapView withStartCoord:(CLLocationCoordinate2D)start endCoord:(CLLocationCoordinate2D)end andDrivingRouteResult:(BMKDrivingRouteResult *)result autoResetToFit:(BOOL)autoReset;

+ (NSDictionary *)drawRoutePolyLineOnMapView:(BMKMapView *)mapView withStartCoord:(CLLocationCoordinate2D)start endCoord:(CLLocationCoordinate2D)end andTransitRouteResult:(BMKTransitRouteResult *)result autoResetToFit:(BOOL)autoReset;

+ (NSDictionary *)drawRoutePolyLineOnMapView:(BMKMapView *)mapView withStartCoord:(CLLocationCoordinate2D)start endCoord:(CLLocationCoordinate2D)end andWalkingRouteResult:(BMKWalkingRouteResult *)result autoResetToFit:(BOOL)autoReset;

+ (BMKPolyline *)drawRouteWithStartCoord:(CLLocationCoordinate2D)start endCoord:(CLLocationCoordinate2D)end routeLineSteps:(NSArray *)steps onMapView:(BMKMapView *)mapView autoResetToFit:(BOOL)autoReset;

//根据polyline设置地图范围
+ (void)resetMapView:(BMKMapView *)mapView toFitPolyLine:(BMKPolyline *)polyLine;

//根据起始和结束点设置地图范围
+ (void)resetMapView:(BMKMapView *)mapView toFitStart:(CLLocationCoordinate2D)start andDestination:(CLLocationCoordinate2D)destinate;

+ (void)resetMapView:(BMKMapView *)mapView toFitLocations:(NSArray<CLLocation *> *)locations;

+ (void)cleanMap:(BMKMapView *)mapView;

//views

+ (UIImage *)startAnnotationImage;

+ (UIImage *)endAnnotationImage;

+ (UIImage *)poiAnnotationImage;

+ (NSString*)getMyBundlePath:(NSString *)filename;

@end
