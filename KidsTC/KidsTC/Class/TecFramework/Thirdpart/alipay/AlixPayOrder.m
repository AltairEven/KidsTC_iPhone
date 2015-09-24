//
//  AlixPayOrder.m
//  AliPay
//
//  Created by WenBi on 11-5-18.
//  Copyright 2011 Alipay. All rights reserved.
//

#import "AlixPayOrder.h"

#pragma mark -
#pragma mark AlixPayOrder
@implementation AlixPayOrder

//拼接订单字符串函数,运行外部商户自行优化
- (NSString *)description {
	NSMutableString * discription = [NSMutableString string];
	[discription appendFormat:@"partner=\"%@\"", self.partner ? self.partner : @""];
	[discription appendFormat:@"&seller=\"%@\"", self.seller ? self.seller : @""];
	[discription appendFormat:@"&out_trade_no=\"%@\"", self.tradeNO ? self.tradeNO : @""];
	[discription appendFormat:@"&subject=\"%@\"", self.productName ? self.productName : @""];
	[discription appendFormat:@"&body=\"%@\"", self.productDescription ? self.productDescription : @""];
	[discription appendFormat:@"&total_fee=\"%@\"", self.amount ? self.amount : @""];
	[discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL ? self.notifyURL : @""];
	for (NSString * key in [self.extraParams allKeys]) {
		[discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
	}
	return discription;
}

@end
