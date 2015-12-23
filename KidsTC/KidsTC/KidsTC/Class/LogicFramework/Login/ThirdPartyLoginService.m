//
//  ThirdPartyLoginService.m
//  KidsTC
//
//  Created by Altair on 11/16/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ThirdPartyLoginService.h"
#import "WeChatManager.h"
#import "TencentManager.h"
#import "WeiboManager.h"

typedef void (^ ThirdPartyLoginSuccessBlock) (NSDictionary *);

typedef void (^ ThirdPartyLoginFailureBlock) (NSError *);

static ThirdPartyLoginService *_sharedInstance = nil;

@interface ThirdPartyLoginService ()

@property (nonatomic, strong) HttpRequestClient *authorizationExchangeRequest;

@property (nonatomic, strong) ThirdPartyLoginSuccessBlock successBlock;

@property (nonatomic, strong) ThirdPartyLoginFailureBlock failureBlock;

- (void)handleLoginSucceedWithOpenId:(NSString *)openId accessToken:(NSString *)token loginType:(ThirdPartyLoginType)type;

- (void)handleLoginFailure:(NSError *)error;

@end

@implementation ThirdPartyLoginService

+ (instancetype)sharedService {
    static dispatch_once_t token = 0;
    
    dispatch_once(&token, ^{
        _sharedInstance = [[ThirdPartyLoginService alloc] init];
    });
    
    return _sharedInstance;
}

+ (BOOL)isOnline:(ThirdPartyLoginType)type {
    BOOL isOn = NO;
    switch (type) {
        case ThirdPartyLoginTypeWechat:
        {
            isOn = [[WeChatManager sharedManager] isOnline];
        }
            break;
        case ThirdPartyLoginTypeQQ:
        {
            isOn = [[TencentManager sharedManager] isOnline];
        }
            break;
        case ThirdPartyLoginTypeWeibo:
        {
            isOn = [[WeiboManager sharedManager] isOnline];
        }
            break;
        default:
            break;
    }
    return isOn;
}

- (BOOL)startThirdPartyLoginWithType:(ThirdPartyLoginType)type succeed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    self.successBlock = succeed;
    self.failureBlock = failure;
    
    BOOL ret = NO;
    switch (type) {
        case ThirdPartyLoginTypeWechat:
        {
            [[WeChatManager sharedManager] sendLoginRequestWithSucceed:^(NSString *openId, NSString *accessToken) {
                [self handleLoginSucceedWithOpenId:openId accessToken:accessToken loginType:type];
            } failure:^(NSError *error) {
                [self handleLoginFailure:error];
            }];
        }
            break;
        case ThirdPartyLoginTypeQQ:
        {
            [[TencentManager sharedManager] sendLoginRequestWithSucceed:^(NSString *openId, NSString *accessToken) {
                [self handleLoginSucceedWithOpenId:openId accessToken:accessToken loginType:type];
            } failure:^(NSError *error) {
                [self handleLoginFailure:error];
            }];
        }
            break;
        case ThirdPartyLoginTypeWeibo:
        {
            ret = [[WeiboManager sharedManager] sendLoginRequestWithSucceed:^(NSString *openId, NSString *accessToken) {
                [self handleLoginSucceedWithOpenId:openId accessToken:accessToken loginType:type];
            } failure:^(NSError *error) {
                [self handleLoginFailure:error];
            }];
        }
            break;
        default:
        {
            if (failure) {
                failure(nil);
            }
        }
            break;
    }
    return ret;
}

#pragma mark Private methods

- (void)handleLoginSucceedWithOpenId:(NSString *)openId accessToken:(NSString *)token loginType:(ThirdPartyLoginType)type {
    _currentLoginType = type;
    _currentOpenId = openId;
    _currentAccessToken = token;
    if (!self.authorizationExchangeRequest) {
        self.authorizationExchangeRequest = [HttpRequestClient clientWithUrlAliasName:@"THIRD_LOGIN"];
    }
    if ([openId length] > 0 && [token length] > 0) {
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:openId, @"code", [NSNumber numberWithInteger:type], @"type", nil];
        
        __weak ThirdPartyLoginService *weakSelf = self;
        [weakSelf.authorizationExchangeRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
            if (weakSelf.successBlock) {
                weakSelf.successBlock(responseData);
            }
        } failure:^(HttpRequestClient *client, NSError *error) {
            if (weakSelf.failureBlock) {
                weakSelf.failureBlock(error);
            }
        }];
        
    } else if (self.failureBlock) {
        self.failureBlock(nil);
    }
}

- (void)handleLoginFailure:(NSError *)error {
    _currentOpenId = nil;
    _currentAccessToken = nil;
    if (self.failureBlock) {
        self.failureBlock(error);
    }
}

@end
