//
//  LocalNotificationManager.m
//  KidsTC
//
//  Created by Altair on 2/19/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "LocalNotificationManager.h"

static LocalNotificationManager *_sharedInstance = nil;

@interface LocalNotificationManager ()

@end

@implementation LocalNotificationManager

- (instancetype)init {
    self = [super init];
    if (self) {
//        [[UILocalNotification alloc] init];
    }
    return self;
}

+ (instancetype)sharedManager {
    static dispatch_once_t token = 0;
    
    dispatch_once(&token, ^{
        _sharedInstance = [[LocalNotificationManager alloc] init];
    });
    
    return _sharedInstance;
}

@end
