//
//  KTCSystemTime.m
//  KidsTC
//
//  Created by 钱烨 on 8/5/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCSystemTime.h"

static KTCSystemTime *_sharedInstance = nil;

@interface KTCSystemTime ()

@property (nonatomic, strong) HttpRequestClient *updateTimeRequest;

@end

@implementation KTCSystemTime

+ (instancetype)sharedTime {
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        _sharedInstance = [[KTCSystemTime alloc] init];
    });
    return _sharedInstance;
}

- (void)updateSystemTime {
    
}

@end
