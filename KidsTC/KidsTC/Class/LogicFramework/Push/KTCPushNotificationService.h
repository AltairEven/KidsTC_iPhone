//
//  KTCPushNotificationService.h
//  KidsTC
//
//  Created by Altair on 11/30/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTCPushNotificationService : NSObject

@property (nonatomic, readonly) BOOL isOnLine;

+ (instancetype)sharedService;

- (void)launchServiceWithOption:(NSDictionary *)launchOptions;

- (void)handleApplication:(UIApplication *)application withReceivedNotification:(NSDictionary *)userInfo;

- (NSString *)registerDevice:(NSData *)deviceToken;

- (void)handleRegisterDeviceFailure:(NSError *)error;

@end
