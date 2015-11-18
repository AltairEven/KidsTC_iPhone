//
//  TencentManager.m
//  KidsTC
//
//  Created by Altair on 11/16/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "TencentManager.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>

NSString *const kTencentUrlScheme = @"tencent101265844";
NSString *const kTencentAppKey = @"101265844";

typedef void (^TencentLoginSuccessBlock)(NSString *);
typedef void (^TencentLoginFailureBlock)(NSError *);

static TencentManager *_sharedInstance = nil;

@interface TencentManager () <TencentSessionDelegate>

@property (nonatomic, strong) TencentOAuth *tcOAuth;

@property (nonatomic, strong) TencentLoginSuccessBlock loginSuccessBlock;

@property (nonatomic, strong) TencentLoginFailureBlock loginFailureBlock;

- (BOOL)getOnline;

@end

@implementation TencentManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tcOAuth = [[TencentOAuth alloc] initWithAppId:kTencentAppKey andDelegate:self];
    }
    return self;
}

+ (instancetype)sharedManager {
    static dispatch_once_t token = 0;
    
    dispatch_once(&token, ^{
        _sharedInstance = [[TencentManager alloc] init];
    });
    [_sharedInstance getOnline];
    
    return _sharedInstance;
}

#pragma mark TencentApiInterfaceDelegate

- (BOOL)onTencentReq:(TencentApiReq *)req {
    return YES;
}

- (BOOL)onTencentResp:(TencentApiResp *)resp {
    return YES;
}

#pragma mark TencentLoginDelegate

- (void)tencentDidLogin {
    if (self.loginSuccessBlock) {
        self.loginSuccessBlock(self.tcOAuth.accessToken);
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    NSString *errMsg = @"授权失败";
    if (cancelled) {
        errMsg = @"用户取消授权";
    }
    if (self.loginFailureBlock) {
        NSError *error = [NSError errorWithDomain:@"QQ Login" code:-1 userInfo:[NSDictionary dictionaryWithObject:errMsg forKey:kErrMsgKey]];
        self.loginFailureBlock(error);
    }
}

- (void)tencentDidNotNetWork {
    if (self.loginFailureBlock) {
        NSString *errMsg = @"授权超时";
        NSError *error = [NSError errorWithDomain:@"QQ Login" code:-1 userInfo:[NSDictionary dictionaryWithObject:errMsg forKey:kErrMsgKey]];
        self.loginFailureBlock(error);
    }
}

#pragma mark Public methods

- (BOOL)handleOpenURL:(NSURL *)url {
    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL)sendLoginRequestWithSucceed:(void (^)(NSString *))succeed failure:(void (^)(NSError *))failure {
    if (!self.isOnline) {
        return NO;
    }
    self.loginSuccessBlock = succeed;
    self.loginFailureBlock = failure;
    NSArray* permissions = [NSArray arrayWithObjects:
                             kOPEN_PERMISSION_GET_USER_INFO,
                             kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                             kOPEN_PERMISSION_ADD_SHARE,
                             nil];
    return [self.tcOAuth authorize:permissions];
}

#pragma mari Private methods

- (BOOL)getOnline {
    _isOnline = [TencentOAuth iphoneQQInstalled];
    if (_isOnline) {
        _isOnline = [TencentOAuth iphoneQQSupportSSOLogin];
    }
    return _isOnline;
}

@end
