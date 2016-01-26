//
//  CouponFullCutModel.m
//  KidsTC
//
//  Created by 钱烨 on 9/6/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CouponFullCutModel.h"

@implementation CouponFullCutModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    self = [super initWithRawData:data];
    if (self) {
        if ([data objectForKey:@"code"]) {
            self.couponId = [NSString stringWithFormat:@"%@", [data objectForKey:@"code"]];
        }
        if ([data objectForKey:@"batchId"]) {
            self.batchId = [NSString stringWithFormat:@"%@", [data objectForKey:@"batchId"]];
        }
        self.couponTitle = [data objectForKey:@"name"];
        self.couponDescription = [data objectForKey:@"desc"];
        self.fetchTime = [data objectForKey:@"fetchTime"];
        self.startTime = [data objectForKey:@"startTime"];
        self.endTime = [data objectForKey:@"endTime"];
        self.usePrice = [[data objectForKey:@"fiftyAmt"] floatValue];
        self.discount = [[data objectForKey:@"couponAmt"] floatValue];
        self.status = (CouponStatus)[[data objectForKey:@"status"] integerValue];
        self.statusDescription = [data objectForKey:@"statusName"];
        self.useTag = (CouponUseTag)[[data objectForKey:@"useTag"] integerValue];
        self.hasRelatedService = [[data objectForKey:@"isLink"] boolValue];
    }
    return self;
}

@end
