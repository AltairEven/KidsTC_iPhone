//
//  GPayment.h
//  iphone51buy
//
//  Created by icson apple on 12-7-2.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestWrapper.h"
#import "AlixPay.h"
#import "MTA.h"

#define kPaymentAliSuccessNotification @"kPaymentAliSuccessNotification"
#define kPaymentAliHaltNotification @"kPaymentAliHaltNotification"
#define kPaymentCftSuccessNotification @"kPaymentCftSuccessNotification"
#define kPaymentCftHaltNotification @"kPaymentCftHaltNotification"
#define kPaymentWeChatSuccessNotification @"kPaymentWeChatSuccessNotification"
#define kPaymentWeChatHaltNotification @"kPaymentWeChatHaltNotification"

typedef enum
{
    GPayTypeCash = 1,
    GPayTypeCaiFuTong = 8,
    GPayTypeAlipay = 21,
    GPayTypeWeChat = 502
}GPayType;

@class GPayment;
@protocol GPaymentDelegate<NSObject>
@optional
- (void)gPayment:(GPayment *)_payment makeTradeFailed:(NSError *)_error;
- (void)gPaymentMakeTradeHalt;
- (void)gPayment:(GPayment *)_payment tradeSuccess:(AlixPayResult *)result;
- (void)gPaymentMakeTradeLoading:(GPayment *)_payment;
- (void)gPayment:(GPayment*)_payment makeCFTWapPage:(NSString*)url;
- (void)GPaymentTradeResultChecking:(GPayment*)payment;
- (void)GPayment:(GPayment*)payment checkResult:(NSDictionary *)result;
@end

@interface GPayment : NSObject
{
	HttpRequestWrapper *makeTradeRequest;
	HttpRequestWrapper *makeCaiFuTongTradeRequest;
    HttpRequestWrapper *_makeWeChatTradeRequest;
    HttpRequestWrapper *_checkTradeRequest;
	NSString *_orderId;
}

@property (weak, nonatomic) id<GPaymentDelegate> delegate;
- (void)startTrade:(NSString *)orderId;
- (void)startCaiFuTong:(NSString*)orderId;
- (void)startWeChatTrade:(NSString *)orderID;
+ (NSString *)payTypeNameOfID:(int)payID;
+ (GPayment*)sharedInstance;
@end

