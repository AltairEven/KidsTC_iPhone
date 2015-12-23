/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：OCOrderItem.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：haoquanbai
 * 完成日期：13-2-28
 */

#import "OCOrderItem.h"
#import <objc/runtime.h>

@implementation OCOrderItem

- (id)initWithRawData:(NSDictionary *)rawData
{
    if (self = [super init])
    {
        NSDictionary *invoiceData = [rawData objectForKey:@"invoice"];
        self.invoiceContentArr = [invoiceData objectForKey:@"contentOpt"];
        self.isCanVAT = [[invoiceData objectForKey:@"isCanVAT"] boolValue];
        
        NSDictionary *packageList = [rawData objectForKey:@"packageList"];
		NSMutableDictionary *mutalbe = [NSMutableDictionary dictionary];
		for (NSString* key in [packageList allKeys])
		{
			NSDictionary *orderData = [packageList objectForKey:key];
			OCPackageItem *item = [[OCPackageItem alloc] initWithRawData:orderData andKey:key];
			[mutalbe setObject:item forKey:key];
		}
		self.packageItems = [NSDictionary dictionaryWithDictionary:mutalbe];
        
        if ([rawData[@"coupons"] isKindOfClass:[NSArray class]]) {
            self.coupons = rawData[@"coupons"];
        }
		
        if ([[rawData objectForKey:@"promotion"] isKindOfClass:[NSArray class]])
        {
            self.promotionArray = [rawData objectForKey:@"promotion"];
        }
        
        self.pointRange = [rawData objectForKey:@"pointrange"];
        self.allowCoupon = !([rawData objectForKey:@"allowCoupon"] && [[rawData objectForKey:@"allowCoupon"] intValue] == 0);
    }

    return self;
}


- (NSString *)description
{
    NSMutableString * description = [NSMutableString string];
    NSString *className = NSStringFromClass([self class]);
    [description appendFormat:@"%@ = {\n", className];
    [description appendFormat:@"\tinvoiceContentArr=%@\n", self.invoiceContentArr];
    [description appendFormat:@"\tisCanVAT=%d\n", self.isCanVAT];
	[description appendString:@"}\n"];

	return description;
}

@end

@implementation OCPackageItem

- (id)initWithRawData:(NSDictionary *)rawData andKey:(NSString*)key
{
    if (self = [super init])
    {
		self.orderID = key;
		self.isVirtual = [[rawData objectForKey:@"isVirtual"] intValue];
		self.vValue = [rawData objectForKey:@"vValue"];
		self.ruleBenefits = [[rawData objectForKey:@"rule_benefits"] intValue];
		self.psyStock = [[rawData objectForKey:@"psystock"] integerValue];
		self.totalAmt = [[rawData objectForKey:@"totalAmt"] intValue];
		self.totalCut = [[rawData objectForKey:@"totalCut"] intValue];
		self.saleMode = [[rawData objectForKey:@"sale_mode"] intValue];
		self.sallerId = [[rawData objectForKey:@"seller_id"]intValue];
		self.sallerStockId = [[rawData objectForKey:@"seller_stock_id"] intValue];
		self.productList = [rawData objectForKey:@"items"];
	}
	return self;
}


- (NSString *)description
{
    NSMutableString * description = [NSMutableString string];
    NSString *className = NSStringFromClass([self class]);
    [description appendFormat:@"%@ = {\n", className];
	[description appendFormat:@"\torderID=%@\n", self.orderID];
	[description appendFormat:@"\tvValue=%@\n", self.vValue];
	[description appendFormat:@"\tpsyStock=%d\n", self.psyStock];
	[description appendFormat:@"\truleBenefits=%d\n", self.ruleBenefits];
	[description appendFormat:@"\ttotalAmt=%d\n", self.totalAmt];
	[description appendFormat:@"\ttotalCut=%d\n", self.totalCut];
	[description appendFormat:@"\tsaleMode=%d\n", self.saleMode];
	[description appendFormat:@"\tsallerId=%d\n", self.sallerId];
	[description appendFormat:@"\tsallerStockId=%d\n", self.sallerStockId];

//    [description appendFormat:@"\tinvoiceContentArr=%@\n", self.invoiceContentArr];
//    [description appendFormat:@"\tisCanVAT=%d\n", self.isCanVAT];
	[description appendFormat:@"\tproductList=%@\n", self.productList];
	[description appendString:@"}\n"];

	return description;
}

@end
