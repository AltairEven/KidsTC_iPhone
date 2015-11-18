//
//  WeChatManager.m
//  KidsTC
//
//  Created by Altair on 11/16/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "WeChatManager.h"
#import "WXApi.h"
#import "WXApiObject.h"

NSString *const kWeChatUrlScheme = @"wx75fa1a06d38fde4e";
NSString *const kWeChatAppKey = @"wx75fa1a06d38fde4e";

NSString *const kWeChatLoginIdentifier = @"kWeChatLoginIdentifier";

typedef void (^WeChatLoginSuccessBlock)(NSString *);
typedef void (^WeChatLoginFailureBlock)(NSError *);

static WeChatManager *_sharedInstance = nil;

@interface WeChatManager () <WXApiDelegate>

@property (nonatomic, strong) WeChatLoginSuccessBlock loginSuccessBlock;

@property (nonatomic, strong) WeChatLoginFailureBlock loginFailureBlock;

- (void)handleAuthResp:(SendAuthResp *)resp;

@end

@implementation WeChatManager

+ (instancetype)sharedManager {
    static dispatch_once_t token = 0;
    
    dispatch_once(&token, ^{
        _sharedInstance = [[WeChatManager alloc] init];
    });
    [_sharedInstance getOnline];
    
    return _sharedInstance;
}

#pragma mark WXApiDelegate

-(void)onReq:(BaseReq*)req {
    
}

-(void)onResp:(BaseResp*)resp {
    if (resp.errCode == 0) {
        //成功返回
        switch (resp.type) {
            case 0:
            {
                //授权
                [self handleAuthResp:(SendAuthResp *)resp];
            }
                break;
            default:
                break;
        }
    } else {
        
    }
}

#pragma mark Private methods

- (void)handleAuthResp:(SendAuthResp *)resp {
    if ([resp.state isEqualToString:kWeChatLoginIdentifier] && [resp.code length] > 0) {
        if (self.loginSuccessBlock) {
            self.loginSuccessBlock(resp.code);
        }
    } else {
        NSError *error = [NSError errorWithDomain:@"WeChat Auth" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"微信授权失败" forKey:kErrMsgKey]];
        if (self.loginFailureBlock) {
            self.loginFailureBlock(error);
        }
    }
}


#pragma mark Public methods

- (BOOL)getOnline {
    _isOnline = [WXApi registerApp:kWeChatAppKey];
    if (_isOnline) {
        _isOnline = [WXApi isWXAppInstalled];
    }
    if (_isOnline) {
        _isOnline = [WXApi isWXAppSupportApi];
    }
    return _isOnline;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)sendLoginRequestWithSucceed:(void (^)(NSString *))succeed failure:(void (^)(NSError *))failure {
    if (!_isOnline) {
        return NO;
    }
    self.loginSuccessBlock = succeed;
    self.loginFailureBlock = failure;
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo"; //获取用户信息的授权域
    req.state = kWeChatLoginIdentifier;
    //第三方向微信终端发送一个SendAuthReq消息结构
    return [WXApi sendReq:req];
}

@end
