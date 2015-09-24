/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：WeChatModel.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：haoquanbai
 * 完成日期：13-1-4
 */

#import "WeChatModel.h"
#import "ServiceDetailViewController.h"
#import "UIAlertView+Blocks.h"
#import "MTA.h"
#import "KTCTabBarController.h"
#import "GPayment.h"

@implementation WeChatModel
@synthesize payRequest = _payRequest,loginDelegate;

+ (id)sharedWeChatModel
{
    static WeChatModel *sharedWechatModel = nil;
    if (sharedWechatModel == nil)
    {
        sharedWechatModel = [[WeChatModel alloc] init];
    }
    
    return sharedWechatModel;
}

- (id)init
{
    if (self = [super init])
    {
        self.payRequest = nil;
    }
    
    return self;
}

- (BOOL)isValidRequest
{
    BOOL valid = NO;
    if (self.payRequest != nil && self.payRequest.partnerId != nil && self.payRequest.prepayId != nil && self.payRequest.sign != nil && self.payRequest.package != nil)
    {
        valid = YES;
    }
    
    return valid;
}
- (void)startWeChatTrade
{
    if ([self isValidRequest])
    {
        NSLog(@"partnerId: %@", self.payRequest.partnerId);
        NSLog(@"prepayId: %@", self.payRequest.prepayId);
        NSLog(@"nonceStr: %@", self.payRequest.nonceStr);
        NSLog(@"timStamp: %d", (unsigned int)self.payRequest.timeStamp);
        NSLog(@"package: %@", self.payRequest.package);
        NSLog(@"sign: %@", self.payRequest.sign);
        [WXApi sendReq:self.payRequest];
    }
}

- (void)weixinLogin:(id<WeChatLoginDelegate>)_target
{
    self.loginDelegate = _target;
    
    if (![WXApi isWXAppInstalled])
    {
        [loginDelegate weixinLoginFailed:WXLOGIN_ERROR_NOT_INSTALLED];
        return;
    }
    
    if (![WXApi isWXAppSupportApi])
    {
        [loginDelegate weixinLoginFailed:WXLOGIN_ERROR_NOT_SUPPORT_API];
        return;
    }
    
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"51Buy";
    
    [WXApi sendReq:req];
}

+ (void)handleWeixin:(NSDictionary*)param
{
    if([param objectForKey:@"ytag"]!= nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[param objectForKey:@"ytag"] forKey:kWeiXinOTag];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"3200" forKey:kWeiXinOTag];
    }
    
    NSTimeInterval curTime = [NSDate timeIntervalSinceReferenceDate];
    [[NSUserDefaults standardUserDefaults] setDouble:curTime forKey:kWeixinOTagTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)handleWeChatOpenURL:(NSURL *)url appDelegate:(id<WXApiDelegate>)delegate
{
    NSString *query = [url query];
    NSString *host = [url host];
    if ([host isEqualToString:@"pay"])
    {
        /*微信支付返回*/
    }
    else if ([host isEqualToString:@"oauth"])
    {
        /*微信登录返回*/
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        for (NSString *item in [query componentsSeparatedByString:@"&"])
        {
            NSArray *pair = [item componentsSeparatedByString:@"="];
            [paramDic setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
        }
        
        NSString *state = [paramDic objectForKey:@"state"];
        NSString *code = [paramDic objectForKey:@"code"];
        WeChatModel *model = [WeChatModel sharedWeChatModel];
        if ([state isEqualToString:@"51Buy"] && ![code isEqualToString:@"authdeny"])
        {
            [model.loginDelegate weixinLoginSuccess:code];
        }
        else
        {
            [model.loginDelegate weixinLoginFailed:WXLOGIN_REJECTED_ACCESS];
        }
    }
    else if([query length] > 0)
    {
        /*商详*/
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        for (NSString *item in [query componentsSeparatedByString:@"&"])
        {
            NSArray *pair = [item componentsSeparatedByString:@"="];
            [paramDic setObject:[NSString stringWithFormat:@"%@", [pair objectAtIndex:1]] forKey:[NSString stringWithFormat:@"%@", [pair objectAtIndex:0]]];
        }
        
        [WeChatModel handleWeixin:paramDic];
//        NSString *pid = [paramDic objectForKey:@"pid"];
//        NSString * channelId = [paramDic objectForKey:@"channelId"];
//        NSString * mPriceID = [paramDic objectForKey:@"price_id"];
        ServiceDetailViewController *productController = [[ServiceDetailViewController alloc] init];
        KTCTabBarController *rootVc = [KTCTabBarController shareTabBarController];
        UIViewController *presentedVc = nil;
        if ([rootVc respondsToSelector:@selector(modalViewController)])
        {
            presentedVc = [rootVc presentedViewController];
        }
        else if ([rootVc respondsToSelector:@selector(presentedViewController)])
        {
            presentedVc = [rootVc presentedViewController];
        }
        
        if ([presentedVc isKindOfClass:[UINavigationController class]] /*&& [[(UINavigationController *)presentedVc topViewController] isKindOfClass:[GLoginController class]]*/)
        {
            if ([presentedVc respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
            {
                [presentedVc dismissViewControllerAnimated:NO completion:nil];
            }
            else
            {
                [presentedVc dismissViewControllerAnimated:NO completion:nil];
            }
        }
        
        NSLog(@"%@", paramDic);
        UIViewController *curVc = nil;
        static const int kMaxVisibleTabOnTabBar = 5;
        if ([[KTCTabBarController shareTabBarController] selectedIndex] >= kMaxVisibleTabOnTabBar)
        {
            curVc = [[[KTCTabBarController shareTabBarController] moreNavigationController] topViewController];
        }
        else
        {
            curVc = [(UINavigationController*)[[KTCTabBarController shareTabBarController] selectedViewController] topViewController];
        }
        
        if ([curVc.navigationController respondsToSelector:@selector(pushViewController:animated:)])
        {
            [curVc.navigationController pushViewController:productController animated:NO];
        }
    }
    return [WXApi handleOpenURL:url delegate:delegate];
}

+ (void)onWeChatResponse:(BaseResp *)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kWeChatShareRespNotification object:nil userInfo:@{@"errCode":INT2STRING(resp.errCode), @"errStr":resp.errStr ? resp.errStr : @""}];
    }
    else if([resp isKindOfClass:[PayResp class]])
    {
        switch (resp.errCode)
        {
            case WXSuccess:
                //微信支付成功。
                [WeChatModel paySuccess:(PayResp*)resp];
                break;
            case WXErrCodeUserCancel:
                //取消支付。
                [WeChatModel payCancel:(PayResp*)resp];
                break;
            default:
                //默认支付失败
                [WeChatModel payCancel:(PayResp*)resp];
                break;
        }
    }
}

+ (void)paySuccess:(PayResp *)resp
{
    //    NSString *message = resp.errStr;
    //    if ([message length] == 0 || [message isKindOfClass:[NSNull class]] || [message isEqualToString:@"(null)"])
    //    {
    //        // no message
    //        message = @"支付成功";
    //    }
    //    [UIAlertView displayAlertWithTitle: @"提示"
    //                               message: message
    //                       leftButtonTitle: @"确定"
    //                      leftButtonAction:^{
    //                          [[NSNotificationCenter defaultCenter] postNotificationName: kPaymentWeChatSuccessNotification object: nil];
    //                      } rightButtonTitle: nil
    //                     rightButtonAction: nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: kPaymentWeChatSuccessNotification object: nil];
}

+ (void)payCancel:(PayResp *)resp
{
    NSString *message = resp.errStr;
    if ([message length] == 0 || [message isKindOfClass:[NSNull class]] || [message isEqualToString:@"(null)"])
    {
        // no message
        if (resp.errCode == WXErrCodeUserCancel)
        {
            message = @"支付取消";
        }
        else
        {
            message = @"支付失败";
        }
        
    }
    //
    //    [UIAlertView displayAlertWithTitle: @"提示"
    //                               message: message
    //                       leftButtonTitle: @"确定"
    //                      leftButtonAction: ^{
    //                          [[NSNotificationCenter defaultCenter] postNotificationName: kPaymentWeChatHaltNotification object: nil];
    //                      }
    //                      rightButtonTitle: nil
    //                     rightButtonAction: nil];
    
    NSError *err = [NSError errorWithDomain:@"WeChatPay" code:resp.errCode userInfo:@{@"returnData":message}];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPaymentWeChatHaltNotification object:err];
}

/*
 生成随即数字字符串
 */
+ (NSString *)getRandomCode:(int)length
{
    long code = 0;
    unsigned int maxSize = 10;
    int strLength = length;
    while (strLength>1)
    {
        maxSize = maxSize * 10;
        strLength--;
    }
    srandom((unsigned)time(NULL));
    code = random()%maxSize;
    NSString * codeFromat = [NSString stringWithFormat:@"%%0.%dd",length];
    NSString * randomCode = [NSString stringWithFormat:codeFromat, code];
    
    return randomCode;
}

/*
 生成随即串
 */
+ (NSString *)getRandomStr:(int)length
{
    NSString *charSet = @"abcdefghijklmnopqrstuvwxyz1234567890";
    NSUInteger charCount = [charSet length];
    NSString *string = [NSString string];
    int strLength = length;
    long code = 0;
    srandom((unsigned)time(NULL));
    while (strLength>0)
    {
        code = random()%charCount;
        string = [string stringByAppendingFormat:@"%c",[charSet characterAtIndex:code]];
        strLength--;
    }
    
    return string;
}

+ (NSString *)genNonceNum
{
    /*
     TODO
     */
    int limitCount = 8;
    
    NSString *nonceStr = [WeChatModel getRandomStr:limitCount];
    
    return nonceStr;
}
+ (NSString *)appID
{
    return kWeChatAppID;
}
+ (NSString *)appKey
{
    //考虑安全因素，APP不持有APPKEY.
    return nil;
}

+ (void)onWeChatReq:(BaseReq *)req
{
    // We do not have things to do here yet
    if ([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // ...
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        // ...
    }
}

+ (BOOL)isValidWeChatApp
{
    BOOL isValid = [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
    //    return isValid;
    //版本检查
    /*
     iOS 7 取消 getWXAppSupportMaxApiVersion 接口。
     */
    //    NSString *sdkVersion = [WXApi getApiVersion];
    //    NSString *weChatVersion = [WXApi getWXAppSupportMaxApiVersion];
    //    int comValue = [GToolUtil compareVersion:sdkVersion version:weChatVersion];
    //    isValid = isValid & (comValue<=0);
    return isValid;
}

@end

