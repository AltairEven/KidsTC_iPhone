//
//  KTCPushNotificationService.h
//  KidsTC
//
//  Created by Altair on 11/30/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTCPushNotificationService : NSObject

@property (nonatomic, strong, readonly) NSString *token;

@property (nonatomic, readonly) BOOL isOnLine;

+ (instancetype)sharedService;

- (NSString *)registerDevice:(NSData *)deviceToken;

- (void)handleRegisterDeviceFailure:(NSError *)error;

- (void)bindAccount:(BOOL)bind;

- (void)launchServiceWithOption:(NSDictionary *)launchOptions;

- (void)handleApplication:(UIApplication *)application withReceivedNotification:(NSDictionary *)userInfo;

@end
