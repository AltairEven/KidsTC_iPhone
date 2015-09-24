//
//  KTCUser.h
//  KidsTC
//
//  Created by 钱烨 on 8/5/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTCUser : NSObject

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *skey;

@property (nonatomic, readonly) BOOL hasLogin;

+ (instancetype)currentUser;

- (void)checkLoginStatusFromServer;

- (void)updateUid:(NSString *)uid skey:(NSString *)skey;

- (void)logoutManually:(BOOL)manually withSuccess:(void(^)())success failure:(void(^)(NSError *error))failure;

@end
