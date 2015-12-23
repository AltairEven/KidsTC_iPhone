//
//  IcsonNetworkReachabilityManager.h
//  ICSON
//
//  Created by 钱烨 on 3/5/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IcsonNetworkStatus) {
    IcsonNetworkStatusUnknown          = -1,
    IcsonNetworkStatusNotReachable     = 0,
    IcsonNetworkStatusReachableViaWWAN = 1,
    IcsonNetworkStatusReachableViaWiFi = 2,
};

@interface IcsonNetworkReachabilityManager : NSObject

@property (strong, nonatomic) NSString *domain;

@property (nonatomic, readonly) BOOL isNetworkStatusOK;

@property (nonatomic, readonly) IcsonNetworkStatus status;

+ (instancetype)sharedManager;

//开始网络状态监控
- (void)startNetworkMonitoringWithStatusChangeBlock:(void(^)(IcsonNetworkStatus status))block;
//停止网络状态监控
- (void)stopNetworkStatusMonitoring;

@end
