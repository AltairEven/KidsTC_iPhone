//
//  OrderRefundModel.m
//  KidsTC
//
//  Created by Altair on 11/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "OrderRefundModel.h"

@implementation OrderRefundModel

- (void)fillWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.maxRefundCount = [[data objectForKey:@"refundMaxNum"] integerValue];
    self.unitRefundAmount = [[data objectForKey:@"singleRefundAmt"] floatValue];
    self.totalRefundAmount = [[data objectForKey:@"totalRefundAmt"] floatValue];
    self.unitPointNumber = [[data objectForKey:@"singleRefundScore"] integerValue];
    self.totalPointNumber = [[data objectForKey:@"totalRefundScore"] integerValue];
    NSArray *reasons = [data objectForKey:@"reasons"];
    if ([reasons isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *singleDic in reasons) {
            NSString *identifier = [NSString stringWithFormat:@"%@", [singleDic objectForKey:@"type"]];
            NSString *name = [singleDic objectForKey:@"name"];
            OrderRefundReasonItem *item = [OrderRefundReasonItem reasonItemWithIdentifier:identifier name:name];
            if (item) {
                [tempArray addObject:item];
            }
        }
        self.refundReasons = [NSArray arrayWithArray:tempArray];
    }
    self.refundCount = 1;
}

- (CGFloat)refundAmount {
    CGFloat amount = 0;
    if (self.refundCount == self.maxRefundCount) {
        amount = self.totalRefundAmount;
    } else {
        amount = self.refundCount * self.unitRefundAmount;
    }
    return amount;
}

- (NSUInteger)backPoint {
    NSUInteger point = 0;
    if (self.refundCount == self.maxRefundCount) {
        point = self.totalPointNumber;
    } else {
        point = self.refundCount * self.unitPointNumber;
    }
    return point;
}

@end


@implementation OrderRefundReasonItem

+ (instancetype)reasonItemWithIdentifier:(NSString *)identifier name:(NSString *)name {
    if (!identifier || ![identifier isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (!name || ![name isKindOfClass:[NSString class]]) {
        return nil;
    }
    OrderRefundReasonItem *item = [[OrderRefundReasonItem alloc] init];
    item.identifier = identifier;
    item.reasonName = name;
    return item;
}

@end