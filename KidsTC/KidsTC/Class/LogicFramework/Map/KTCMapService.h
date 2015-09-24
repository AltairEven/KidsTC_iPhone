//
//  KTCMapService.h
//  KidsTC
//
//  Created by 钱烨 on 8/26/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>

extern NSString *const ktcMapServiceKey;

@interface KTCMapService : NSObject

@property (nonatomic, readonly) BOOL serviceOnline;

+ (instancetype)sharedService;

- (void)startService;

- (void)stopService;

- (void)getCoordinateWithCity:(NSString *)cityName
                      address:(NSString *)address
                      succeed:(void(^)(BMKGeoCodeResult *result))succeed
                      failure:(void(^)(NSError *error))failure;

- (void)getAddressDescriptionWithCoordinate:(CLLocationCoordinate2D)coordinate
                                    succeed:(void(^)(BMKReverseGeoCodeResult *result))succeed
                                    failure:(void(^)(NSError *error))failure;

@end
