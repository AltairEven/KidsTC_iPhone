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
    self.refundAmount = 999.99;
    self.backPointNumber = 30;
    
    OrderRefundReasonItem *item1 = [OrderRefundReasonItem reasonItemWithIdentifier:@"1" name:@"不好玩"];
    OrderRefundReasonItem *item2 = [OrderRefundReasonItem reasonItemWithIdentifier:@"2" name:@"往哪里跑"];
    OrderRefundReasonItem *item3 = [OrderRefundReasonItem reasonItemWithIdentifier:@"3" name:@"别害怕"];
    self.refundReasons = [NSArray arrayWithObjects:item1, item2, item3, nil];
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