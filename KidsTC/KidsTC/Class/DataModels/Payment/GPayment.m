//
//  GPayment.m
//  iphone51buy
//
//  Created by icson apple on 12-7-2.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GPayment.h"
#import "AlixPayOrder.h"
#import "NSString+UrlEncode.h"
#import "UIAlertView+Blocks.h"
#import "WeChatModel.h"
#import "GConfig.h"

@implementation GPayment

static GPayment *paymentInstance = nil;

@synthesize delegate;

+ (GPayment*)sharedInstance
{
    @synchronized([self class])
    {
		if (!paymentInstance)
        {
			paymentInstance = [[[self class] alloc] init];
		}
		return paymentInstance;
	}
	return nil;
}

- (id)init
{
	if (self = [super init]) {
		NSString *url = URL_PAY_TRADE;
		url = [NSString stringWithFormat:@"%@_",url];
		makeTradeRequest = [[HttpRequestWrapper alloc] initWithUrl: url
                                                            method: [[GConfig sharedConfig] getURLSendDataMethodWithAliasName:@"URL_PAY_TRADE"]
                                                      urlAliasName:@"URL_PAY_TRADE"];

        
		makeCaiFuTongTradeRequest = [[HttpRequestWrapper alloc] initWithUrl:url
                                                                     method:[[GConfig sharedConfig] getURLSendDataMethodWithAliasName:@"URL_PAY_TRADE"]
                                                               urlAliasName:@"URL_PAY_TRADE"];
        _makeWeChatTradeRequest = [[HttpRequestWrapper alloc] initWithUrl:url
                                                                   method:[[GConfig sharedConfig] getURLSendDataMethodWithAliasName:@"URL_PAY_TRADE"]
                                                             urlAliasName:@"URL_PAY_TRADE"];
        
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(aliTradeSuccess:) name: kPaymentAliSuccessNotification object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(aliTradeHalt:) name: kPaymentAliHaltNotification object: nil];
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(cftTradeSuccess:) name: kPaymentCftSuccessNotification object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(cftTradeHalt:) name: kPaymentCftHaltNotification object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(weChatTradeSuccess:) name:kPaymentWeChatSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(weChatTradeHalt:) name:kPaymentWeChatHaltNotification object:nil];
	}

	return self;
}

- (void)dealloc
{
    if (_orderId) {
		 _orderId = nil;
	}
	[[NSNotificationCenter defaultCenter] removeObserver: self name: kPaymentAliSuccessNotification object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: kPaymentAliHaltNotification object: nil];
	[[NSNotificationCenter defaultCenter] removeObserver: self name: kPaymentCftSuccessNotification object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: kPaymentCftHaltNotification object: nil];
	[[NSNotificationCenter defaultCenter] removeObserver: self name: kPaymentWeChatSuccessNotification object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: kPaymentWeChatHaltNotification object: nil];
    
    [makeTradeRequest cancel];
	 makeTradeRequest = nil;
	[makeCaiFuTongTradeRequest cancel];
	 makeCaiFuTongTradeRequest = nil;
	[_makeWeChatTradeRequest cancel];
    _makeWeChatTradeRequest = nil;
    [_checkTradeRequest cancel];
    _checkTradeRequest = nil;
    
}

- (void)aliTradeSuccess:(NSNotification *)notification
{
	AlixPayResult *result = nil;
	id object = [notification object];
	if ([object isKindOfClass: [AlixPayResult class]]) {
		result = (AlixPayResult *)object;
	}

	if (!result || !result.resultString) {
		return;
	}

	NSRange valueRange = [result.resultString rangeOfString:@"&out_trade_no=\""];
	if (valueRange.location == NSNotFound) {
		return;
	}

	valueRange.location += valueRange.length;
	valueRange.length = [result.resultString length] - valueRange.location;
	NSRange tempRange = [result.resultString rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:valueRange];
	if (tempRange.location == NSNotFound) {
		return;
	}
	valueRange.length = tempRange.location - valueRange.location;
	if (valueRange.length <= 0) {
		return;
	}
	if([_orderId rangeOfString:@"_1"].location != NSNotFound)
	{
		NSInteger index = [_orderId rangeOfString:@"_1"].location;
		NSString *orderTemp = [_orderId substringToIndex:index];
		_orderId = orderTemp;
	}
	NSString *orderId = [result.resultString substringWithRange:valueRange];
	if (![orderId isEqualToString: _orderId]) {
		return;
	}

	if (delegate && [delegate respondsToSelector: @selector(gPayment:tradeSuccess:)]) {
		[delegate gPayment: self tradeSuccess: result];
	}
}

- (void)aliTradeHalt:(NSNotification *)notification
{
    if (delegate && [delegate respondsToSelector: @selector(gPaymentMakeTradeHalt)]) {
		[delegate gPaymentMakeTradeHalt];
	}
}

- (void)makeTradeFinished:(NSDictionary *)result
{
	NSDictionary *tradeInfo = [result objectForKey: @"data"]; // 包含content和sign
	if (!tradeInfo || [GToolUtil isEmpty: [tradeInfo objectForKey: @"content"]] || [GToolUtil isEmpty: [tradeInfo objectForKey: @"sign"]]) {
		[self makeTradeFailed: ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_PAYMENT, ERRCODE_FIELD_EMPTY, @"数据不正确") returnStr:nil];
		return;
	}
	
	NSString *appScheme = kAliPaySchema;
	AlixPay *aliPay = [AlixPay shared];

    NSString *sign = [(NSString *)[tradeInfo objectForKey: @"sign"] urlencode];
    NSString *orderSpec = [tradeInfo objectForKey: @"content"];
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, sign, @"RSA"];  
    int ret = [aliPay pay: orderString applicationScheme: appScheme];
	if (ret == kSPErrorAlipayClientNotInstalled) {
		UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" 
															 message:@"您还没有安装支付宝的客户端，请先装。" 
															delegate:self 
												   cancelButtonTitle:@"确定" 
												   otherButtonTitles:nil];
		[alertView setTag:123];
		[alertView show];
	}
	else if (ret == kSPErrorSignError) {
		[self makeTradeFailed: ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_PAYMENT, ERRCODE_FIELD_EMPTY, @"数据不正确") returnStr:nil];
		return;
	}

	// ...
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 123) {
		NSString * URLString = @"http://itunes.apple.com/cn/app/id333206289?mt=8";
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
	}
}

- (void)makeTradeFailed:(NSError *)error returnStr:(NSString *)retStr
{
	if (delegate && [delegate respondsToSelector: @selector(gPayment:makeTradeFailed:)]) {
		[delegate gPayment: self makeTradeFailed: error];
	}
}

- (void)makeTradeLoading
{
	if (delegate && [delegate respondsToSelector: @selector(gPaymentMakeTradeLoading:)]) {
		[delegate gPaymentMakeTradeLoading: self];
	}
}

- (void)startTrade:(NSString *)orderId
{
	NSString *url = URL_PAY_TRADE;
	url = [NSString stringWithFormat: @"%@%@", url, orderId];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ((appDelegate.accessToken != nil)&&([appDelegate.accessToken isEqualToString:@""] ==NO)) {
        url = [NSString stringWithFormat:@"%@?extern_token=%@",url,appDelegate.accessToken];
    }
	[makeTradeRequest setUrl: url];
    
    
	_orderId = orderId;
	[makeTradeRequest startProcess: nil target: self onSuccess: @selector(makeTradeFinished:) onFailed: @selector(makeTradeFailed:returnStr:) onLoading: @selector(makeTradeLoading)];
}

- (void)startCaiFuTong:(NSString*)orderId
{
	NSString *url = URL_PAY_TRADE;
	url = [NSString stringWithFormat:@"%@",url];
	[makeCaiFuTongTradeRequest setUrl: [NSString stringWithFormat: @"%@%@", url, orderId]];
    NSLog(@"orderID = %@",orderId);
	_orderId = orderId;
	[makeCaiFuTongTradeRequest startProcess: nil target: self onSuccess: @selector(makeCaiFuTongTradeFinished:) onFailed: @selector(makeCaiFuTongTradeFailed:returnStr:) onLoading: @selector(makeCaiFuTongTradeLoading)];
}

-(void)makeCaiFuTongTradeFinished:(NSDictionary*)result
{
	NSLog(@"%@",result);
	NSLog(@"result = %@",result);
    NSInteger errCode = [[result objectForKey:@"errno"] integerValue];
	if(errCode == 0)
	{
		NSDictionary *dic = [result objectForKey:@"data"];
		NSString *url = [dic objectForKey:@"url"];
		if(delegate && [delegate respondsToSelector:@selector(gPayment:makeCFTWapPage:)])
		{
			[delegate gPayment:self makeCFTWapPage:url];
		}
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"tip" message:@"获取token出错" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
	}
	
}

- (void)makeCaiFuTongTradeFailed:(NSError*)error returnStr:(NSString *)retStr
{
	NSLog(@"%@",[error description]);
	
	if (delegate && [delegate respondsToSelector: @selector(gPayment:makeTradeFailed:)]) {
		[delegate gPayment: self makeTradeFailed: error];
	}
}

- (void)makeCaiFuTongTradeLoading
{
}

- (void)cftTradeSuccess:(NSNotification *)notification
{
	if (delegate && [delegate respondsToSelector: @selector(gPayment:tradeSuccess:)])
	{
		[delegate gPayment: self tradeSuccess: nil];
	}
}

- (void)cftTradeFail:(NSNotification *)notification
{
	if (delegate && [delegate respondsToSelector: @selector(gPaymentMakeTradeLoading:)]) {
		[delegate gPaymentMakeTradeLoading: self];
	}
}

#define WX_DEBUG_51 0
- (void)startWeChatTrade:(NSString *)orderID
{
    BOOL isValidWechatApp = YES;
    NSString *alertMsg = nil;
    NSString *okBtn = @"确定";
    
    if (![WXApi isWXAppInstalled])
    {
        isValidWechatApp = NO;
        alertMsg = @"您还没有安装微信，请安装后重试";
        okBtn = @"去安装";
    }
    else if (![WeChatModel isValidWeChatApp])
    {
        isValidWechatApp = NO;
        alertMsg = @"当前版本微信不是最新版本，请更新后重试";
        okBtn = @"去更新";
    }
    
    if (isValidWechatApp)
    {
        //    orderID = @"1030132249";
    #if WX_DEBUG_51
        //NSString *url = @"http://beta.m.51buy.com/pay/json.php?";//ivy 修改：把m.51buy.com改成m.yixun.com
        NSString *url = @"http://beta.m.yixun.com/pay/json.php?";
        [_makeWeChatTradeRequest setUrl: url];
    #else
        NSString *url = URL_PAY_TRADE;
        url = [NSString stringWithFormat:@"%@",url];
        [_makeWeChatTradeRequest setUrl: [NSString stringWithFormat: @"%@%@", url, orderID]];
    #endif// WX_DEBUG_51
        
        NSLog(@"orderID = %@",orderID);
        _orderId = orderID;
        
        int timeStamp = [[NSDate date] timeIntervalSince1970];
        NSString *nonceNum = [WeChatModel genNonceNum];
    #if WX_DEBUG_51
        NSDictionary *params = @{
        @"orderid":_orderId,
        @"vtl":[NSNumber numberWithInt:0],
        @"time_stamp":[NSNumber numberWithInt:timeStamp],
        @"appid":[WeChatModel appID],
        @"nonce_num":nonceNum};
    #else
        NSDictionary *params = @{@"time_stamp":[NSNumber numberWithInt:timeStamp],
        @"appid":[WeChatModel appID],
        @"nonce_num":nonceNum};
    #endif //WX_DEBUG_51
        /*
         配置微信支付参数。
         */
        WeChatModel *aWeChatModel = [WeChatModel sharedWeChatModel];
        PayReq *request = [[PayReq alloc] init];
        request.nonceStr = nonceNum;
        request.timeStamp = timeStamp;
        aWeChatModel.payRequest = request;
        
        [_makeWeChatTradeRequest startProcess: params target: self onSuccess: @selector(makeWeChatTradeFinished:) onFailed: @selector(makeWeChatTradeFailed:) onLoading: @selector(makeWeChatTradeLoading)];
    }
    else
    {
        //微信APP 不可用
        [UIAlertView displayAlertWithTitle:@"提示"
                                   message:alertMsg
                           leftButtonTitle:@"稍后再说"
                          leftButtonAction:nil
                          rightButtonTitle:okBtn
                         rightButtonAction:^{
                             NSString *url = [WXApi getWXAppInstallUrl];
                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                         }];
        
        if (delegate && [delegate respondsToSelector: @selector(gPayment:makeTradeFailed:)])
        {
            [delegate gPayment: self makeTradeFailed: nil];
        }
    }
}

-(void)makeWeChatTradeFinished:(NSDictionary*)result
{
	NSLog(@"%@",result);
	NSLog(@"result = %@",result);
    NSInteger errCode = [[result objectForKey:@"errno"] integerValue];
	if(errCode == 0)
	{
		NSDictionary *dic = [result objectForKey:@"data"];
		NSString *package = [dic objectForKey:@"package"];
        NSString *prepayID = [dic objectForKey:@"token"];
        NSString *partner = [dic objectForKey:@"partner"];
        NSString *sign = [dic objectForKey:@"sign"];
        
        /*
         配置微信支付参数。
         */
        WeChatModel *aWeChatModel = [WeChatModel sharedWeChatModel];
        aWeChatModel.payRequest.partnerId = partner;
        aWeChatModel.payRequest.prepayId = prepayID;
        aWeChatModel.payRequest.package = package;
        aWeChatModel.payRequest.sign = sign;
        
        /*启动微信支付*/
        /**/
        [aWeChatModel startWeChatTrade];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"tip" message:@"获取数字证书出错" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
	}
	
}

- (void)makeWeChatTradeFailed:(NSError*)error
{
	NSLog(@"%@",[error description]);
	
	if (delegate && [delegate respondsToSelector: @selector(gPayment:makeTradeFailed:)]) {
		[delegate gPayment: self makeTradeFailed: error];
	}
}

- (void)makeWeChatTradeLoading
{
}

- (void)checkWeChatTradeFinished:(NSDictionary *)result
{
    NSInteger errCode = [[result objectForKey:@"errno"] integerValue];
	if(errCode == 0)
	{
        if (delegate && [delegate respondsToSelector: @selector(gPayment:tradeSuccess:)])
        {
            [delegate gPayment: self tradeSuccess: nil];
        }
    }
    else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"tip" message:@"没有完成支付结果验证" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
	}
}
- (void)checkWeChatTradeFailed:(NSError *)error
{
    if (delegate && [delegate respondsToSelector: @selector(gPayment:makeTradeFailed:)]) {
		[delegate gPayment:self makeTradeFailed:error];
	}
}
- (void)checkWeChatTradeLoading
{}

- (void)weChatTradeSuccess:(NSNotification *)notification
{
#if 0
    /*
     验证支付状态
     */
    
    NSString *url = URL_PAY_TRADE;
	url = [NSString stringWithFormat:@"%@_",url];
	[_checkTradeRequest setUrl: [NSString stringWithFormat: @"%@%@", url, _orderId]];
    
    [_checkTradeRequest startProcess: nil target: self onSuccess: @selector(checkWeChatTradeFinished:) onFailed: @selector(checkWeChatTradeFailed:) onLoading: @selector(checkWeChatTradeLoading)];
#else
    /*
     支付成功
     */
    if (delegate && [delegate respondsToSelector: @selector(gPayment:tradeSuccess:)])
    {
        [delegate gPayment: self tradeSuccess: nil];
    }
#endif
}

- (void)weChatTradeHalt:(NSNotification *)notification
{
	if (delegate && [delegate respondsToSelector: @selector(gPayment:makeTradeFailed:)]) {
		[delegate gPayment:self makeTradeFailed:notification.object];
	}
}

+ (NSString *)payTypeNameOfID:(int)payID
{
    NSString *name = nil;
    switch (payID) {
        case GPayTypeCaiFuTong:
            name = @"财付通";
            break;
        case GPayTypeAlipay:
            name = @"支付宝";
            break;
        case GPayTypeWeChat:
            name = @"微信支付";
        default:
            break;
    }
    return name;
}

@end
