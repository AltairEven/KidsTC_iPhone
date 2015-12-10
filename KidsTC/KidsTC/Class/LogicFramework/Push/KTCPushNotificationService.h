//
//  KTCPushNotificationService.h
//  KidsTC
//
//  Created by Altair on 11/30/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushNotificationModel.h"

@protocol KTCPushNotificationServiceDelegate <NSObject>

- (void)didRecievedRemoteNotificationWithModel:(PushNotificationModel *)model;

@end

@interface KTCPushNotificationService : NSObject

@property (nonatomic, assign) id<KTCPushNotificationServiceDelegate> delegate;

@property (nonatomic, strong, readonly) NSString *token;

@property (nonatomic, readonly) BOOL isOnLine;

@property (nonatomic, readonly) NSUInteger unreadCount;

+ (instancetype)sharedService;

- (NSString *)registerDevice:(NSData *)deviceToken;

- (void)handleRegisterDeviceFailure:(NSError *)error;

- (void)bindAccount:(BOOL)bind;

- (void)launchServiceWithOption:(NSDictionary *)launchOptions;

- (void)handleApplication:(UIApplication *)application withReceivedNotification:(NSDictionary *)userInfo;

- (void)checkUnreadMessage:(void(^)(NSUInteger unreadCount))succeed failure:(void(^)(NSError *error))failure;

- (void)readMessageWithIdentifier:(NSString *)identifier;

@end
