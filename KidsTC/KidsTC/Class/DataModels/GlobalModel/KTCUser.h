//
//  KTCUser.h
//  KidsTC
//
//  Created by 钱烨 on 8/5/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTCArea.h"
#import "KTCAgeScope.h"
#import "KTCUserRole.h"

@interface KTCUser : NSObject

@property (nonatomic, strong) KTCUserRole *userRole;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, strong, readonly) NSString *uid;

@property (nonatomic, strong, readonly) NSString *skey;

@property (nonatomic, readonly) BOOL hasLogin;

@property (nonatomic, strong) KTCAreaItem *currentArea;

+ (instancetype)currentUser;

- (void)checkLoginStatusFromServer;

- (void)updateUid:(NSString *)uid skey:(NSString *)skey;

- (void)logoutManually:(BOOL)manually withSuccess:(void(^)())success failure:(void(^)(NSError *error))failure;

@end
