//
//  RouteAnnotation.h
//  KidsTC
//
//  Created by Altair on 12/16/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface RouteAnnotation : BMKPointAnnotation

@property (nonatomic, assign) NSInteger type; //<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点

@property (nonatomic, assign) NSUInteger tag;

@property (nonatomic, assign) NSInteger degree;

+ (BMKAnnotationView*)routeAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation;

@end
