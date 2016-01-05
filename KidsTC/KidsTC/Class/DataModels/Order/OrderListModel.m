//
//  OrderListModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"orderId"]) {
            self.orderId = [NSString stringWithFormat:@"%@", [data objectForKey:@"orderId"]];
        } else {
            return nil;
        }
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.orderName = [data objectForKey:@"name"];
        if ([data objectForKey:@"productNo"]) {
            self.serviceId = [NSString stringWithFormat:@"%@", [data objectForKey:@"productNo"]];
        }
        self.price = [[data objectForKey:@"price"] floatValue];
        self.orderDate = [data objectForKey:@"time"];
        self.status = (OrderStatus)[[data objectForKey:@"orderState"] integerValue];
        self.statusDescription = [data objectForKey:@"orderStateName"];
        NSString *paymentName = [data objectForKey:@"paytypeName"];
        PaymentType payType = (PaymentType)[[data objectForKey:@"paytype"] integerValue];
        self.pamentType = [[PaymentTypeModel alloc] initWithPaymentName:paymentName paymenttype:payType logoImage:nil];
        self.productType = [[data objectForKey:@"productType"] integerValue];
    }
    return self;
}

- (CGFloat)cellHeight {
    return 180;
}

@end
