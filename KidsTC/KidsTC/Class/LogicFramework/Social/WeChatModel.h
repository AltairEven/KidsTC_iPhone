/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：WeChatModel.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：haoquanbai
 * 完成日期：13-1-4
 */

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "UIAlertView+Blocks.h"

static NSString * const kWeChatShareRespNotification = @"WeChatShareRespNotification";

typedef enum{
    WXLOGIN_ERROR_NOT_INSTALLED,  //微信未安装
    WXLOGIN_ERROR_NOT_SUPPORT_API,  //当前微信版本不支持OpenApi
    WXLOGIN_REJECTED_ACCESS,  //用户授权失败或用户拒绝授权
} WXLOGIN_RETURN_VALUES;

@protocol WeChatLoginDelegate <NSObject>

- (void)weixinLoginSuccess:(NSString *)code;
- (void)weixinLoginFailed:(WXLOGIN_RETURN_VALUES)value;
@end

@interface WeChatModel : NSObject
{
    PayReq *_payRequest;
}
@property (nonatomic, retain)PayReq *payRequest;
@property (assign, nonatomic) id<WeChatLoginDelegate> loginDelegate;
//@property (nonatomic) SEL sucCb;
//@property (nonatomic) SEL failCb;
- (void)startWeChatTrade;

//微信登录
- (void)weixinLogin:(id<WeChatLoginDelegate>)_target;

+ (BOOL)handleWeChatOpenURL:(NSURL *)url appDelegate:(id<WXApiDelegate>)delegate;
+ (void)onWeChatResponse:(BaseResp *)resp;
+ (void)onWeChatReq:(BaseReq *)req;

/*
 单例对象
 */
+ (id)sharedWeChatModel;
/**
 \brief 微信支付随即串
 */
+ (NSString *)genNonceNum;
+ (NSString *)appID;
+ (NSString *)appKey;

+ (BOOL)isValidWeChatApp;
@end
