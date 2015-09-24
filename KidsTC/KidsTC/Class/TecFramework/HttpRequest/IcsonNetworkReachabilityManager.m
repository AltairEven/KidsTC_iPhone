//
//  IcsonNetworkReachabilityManager.m
//  ICSON
//
//  Created by 钱烨 on 3/5/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "IcsonNetworkReachabilityManager.h"

static IcsonNetworkReachabilityManager *_sharedManager = nil;

@interface IcsonNetworkReachabilityManager ()

@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;

@end

@implementation IcsonNetworkReachabilityManager
@synthesize domain;
@synthesize isNetworkStatusOK = _isNetworkStatusOK;
@synthesize reachabilityManager;
@synthesize status = _status;

- (id)init
{
    self = [super init];
    if (self) {
        //默认有效,因为监控开始时网络状态未知
        _isNetworkStatusOK = YES;
    }
    
    return self;
}



+ (instancetype)sharedManager
{
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^ (void) {
        _sharedManager = [[IcsonNetworkReachabilityManager alloc] init];
    });
    
    return _sharedManager;
}



- (void)startNetworkMonitoringWithStatusChangeBlock:(void (^)(IcsonNetworkStatus))block
{
    //初始化网络状态监控
    if (self.domain && ![self.domain isEqualToString:@""]) {
        self.reachabilityManager = [AFNetworkReachabilityManager managerForDomain:self.domain];
    } else {
        self.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    }
    [self.reachabilityManager startMonitoring];
    
    __weak IcsonNetworkReachabilityManager *weakSelf = self;
    [weakSelf.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        _status = (IcsonNetworkStatus)status;
        if (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN) {
            _isNetworkStatusOK = YES;
        } else {
            _isNetworkStatusOK = NO;
        }
        
        block((IcsonNetworkStatus)status);
    }];
    
}


- (void)stopNetworkStatusMonitoring
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    
    _isNetworkStatusOK = NO;
}

@end
