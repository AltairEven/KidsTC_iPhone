//
//  WeiboManager.m
//  KidsTC
//
//  Created by Altair on 11/16/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "WeiboManager.h"
#import "WeiboSDK.h"
#import "WeiboUser.h"

NSString *const kWeiboUrlScheme = @"wb2837514135";
NSString *const kWeiboAppKey = @"2837514135";
NSString *const kWeiboRedirectURL = @"https://api.weibo.com/oauth2/default.html";

typedef void (^WeiboLoginSuccessBlock)(NSString *);
typedef void (^WeiboLoginFailureBlock)(NSError *);

typedef void (^WeiboShareSuccessBlock)();
typedef void (^WeiboShareFailureBlock)(NSError *);

static WeiboManager *_sharedInstance = nil;

@interface WeiboManager () <WeiboSDKDelegate>

@property (nonatomic, strong) WeiboLoginSuccessBlock loginSuccessBlock;

@property (nonatomic, strong) WeiboLoginFailureBlock loginFailureBlock;

@property (nonatomic, strong) WeiboShareSuccessBlock shareSuccessBlock;

@property (nonatomic, strong) WeiboShareFailureBlock shareFailureBlock;

@property (nonatomic, strong) NSString *token;

+ (WBAuthorizeRequest *)weiboAuthRequest;

+ (NSString *)errorMessageWithStatusCode:(WeiboSDKResponseStatusCode)code;

- (void)handleAuthResp:(WBAuthorizeResponse *)resp;

- (void)handleShareResp:(WBSendMessageToWeiboResponse *)resp;

@end

@implementation WeiboManager

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
        _sharedInstance = [[WeiboManager alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        [self handleAuthResp:(WBAuthorizeResponse *)response];
        return;
    }
    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        [self handleShareResp:(WBSendMessageToWeiboResponse *)response];
        return;
    }
}

#pragma mark Private methods

+ (WBAuthorizeRequest *)weiboAuthRequest {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kWeiboRedirectURL;
    request.scope = @"all";
    request.shouldShowWebViewForAuthIfCannotSSO = YES;
    
    return request;
}


+ (NSString *)errorMessageWithStatusCode:(WeiboSDKResponseStatusCode)code {
    NSString *errorMessage = @"新浪微博发生未知错误，操作失败";
    switch (code) {
        case WeiboSDKResponseStatusCodeSuccess:
        {
            errorMessage = @"";
        }
            break;
        case WeiboSDKResponseStatusCodeUserCancel:
        {
            errorMessage = @"用户取消操作";
        }
            break;
        case WeiboSDKResponseStatusCodeSentFail:
        {
            errorMessage = @"发送失败";
        }
            break;
        case WeiboSDKResponseStatusCodeAuthDeny:
        {
            errorMessage = @"授权失败";
        }
            break;
        case WeiboSDKResponseStatusCodeUserCancelInstall:
        {
            errorMessage = @"用户取消安装微博客户端";
        }
            break;
        case WeiboSDKResponseStatusCodePayFail:
        {
            errorMessage = @"支付失败";
        }
            break;
        case WeiboSDKResponseStatusCodeShareInSDKFailed:
        {
            errorMessage = @"分享失败";
        }
            break;
        case WeiboSDKResponseStatusCodeUnsupport:
        {
            errorMessage = @"不支持的请求";
        }
            break;
        case WeiboSDKResponseStatusCodeUnknown:
        {
            errorMessage = @"新浪微博发生未知错误";
        }
            break;
        default:
            break;
    }
    return errorMessage;
}

- (void)handleAuthResp:(WBAuthorizeResponse *)resp {
    if (resp.statusCode == WeiboSDKResponseStatusCodeSuccess && [resp.accessToken length] > 0) {
        self.token = resp.accessToken;
        if (self.loginSuccessBlock) {
            self.loginSuccessBlock(resp.accessToken);
        }
    } else {
        NSError *error = [NSError errorWithDomain:@"Weibo Auth" code:resp.statusCode userInfo:[NSDictionary dictionaryWithObject:[WeiboManager errorMessageWithStatusCode:resp.statusCode] forKey:kErrMsgKey]];
        if (self.loginFailureBlock) {
            self.loginFailureBlock(error);
        }
    }
}

- (void)handleShareResp:(WBSendMessageToWeiboResponse *)resp {
    if (resp.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        if (self.shareSuccessBlock) {
            self.shareSuccessBlock();
        }
    } else {
        NSError *error = [NSError errorWithDomain:@"Weibo Share" code:resp.statusCode userInfo:[NSDictionary dictionaryWithObject:[WeiboManager errorMessageWithStatusCode:resp.statusCode] forKey:kErrMsgKey]];
        if (self.shareSuccessBlock) {
            self.shareSuccessBlock(error);
        }
    }
}

#pragma mark Public methods

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)sendLoginRequestWithSucceed:(void (^)(NSString *))succeed failure:(void (^)(NSError *))failure {
    if (!self.isOnline) {
        return NO;
    }
    self.loginSuccessBlock = succeed;
    self.loginFailureBlock = failure;
    WBAuthorizeRequest *request = [WeiboManager weiboAuthRequest];
    return [WeiboSDK sendRequest:request];
}

- (BOOL)sendShareRequestWithContentTag:(NSString *)tag
                                 imgae:(UIImage *)image
                         linkUrlString:(NSString *)urlString
                               succeed:(void (^)(NSString *))succeed
                               failure:(void (^)(NSError *))failure {
    //WBSendMessageToWeiboRequest 说明
    //当用户安装了可以支持微博客户端內分享的微博客户端时,会自动唤起微博并分享
    //当用户没有安装微博客户端或微博客户端过低无法支持通过客户端內分享的时候会自动唤起SDK內微博发布器
    //故不用判断是否可以分享
    
    self.shareSuccessBlock = succeed;
    self.shareFailureBlock = failure;
    
    WBMessageObject *messageObj = [WBMessageObject message];
    
    if (tag && [tag isKindOfClass:[NSString class]]) {
        [messageObj setText:tag];
    }
    
    if (image && [image isKindOfClass:[UIImage class]]) {
        WBImageObject *imageObj = [WBImageObject object];
        [imageObj setImageData:UIImageJPEGRepresentation(image, 0)];
        [messageObj setImageObject:imageObj];
    }
    if (urlString && [urlString isKindOfClass:[NSString class]]) {
        WBWebpageObject *webPageObj = [WBWebpageObject object];
        [webPageObj setWebpageUrl:urlString];
        [messageObj setMediaObject:webPageObj];
    }
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:messageObj authInfo:[WeiboManager weiboAuthRequest] access_token:self.token];
    
    return [WeiboSDK sendRequest:request];
}

@end
