//
//  KTCMapService.m
//  KidsTC
//
//  Created by 钱烨 on 8/26/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCMapService.h"

#ifdef KIDSTC_DEBUG

NSString *const ktcMapServiceKey = @"H6xdjIgWwZQO0K5oHAXeu11H";

#else

NSString *const ktcMapServiceKey = @"KifRsgtkbracIAf486Rtm25b";

#endif

static NSDate *lastUpdateDate = nil;

typedef void(^GeoCodeSucceedBlock)(BMKGeoCodeResult *result);
typedef void(^GeoCodeFalureBlock)(NSError *error);
typedef void(^ReverseGeoCodeSucceedBlock)(BMKReverseGeoCodeResult *result);
typedef void(^ReverseGeoCodeFalureBlock)(NSError *error);
typedef void(^RouteSearchSucceedBlock)(id result);
typedef void(^RouteSearchFalureBlock)(NSError *error);

static KTCMapService *sharedInstance = nil;

@interface KTCMapService () <BMKGeneralDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, BMKRouteSearchDelegate>

@property (nonatomic, strong) BMKMapManager *mapManager;

@property (nonatomic, strong) BMKLocationService *locationService;

@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;

@property (nonatomic, strong) BMKRouteSearch *routeSearch;

@property (nonatomic, copy) GeoCodeSucceedBlock geoCodeSucceedBlock;

@property (nonatomic, copy) GeoCodeFalureBlock geoCodeFalureBlock;

@property (nonatomic, copy) ReverseGeoCodeSucceedBlock reverseGeoCodeSucceedBlock;

@property (nonatomic, copy) ReverseGeoCodeFalureBlock reverseGeoCodeFalureBlock;

@property (nonatomic, copy) RouteSearchSucceedBlock routeSearchSucceedBlock;

@property (nonatomic, copy) RouteSearchFalureBlock routeSearchFalureBlock;

- (void)initializateLocationService;

@end

@implementation KTCMapService

+ (instancetype)sharedService {
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        sharedInstance = [[KTCMapService alloc] init];
    });
    return sharedInstance;
}

#pragma mark BMKGeneralDelegate

- (void)onGetPermissionState:(int)iError {
    if (iError == E_PERMISSIONCHECK_OK) {
        _serviceOnline = YES;
        [self initializateLocationService];
    } else {
        _serviceOnline = NO;
    }
}

#pragma mark BMKLocationServiceDelegate

- (void)willStartLocatingUser {
    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    if (!lastUpdateDate || [lastUpdateDate timeIntervalSinceDate:[NSDate date]] < -60) {
        lastUpdateDate = [NSDate date];
        
        KTCLocation *currentLocation = [[KTCLocation alloc] initWithLocation:userLocation.location locationDescription:userLocation.title];
        currentLocation.moreDescription = userLocation.subtitle;
        [self getAddressDescriptionWithCoordinate:userLocation.location.coordinate succeed:^(BMKReverseGeoCodeResult *result) {
            BMKPoiInfo *poi = [result.poiList firstObject];
            currentLocation.locationDescription = poi.name;
            [[GConfig sharedConfig] setCurrentLocation:currentLocation];
        } failure:nil];
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    [[iToast makeText:@"定位失败，请检查您手机的定位设置"] show];
}

#pragma mark BMKGeoCodeSearchDelegate

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        if (self.geoCodeSucceedBlock) {
            self.geoCodeSucceedBlock(result);
        }
    } else {
        if (self.geoCodeFalureBlock) {
            NSError *retError = [NSError errorWithDomain:@"KTCMapService geo code search result." code:error userInfo:nil];
            self.geoCodeFalureBlock(retError);
        }
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                           result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        if (self.reverseGeoCodeSucceedBlock) {
            self.reverseGeoCodeSucceedBlock(result);
        }
    } else {
        if (self.reverseGeoCodeFalureBlock) {
            NSError *retError = [NSError errorWithDomain:@"KTCMapService geo code search result." code:error userInfo:nil];
            self.reverseGeoCodeFalureBlock(retError);
        }
    }
}

#pragma mark BMKRouteSearchDelegate

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        if (self.routeSearchSucceedBlock) {
            self.routeSearchSucceedBlock(result);
        }
    } else {
        if (self.routeSearchFalureBlock) {
            NSError *retError = [NSError errorWithDomain:@"KTCMapService bus route search result." code:error userInfo:nil];
            self.routeSearchFalureBlock(retError);
        }
    }
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        if (self.routeSearchSucceedBlock) {
            self.routeSearchSucceedBlock(result);
        }
    } else {
        if (self.routeSearchFalureBlock) {
            NSError *retError = [NSError errorWithDomain:@"KTCMapService drive route search result." code:error userInfo:nil];
            self.routeSearchFalureBlock(retError);
        }
    }
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        if (self.routeSearchSucceedBlock) {
            self.routeSearchSucceedBlock(result);
        }
    } else {
        if (self.routeSearchFalureBlock) {
            NSError *retError = [NSError errorWithDomain:@"KTCMapService walk route search result." code:error userInfo:nil];
            self.routeSearchFalureBlock(retError);
        }
    }
}

#pragma mark Private methods


- (void)initializateLocationService {
    if (!self.locationService) {
        self.locationService = [[BMKLocationService alloc] init];
        self.locationService.delegate = self;
    }
    [self.locationService startUserLocationService];
}


#pragma mark Public methods

- (void)startService {
    if (!self.mapManager) {
        self.mapManager = [[BMKMapManager alloc] init];
    }
    [self.mapManager start:ktcMapServiceKey generalDelegate:self];
}

- (void)startUpdateLocation {
    if (!self.locationService) {
        self.locationService = [[BMKLocationService alloc] init];
        self.locationService.delegate = self;
    }
    [self.locationService startUserLocationService];
}

- (void)stopUpdateLocation {
    [self.locationService stopUserLocationService];
}

- (void)stopService {
    [self.mapManager stop];
    [self.locationService stopUserLocationService];
    _serviceOnline = NO;
    if (self.geoCodeSearch) {
        self.geoCodeSearch.delegate = nil;
    }
}

- (void)getCoordinateWithCity:(NSString *)cityName
                      address:(NSString *)address
                      succeed:(void (^)(BMKGeoCodeResult *))succeed
                      failure:(void (^)(NSError *))failure {
    self.geoCodeSucceedBlock = succeed;
    self.geoCodeFalureBlock = failure;
    if (!self.geoCodeSearch) {
        self.geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
        self.geoCodeSearch.delegate = self;
    }
    BMKGeoCodeSearchOption *option = [[BMKGeoCodeSearchOption alloc] init];
    option.address = address;
    option.city = cityName;
    BOOL bRet = [self.geoCodeSearch geoCode:option];
    if (!bRet && failure) {
        NSError *error = [NSError errorWithDomain:@"KTCMapService geo code search." code:-1 userInfo:nil];
        failure(error);
    }
}

- (void)getAddressDescriptionWithCoordinate:(CLLocationCoordinate2D)coordinate
                                    succeed:(void (^)(BMKReverseGeoCodeResult *))succeed
                                    failure:(void (^)(NSError *))failure {
    self.reverseGeoCodeSucceedBlock = succeed;
    self.reverseGeoCodeFalureBlock = failure;
    if (!self.geoCodeSearch) {
        self.geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
        self.geoCodeSearch.delegate = self;
    }
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = coordinate;
    BOOL bRet = [self.geoCodeSearch reverseGeoCode:option];
    if (!bRet && failure) {
        NSError *error = [NSError errorWithDomain:@"KTCMapService geo code search." code:-1 userInfo:nil];
        failure(error);
    }
}

- (void)startRouteSearchWithType:(KTCRouteSearchType)type
                 startCoordinate:(CLLocationCoordinate2D)start
                   endCoordinate:(CLLocationCoordinate2D)end
                         succeed:(void (^)(id))succeed
                         failure:(void (^)(NSError *))failure {
    self.routeSearchSucceedBlock = succeed;
    self.routeSearchFalureBlock = failure;
    if (!self.routeSearch) {
        self.routeSearch = [[BMKRouteSearch alloc] init];
        self.routeSearch.delegate = self;
    }
    
    BMKPlanNode *startNode = [[BMKPlanNode alloc] init];
    startNode.pt = start;
    
    BMKPlanNode *endNode = [[BMKPlanNode alloc] init];
    endNode.pt = end;
    
    BOOL bRet = NO;
    switch (type) {
        case KTCRouteSearchTypeDrive:
        {
            BMKDrivingRoutePlanOption *option = [[BMKDrivingRoutePlanOption alloc] init];
            option.from = startNode;
            option.to = endNode;
            bRet = [self.routeSearch drivingSearch:option];
        }
            break;
        case KTCRouteSearchTypeBus:
        {
            BMKTransitRoutePlanOption *option = [[BMKTransitRoutePlanOption alloc] init];
            option.from = startNode;
            option.to = endNode;
            option.city = @"上海";
            bRet = [self.routeSearch transitSearch:option];
        }
            break;
        case KTCRouteSearchTypeWalk:
        {
            BMKWalkingRoutePlanOption *option = [[BMKWalkingRoutePlanOption alloc] init];
            option.from = startNode;
            option.to = endNode;
            bRet = [self.routeSearch walkingSearch:option];
        }
            break;
        default:
            break;
    }
    if (!bRet && failure) {
        NSError *error = [NSError errorWithDomain:@"KTCMapService route search." code:-1 userInfo:nil];
        failure(error);
    }
}

#pragma mark Tools

+ (NSString *)timeDescriptionWithBMKTime:(BMKTime *)time {
    if (!time) {
        return @"";
    }
    NSMutableString *timeDes = [NSMutableString stringWithString:@""];
    if (time.dates > 0) {
        [timeDes appendFormat:@"%d天", time.dates];
    }
    if (time.hours > 0) {
        [timeDes appendFormat:@"%d小时", time.hours];
    }
    if (time.minutes > 0) {
        if (time.dates > 0 && time.hours == 0) {
            [timeDes appendFormat:@"零%d分", time.minutes];
        } else {
            [timeDes appendFormat:@"%d分", time.minutes];
        }
    }
    if (time.seconds > 0) {
        if ((time.dates > 0 || time.hours > 0) && time.minutes == 0) {
            [timeDes appendFormat:@"零%d秒", time.seconds];
        } else {
            [timeDes appendFormat:@"%d秒", time.seconds];
        }
    }
    return [NSString stringWithString:timeDes];
}

@end
