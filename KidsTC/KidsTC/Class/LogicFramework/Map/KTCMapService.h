//
//  KTCMapService.h
//  KidsTC
//
//  Created by 钱烨 on 8/26/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>


extern NSString *const ktcMapServiceKey;

typedef enum {
    KTCRouteSearchTypeDrive,
    KTCRouteSearchTypeBus,
    KTCRouteSearchTypeWalk
}KTCRouteSearchType;

@interface KTCMapService : NSObject

@property (nonatomic, readonly) BOOL serviceOnline;

+ (instancetype)sharedService;

- (void)startService;

- (void)startUpdateLocation;

- (void)stopUpdateLocation;

- (void)stopService;

- (void)getCoordinateWithCity:(NSString *)cityName
                      address:(NSString *)address
                      succeed:(void(^)(BMKGeoCodeResult *result))succeed
                      failure:(void(^)(NSError *error))failure;

- (void)getAddressDescriptionWithCoordinate:(CLLocationCoordinate2D)coordinate
                                    succeed:(void(^)(BMKReverseGeoCodeResult *result))succeed
                                    failure:(void(^)(NSError *error))failure;

- (void)startRouteSearchWithType:(KTCRouteSearchType)type
                 startCoordinate:(CLLocationCoordinate2D)start
                   endCoordinate:(CLLocationCoordinate2D)end
                         succeed:(void(^)(id result))succeed
                         failure:(void(^)(NSError *error))failure;

+ (NSString *)timeDescriptionWithBMKTime:(BMKTime *)time;

@end
