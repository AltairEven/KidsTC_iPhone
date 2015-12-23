//
//  KTCMapUtil.m
//  KidsTC
//
//  Created by Altair on 12/16/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "KTCMapUtil.h"
#import "RouteAnnotation.h"

NSString *const kRouteDescriptionKey = @"kRouteDescriptionKey";
NSString *const kRouteDurationDescriptionKey = @"kRouteDurationDescriptionKey";
NSString *const kRouteLineStepsKey = @"kRouteLineStepsKey";

@implementation KTCMapUtil

+ (NSDictionary *)drawRoutePolyLineOnMapView:(BMKMapView *)mapView withStartCoord:(CLLocationCoordinate2D)start endCoord:(CLLocationCoordinate2D)end andDrivingRouteResult:(BMKDrivingRouteResult *)result autoResetToFit:(BOOL)autoReset {
    if (!result || ![result isKindOfClass:[BMKDrivingRouteResult class]]) {
        return nil;
    }
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    BMKDrivingRouteLine *routeLine = [result.routes firstObject];
    [tempDic setObject:[NSString stringWithFormat:@"距离%@", [GToolUtil distanceDescriptionWithMeters:routeLine.distance]] forKey:kRouteDescriptionKey];
    [tempDic setObject:[NSString stringWithFormat:@"预计耗时%@", [KTCMapService timeDescriptionWithBMKTime:routeLine.duration]] forKey:kRouteDurationDescriptionKey];
    if ([routeLine.steps count] > 0) {
        [tempDic setObject:routeLine.steps forKey:kRouteLineStepsKey];
        [KTCMapUtil cleanMap:mapView];
        [KTCMapUtil drawRouteWithStartCoord:start endCoord:end routeLineSteps:routeLine.steps onMapView:mapView autoResetToFit:YES];
    }
    return [NSDictionary dictionaryWithDictionary:tempDic];
}

+ (NSDictionary *)drawRoutePolyLineOnMapView:(BMKMapView *)mapView withStartCoord:(CLLocationCoordinate2D)start endCoord:(CLLocationCoordinate2D)end andTransitRouteResult:(BMKTransitRouteResult *)result autoResetToFit:(BOOL)autoReset {
    if (!result || ![result isKindOfClass:[BMKTransitRouteResult class]]) {
        return nil;
    }
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    
    BMKTransitRouteLine *routeLine = [((BMKTransitRouteResult *)result).routes firstObject];
    [tempDic setObject:[NSString stringWithFormat:@"距离%@", [GToolUtil distanceDescriptionWithMeters:routeLine.distance]] forKey:kRouteDescriptionKey];
    [tempDic setObject:[NSString stringWithFormat:@"预计耗时%@", [KTCMapService timeDescriptionWithBMKTime:routeLine.duration]] forKey:kRouteDurationDescriptionKey];
    if ([routeLine.steps count] > 0) {
        [tempDic setObject:routeLine.steps forKey:kRouteLineStepsKey];
        [KTCMapUtil cleanMap:mapView];
        [KTCMapUtil drawRouteWithStartCoord:start endCoord:end routeLineSteps:routeLine.steps onMapView:mapView autoResetToFit:YES];
    }
    return [NSDictionary dictionaryWithDictionary:tempDic];
}

+ (NSDictionary *)drawRoutePolyLineOnMapView:(BMKMapView *)mapView withStartCoord:(CLLocationCoordinate2D)start endCoord:(CLLocationCoordinate2D)end andWalkingRouteResult:(BMKWalkingRouteResult *)result autoResetToFit:(BOOL)autoReset {
    if (!result || ![result isKindOfClass:[BMKWalkingRouteResult class]]) {
        return nil;
    }
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    
    BMKWalkingRouteLine *routeLine = [result.routes firstObject];
    [tempDic setObject:[NSString stringWithFormat:@"距离%@", [GToolUtil distanceDescriptionWithMeters:routeLine.distance]] forKey:kRouteDescriptionKey];
    [tempDic setObject:[NSString stringWithFormat:@"预计耗时%@", [KTCMapService timeDescriptionWithBMKTime:routeLine.duration]] forKey:kRouteDurationDescriptionKey];
    if ([routeLine.steps count] > 0) {
        [tempDic setObject:routeLine.steps forKey:kRouteLineStepsKey];
        [KTCMapUtil cleanMap:mapView];
        [KTCMapUtil drawRouteWithStartCoord:start endCoord:end routeLineSteps:routeLine.steps onMapView:mapView autoResetToFit:YES];
    }
    return [NSDictionary dictionaryWithDictionary:tempDic];
}

+ (BMKPolyline *)drawRouteWithStartCoord:(CLLocationCoordinate2D)start endCoord:(CLLocationCoordinate2D)end routeLineSteps:(NSArray *)steps onMapView:(BMKMapView *)mapView autoResetToFit:(BOOL)autoReset {
    if (![steps isKindOfClass:[NSArray class]] || [steps count] == 0) {
        return nil;
    }
    
    // 计算路线方案中的路段数目
    NSInteger size = [steps count];
    int planPointCounts = 0;
    for (int i = 0; i < size; i++) {
        if(i==0){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = start;
            item.title = @"起点";
            item.type = 0;
            [mapView addAnnotation:item]; // 添加起点标注
            
        }else if(i==size-1){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = end;
            item.title = @"终点";
            item.type = 1;
            [mapView addAnnotation:item]; // 添加起点标注
        }
        BMKRouteStep* step = [steps objectAtIndex:i];
        if ([step isKindOfClass:[BMKDrivingStep class]]) {
            BMKDrivingStep *stepOver = (BMKDrivingStep *)step;
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = stepOver.entrace.location;
            item.title = stepOver.entraceInstruction;
            item.degree = stepOver.direction * 30;
            item.type = 4;
            [mapView addAnnotation:item];
        } else if ([step isKindOfClass:[BMKTransitStep class]]) {
            BMKTransitStep *stepOver = (BMKTransitStep *)step;
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = stepOver.entrace.location;
            item.title = stepOver.instruction;
            item.type = 3;
            [mapView addAnnotation:item];
        } else if ([step isKindOfClass:[BMKWalkingStep class]]) {
            BMKWalkingStep *stepOver = (BMKWalkingStep *)step;
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = stepOver.entrace.location;
            item.title = stepOver.entraceInstruction;
            item.degree = stepOver.direction * 30;
            item.type = 4;
            [mapView addAnnotation:item];
        }
        
        //轨迹点总数累计
        planPointCounts += step.pointsCount;
    }
    //轨迹点
    BMKMapPoint *temppoints = new BMKMapPoint[planPointCounts];
    int i = 0;
    for (int j = 0; j < size; j++) {
        BMKRouteStep* transitStep = [steps objectAtIndex:j];
        int k=0;
        for(k=0;k<transitStep.pointsCount;k++) {
            temppoints[i].x = transitStep.points[k].x;
            temppoints[i].y = transitStep.points[k].y;
            i++;
        }
        
    }
    // 通过points构建BMKPolyline
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    [mapView addOverlay:polyLine]; // 添加路线overlay
    delete []temppoints;
    
    if (autoReset) {
        [KTCMapUtil resetMapView:mapView toFitPolyLine:polyLine];
    }
    
    return polyLine;
}

+ (void)resetMapView:(BMKMapView *)mapView toFitPolyLine:(BMKPolyline *)polyLine {
    if (!polyLine) {
        return;
    }
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX - 500 , ltY - 500);
    rect.size = BMKMapSizeMake(rbX - ltX + 1000, rbY - ltY + 1000);
    [mapView setVisibleMapRect:rect];
}

+ (void)resetMapView:(BMKMapView *)mapView toFitStart:(CLLocationCoordinate2D)start andDestination:(CLLocationCoordinate2D)destinate {
    CGFloat ltX, ltY, rbX, rbY;
    BMKMapPoint startPt = BMKMapPointForCoordinate(start);
    ltX = startPt.x, ltY = startPt.y;
    rbX = startPt.x, rbY = startPt.y;
    BMKMapPoint endPt = BMKMapPointForCoordinate(destinate);
    if (endPt.x < ltX) {
        ltX = endPt.x;
    }
    if (endPt.x > rbX) {
        rbX = endPt.x;
    }
    if (endPt.y > ltY) {
        ltY = endPt.y;
    }
    if (endPt.y < rbY) {
        rbY = endPt.y;
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX - 500 , ltY - 500);
    rect.size = BMKMapSizeMake(rbX - ltX + 1000, rbY - ltY + 1000);
    [mapView setVisibleMapRect:rect];
}

+ (void)resetMapView:(BMKMapView *)mapView toFitLocations:(NSArray<CLLocation *> *)locations {
    if (!locations || ![locations isKindOfClass:[NSArray class]]) {
        return;
    }
    if ([locations count] < 1) {
        return;
    }
    CGFloat ltX, ltY, rbX, rbY;
    CLLocation *firstLocation = [locations firstObject];
    BMKMapPoint pt = BMKMapPointForCoordinate(firstLocation.coordinate);
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < [locations count]; i++) {
        CLLocation *location = [locations objectAtIndex:i];
        BMKMapPoint pt = BMKMapPointForCoordinate(location.coordinate);
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX - 500 , ltY - 500);
    rect.size = BMKMapSizeMake(rbX - ltX + 1000, rbY - ltY + 1000);
    [mapView setVisibleMapRect:rect];
}


+ (void)cleanMap:(BMKMapView *)mapView {
    NSArray* array = [NSArray arrayWithArray:mapView.annotations];
    [mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:mapView.overlays];
    [mapView removeOverlays:array];
}


+ (UIImage *)startAnnotationImage {
    return [UIImage imageWithContentsOfFile:[KTCMapUtil getMyBundlePath:@"images/icon_nav_start.png"]];
}

+ (UIImage *)endAnnotationImage {
    return [UIImage imageWithContentsOfFile:[KTCMapUtil getMyBundlePath:@"images/icon_nav_end.png"]];
}

+ (UIImage *)poiAnnotationImage {
    return [UIImage imageNamed:@"annotation_poi"];
}

+ (NSString*)getMyBundlePath:(NSString *)filename {
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent:filename];
        return s;
    }
    return nil ;
}

@end
