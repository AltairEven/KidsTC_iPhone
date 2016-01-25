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
        } else {
            return nil;
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
        self.canRefund = [[data objectForKey:@"canRefund"] boolValue];
        self.canContactCS = [[data objectForKey:@"isNeedConnectService"] boolValue];
        self.originalAmount = [[data objectForKey:@"originalAmt"] floatValue];
        self.discountAmount = [[data objectForKey:@"discountAmt"] floatValue];
        self.orderDetailDescription = [data objectForKey:@"orderDetailDesc"];
        self.usedPointNumber = [[data objectForKey:@"scoreNum"] integerValue];
        
        if ([self.orderDetailDescription length] == 0) {
            self.orderDetailDescription = self.statusDescription;
        }
        self.orderPaymentDes = [data objectForKey:@"expireTimeDesc"];
        self.productType = [[data objectForKey:@"productType"] integerValue];
        
        self.price = self.originalAmount - self.discountAmount - self.usedPointNumber * ScoreCoefficient;
        
        NSArray *refunds = [data objectForKey:@"refunds"];
        if ([refunds isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *singleElem in refunds) {
                NSString *des = [singleElem objectForKey:@"refund_notice"];
                if ([des isKindOfClass:[NSString class]] && [des length] > 0) {
                    [tempArray addObject:des];
                }
            }
            self.refundDescriptions = [NSArray arrayWithArray:tempArray];
        }
    }
    return self;
}


- (BOOL)canGetCode {
    BOOL retValue = NO;
    if (self.status == OrderStatusHasPayed || self.status == OrderStatusPartialUsed) {
        retValue = YES;
    }
    return retValue;
}

- (CGFloat)refundDescriptionCellHeightAtIndex:(NSUInteger)index {
    CGFloat height = 0;
    if ([self.refundDescriptions count] > index) {
        NSString *des = [self.refundDescriptions objectAtIndex:index];
        height = [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 20 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 andText:des];
    }
    return height;
}

@end
