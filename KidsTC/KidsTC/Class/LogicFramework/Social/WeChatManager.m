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

typedef void (^WeChatShareSuccessBlock)();
typedef void (^WeChatShareFailureBlock)(NSError *);

static WeChatManager *_sharedInstance = nil;

@interface WeChatManager () <WXApiDelegate>

@property (nonatomic, strong) WeChatLoginSuccessBlock loginSuccessBlock;

@property (nonatomic, strong) WeChatLoginFailureBlock loginFailureBlock;

@property (nonatomic, strong) WeChatShareSuccessBlock shareSuccessBlock;

@property (nonatomic, strong) WeChatShareFailureBlock shareFailureBlock;

+ (WXMediaMessage *)messageFromShareObject:(WeChatShareObject *)object;

- (void)handleAuthResp:(SendAuthResp *)resp;

- (void)handleShareResp:(SendMessageToWXResp *)resp;

@end

@implementation WeChatManager

+ (instancetype)sharedManager {
    static dispatch_once_t token = 0;
    
    dispatch_once(&token, ^{
        _sharedInstance = [[WeChatManager alloc] init];
        [_sharedInstance getOnline];
    });
    
    return _sharedInstance;
}

#pragma mark WXApiDelegate

-(void)onReq:(BaseReq*)req {
    
}

-(void)onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        //授权
        [self handleAuthResp:(SendAuthResp *)resp];
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        //分享
        [self handleShareResp:(SendMessageToWXResp *)resp];
    }
}

#pragma mark Private methods

+ (WXMediaMessage *)messageFromShareObject:(WeChatShareObject *)object {
    if (!object) {
        return nil;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = object.title;
    message.description = object.shareDescription;
    if (object.thumbImage) {
        NSUInteger byteCount = [GToolUtil byteCountOfImage:object.thumbImage];
        if (byteCount >=  32 * 1024 * 8) {
            return nil;
        }
        [message setThumbImage:object.thumbImage];
    }
    message.mediaTagName = object.mediaTagName;
    message.messageExt = object.messageExt;
    message.messageAction = object.messageAction;
    
    switch (object.type) {
        case WeChatShareObjectTypeDefault:
        {
        }
            break;
        case WeChatShareObjectTypeImage:
        {
            WeChatImageShareObject *shareObj = (WeChatImageShareObject *)object;
            
            WXImageObject *imageObj = [WXImageObject object];
            if (shareObj.image) {
                imageObj.imageData = UIImageJPEGRepresentation(shareObj.image, 0);
            }
            imageObj.imageUrl = shareObj.imageUrlString;
            
            message.mediaObject = imageObj;
        }
            break;
        case WeChatShareObjectTypeWebPage:
        {
            WeChatWebPageShareObject *shareObj = (WeChatWebPageShareObject *)object;
            
            WXWebpageObject *webPageObj = [WXWebpageObject object];
            webPageObj.webpageUrl = shareObj.webPageUrlString;
            
            message.mediaObject = webPageObj;
        }
            break;
        default:
            break;
    }
    
    return message;
}

- (void)handleAuthResp:(SendAuthResp *)resp {
    if (resp.errCode == 0) {
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
    } else {
        NSError *error = [NSError errorWithDomain:@"WeChat Auth" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"微信授权失败" forKey:kErrMsgKey]];
        if (self.loginFailureBlock) {
            self.loginFailureBlock(error);
        }
    }
}

- (void)handleShareResp:(SendMessageToWXResp *)resp {
    if (resp.errCode == 0) {
        if (self.shareSuccessBlock) {
            self.shareSuccessBlock();
        }
    } else {
        NSError *error = [NSError errorWithDomain:@"WeChat Share" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"分享失败" forKey:kErrMsgKey]];
        if (self.shareFailureBlock) {
            self.shareFailureBlock(error);
        }
    }
}


#pragma mark Public methods

+ (BOOL)canShare {
    return [[WeChatManager sharedManager] isOnline];
}

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

- (BOOL)sendShareRequestToScene:(WechatShareScene)scene
                     WithObject:(WeChatShareObject *)object
                        succeed:(void (^)())succeed
                        failure:(void (^)(NSError *))failure {
    self.shareSuccessBlock = succeed;
    self.shareFailureBlock = failure;
    //判断是否可分享
    if (![WXApi isWXAppInstalled]) {
        NSError *error = [NSError errorWithDomain:@"WeChat Share" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"请先安装微信客户端" forKey:kErrMsgKey]];
        if (failure) {
            failure(error);
        }
        return NO;
    }
    if (![WXApi isWXAppSupportApi]) {
        NSError *error = [NSError errorWithDomain:@"WeChat Share" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"当前微信版本不支持" forKey:kErrMsgKey]];
        if (failure) {
            failure(error);
        }
        return NO;
    }
    
    WXMediaMessage *message = [WeChatManager messageFromShareObject:object];
    if (!message) {
        NSError *error = [NSError errorWithDomain:@"WeChat Share" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"无效的分享内容" forKey:kErrMsgKey]];
        if (failure) {
            failure(error);
        }
        return NO;
    }
    
    SendMessageToWXReq *request = [[SendMessageToWXReq alloc] init];
    request.message = message;
    request.scene = scene;
    return [WXApi sendReq:request];
}

@end


@implementation WeChatShareObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = WeChatShareObjectTypeDefault;
    }
    return self;
}

+ (instancetype)shareObjectWithTitle:(NSString *)title description:(NSString *)des thumbImage:(UIImage *)thumb {
    if (!title && !des && !thumb) {
        return nil;
    }
    
    WeChatShareObject *obj = [[WeChatShareObject alloc] init];
    obj.title = title;
    obj.shareDescription = des;
    obj.thumbImage = thumb;
    return obj;
}

@end


@implementation WeChatImageShareObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = WeChatShareObjectTypeImage;
    }
    return self;
}

+ (instancetype)imageShareObjectWithTitle:(NSString *)title
                              description:(NSString *)des
                               thumbImage:(UIImage *)thumb
                               shareImage:(UIImage *)image
                      shareImageUrlString:(NSString *)urlString {
    if (!image && !urlString) {
        return nil;
    }
    WeChatImageShareObject *obj = [[WeChatImageShareObject alloc] init];
    obj.title = title;
    obj.shareDescription = des;
    obj.thumbImage = thumb;
    obj.image = image;
    obj.imageUrlString = urlString;
    return obj;
}

@end


@implementation WeChatWebPageShareObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = WeChatShareObjectTypeWebPage;
    }
    return self;
}

+ (instancetype)webPageShareObjectWithTitle:(NSString *)title
                                description:(NSString *)des
                                 thumbImage:(UIImage *)thumb
                           webPageUrlString:(NSString *)urlString {
    if (!urlString || ![urlString isKindOfClass:[NSString class]]) {
        return nil;
    }
    WeChatWebPageShareObject *obj = [[WeChatWebPageShareObject alloc] init];
    obj.title = title;
    obj.shareDescription = des;
    obj.thumbImage = thumb;
    obj.webPageUrlString = urlString;
    return obj;
}

@end