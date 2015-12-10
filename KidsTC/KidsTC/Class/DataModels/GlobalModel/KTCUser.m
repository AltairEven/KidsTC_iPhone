//
//  KTCUser.m
//  KidsTC
//
//  Created by 钱烨 on 8/5/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCUser.h"
#import "SFHFKeychainUtils.h"
#import "HttpIcsonCookieManager.h"
#import "KTCPushNotificationService.h"

#define USERDEFAULT_UID_KEY (@"UserDefaultUidKey")
#define KEYCHAIN_SERVICE_UIDSKEY (@"com.KidsTC.iPhoneAPP.uid")

static KTCUser *_sharedInstance = nil;

@interface KTCUser ()

@property (nonatomic, strong) HttpRequestClient *logoutRequest;

@property (nonatomic, strong) HttpRequestClient *checkLoginRequest;

- (void)localSave;

- (void)getLocalSave;

- (void)clearLoginInfo;

@end

@implementation KTCUser
@synthesize uid = _uid, skey = _skey;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userRole = [KTCUserRole instanceWithRole:UserRolePrepregnancy sex:KTCSexUnknown];
    }
    return self;
}

+ (instancetype)currentUser {
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        _sharedInstance = [[KTCUser alloc] init];
    });
    return _sharedInstance;
}

- (void)setUserRole:(KTCUserRole *)userRole {
    if (_userRole.role != userRole.role) {
        _userRole = userRole;
        [[NSNotificationCenter defaultCenter] postNotificationName:UserRoleHasChangedNotification object:userRole];
    }
}

- (NSString *)userName {
    if (!_userName) {
        _userName = @"";
    }
    return _userName;
}


- (NSString *)uid {
    if (!_uid) {
        _uid = @"";
    }
    return _uid;
}


- (NSString *)skey {
    if (!_skey) {
        _skey = @"";
    }
    return _skey;
}

#pragma mark Public methods

- (void)updateUid:(NSString *)uid skey:(NSString *)skey {
    if ([uid length] > 0 && [skey length] > 0) {
        _hasLogin = YES;
        _uid = uid;
        _skey = skey;
        [self localSave];
        [[KTCPushNotificationService sharedService] bindAccount:YES];
        [[KTCPushNotificationService sharedService] checkUnreadMessage:nil failure:nil];
    }
}

- (void)checkLoginStatusFromServer {
    [self getLocalSave];
    if ([self.uid length] > 0 && [self.skey length] > 0) {
        //本地存储了uid和skey，可以开始检查是否登录
        if (!self.checkLoginRequest) {
            self.checkLoginRequest = [HttpRequestClient clientWithUrlAliasName:@"LOGIN_IS_LOGIN"];
        }
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.uid, @"uid", self.skey, @"skey", nil];
        __weak KTCUser *weakSelf = self;
        [weakSelf.checkLoginRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
            _hasLogin = YES;
            [[HttpIcsonCookieManager sharedManager] setupCookies]; //设置cookie
            [[KTCPushNotificationService sharedService] bindAccount:YES];
            [[KTCPushNotificationService sharedService] checkUnreadMessage:nil failure:nil];
        } failure:^(HttpRequestClient *client, NSError *error) {
            _hasLogin = NO;
            [weakSelf clearLoginInfo];
        }];
    } else {
    }
}

- (void)logoutManually:(BOOL)manually withSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    if (manually) {
        if (!self.logoutRequest) {
            self.logoutRequest = [HttpRequestClient clientWithUrlAliasName:@"LOGIN_LOGINOUT"];
        }
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.uid, @"uid", self.skey, @"skey", nil];
        __weak KTCUser *weakSelf = self;
        [weakSelf.logoutRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
            if (success) {
                success();
            }
        } failure:^(HttpRequestClient *client, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    } else {
        if (success) {
            success();
        }
        if (failure) {
            failure(nil);
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutNotification object:nil];
    [self clearLoginInfo];
}

#pragma mark Private methods

- (void)localSave {
    [[HttpIcsonCookieManager sharedManager] setupCookies]; //设置cookie
    [[NSUserDefaults standardUserDefaults] setObject:self.uid forKey:USERDEFAULT_UID_KEY];
    [SFHFKeychainUtils storeUsername:self.uid andPassword:self.skey forServiceName:KEYCHAIN_SERVICE_UIDSKEY updateExisting:YES error:nil];
}

- (void)getLocalSave {
    _uid = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_UID_KEY];
    if ([self.uid length] > 0) {
        _skey = [SFHFKeychainUtils getPasswordForUsername:self.uid andServiceName:KEYCHAIN_SERVICE_UIDSKEY error:nil];
    }
    [[HttpIcsonCookieManager sharedManager] setupCookies]; //设置cookie
}

- (void)clearLoginInfo {
    [SFHFKeychainUtils deleteItemForUsername:self.uid andServiceName:KEYCHAIN_SERVICE_UIDSKEY error:nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULT_UID_KEY];
    _uid = nil;
    _skey = nil;
    _hasLogin = NO;
    [[HttpIcsonCookieManager sharedManager] setupCookies]; //设置cookie
    [[KTCPushNotificationService sharedService] bindAccount:NO];
}

@end
