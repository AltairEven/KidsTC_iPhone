//
//  OrderDetailModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "OrderDetailModel.h"
#import "Insurance.h"

@implementation OrderDetailModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"oderId"]) {
            self.orderId = [NSString stringWithFormat:@"%@", [data objectForKey:@"oderId"]];
        }
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.orderName = [data objectForKey:@"name"];
        self.orderDate = [data objectForKey:@"time"];
        self.status = (OrderStatus)[[data objectForKey:@"orderState"] integerValue];
        self.statusDescription = [data objectForKey:@"orderStateName"];
        if ([data objectForKey:@"serveId"]) {
            self.serviceId = [NSString stringWithFormat:@"%@", [data objectForKey:@"serveId"]];
        }
        self.servicePrice = [[data objectForKey:@"price"] floatValue];
        self.serviceCount = [[data objectForKey:@"count"] integerValue];
        self.price = self.servicePrice * self.serviceCount;
        self.supportedInsurances = [Insurance InsurancesWithRawData:[data objectForKey:@"insurance"]];
        self.phone = [data objectForKey:@"phone"];
        NSString *paymentName = [data objectForKey:@"paytypeName"];
        PaymentType payType = (PaymentType)[[data objectForKey:@"paytype"] integerValue];
        self.pamentType = [[PaymentTypeModel alloc] initWithPaymentName:paymentName paymenttype:payType logoImage:nil];

    }
    return self;
}

- (BOOL)supportRefund {
    BOOL bSupport = NO;
    if ([self.supportedInsurances count] > 0) {
        bSupport = YES;
    }
    return bSupport;
}


- (BOOL)canGetCode {
    BOOL retValue = NO;
    if (self.status == OrderStatusHasPayed || self.status == OrderStatusPartialUsed) {
        retValue = YES;
    }
    return retValue;
}

@end
