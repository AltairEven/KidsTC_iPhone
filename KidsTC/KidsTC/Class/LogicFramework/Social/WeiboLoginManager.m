//
//  WeiboLoginManager.m
//  KidsTC
//
//  Created by 钱烨 on 11/5/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "WeiboLoginManager.h"

NSString *const kWeiboUrlScheme = @"wb2837514135";
NSString *const kWeiboAppKey = @"2837514135";
NSString *const kWeiboRedirectURL = @"https://api.weibo.com/oauth2/default.html";

static WeiboLoginManager *_sharedInstance = nil;

@interface WeiboLoginManager ()

@end

@implementation WeiboLoginManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [WeiboSDK enableDebugMode:YES];
        _isOnline = [WeiboSDK registerApp:kWeiboAppKey];
    }
    return self;
}

+ (instancetype)sharedManager {
    static dispatch_once_t token = 0;
    
    dispatch_once(&token, ^{
        _sharedInstance = [[WeiboLoginManager alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
}

#pragma mark Public methods

- (BOOL)sendLoginRequest {
    if (!self.isOnline) {
        return NO;
    }
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kWeiboRedirectURL;
    request.scope = @"all";
    request.shouldShowWebViewForAuthIfCannotSSO = YES;
    return [WeiboSDK sendRequest:request];
}

@end
