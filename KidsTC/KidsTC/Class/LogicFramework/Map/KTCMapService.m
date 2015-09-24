//
//  KTCMapService.m
//  KidsTC
//
//  Created by 钱烨 on 8/26/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCMapService.h"

NSString *const ktcMapServiceKey = @"KifRsgtkbracIAf486Rtm25b";

typedef void(^GeoCodeSucceedBlock)(BMKGeoCodeResult *result);
typedef void(^GeoCodeFalureBlock)(NSError *error);
typedef void(^ReverseGeoCodeSucceedBlock)(BMKReverseGeoCodeResult *result);
typedef void(^ReverseGeoCodeFalureBlock)(NSError *error);

static KTCMapService *sharedInstance = nil;

@interface KTCMapService () <BMKGeneralDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKMapManager *mapManager;

@property (nonatomic, strong) BMKLocationService *locationService;

@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;

@property (nonatomic, copy) GeoCodeSucceedBlock geoCodeSucceedBlock;

@property (nonatomic, copy) GeoCodeFalureBlock geoCodeFalureBlock;

@property (nonatomic, copy) ReverseGeoCodeSucceedBlock reverseGeoCodeSucceedBlock;

@property (nonatomic, copy) ReverseGeoCodeFalureBlock reverseGeoCodeFalureBlock;

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
    if (![userLocation isUpdating]) {
        KTCLocation *currentLocation = [[KTCLocation alloc] initWithLocation:userLocation.location locationDescription:userLocation.title];
        currentLocation.moreDescription = userLocation.subtitle;
        [[GConfig sharedConfig] setCurrentLocation:currentLocation];
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    [[iToast makeText:@"定位失败"] show];
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


@end
