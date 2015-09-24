//
//  SettlementModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "SettlementModel.h"

@implementation SettlementModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"serveId"]) {
            self.serviceId = [NSString stringWithFormat:@"%@", [data objectForKey:@"serveId"]];
        }
        if ([data objectForKey:@"channelId"]) {
            self.channelId = [NSString stringWithFormat:@"%@", [data objectForKey:@"channelId"]];
        }
        self.storeName = [data objectForKey:@"storeName"];
        self.serviceName = [data objectForKey:@"serveName"];
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.price = [[data objectForKey:@"price"] floatValue];
        self.count = [[data objectForKey:@"count"] integerValue];
        NSDictionary *payDic = [data objectForKey:@"pay_type"];
        if ([payDic isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSString *name in [payDic allKeys]) {
                if ([name isEqualToString:@"ali"]) {
                    PaymentTypeModel *model = [[PaymentTypeModel alloc] initWithPaymentName:@"支付宝" paymenttype:PaymentTypeAlipay logoImage:[UIImage imageNamed:@"logo_ali"]];
                    [array addObject:model];
                    continue;
                }
                if ([name isEqualToString:@"WeChat"]) {
                    PaymentTypeModel *model = [[PaymentTypeModel alloc] initWithPaymentName:@"微信" paymenttype:PaymentTypeWechat logoImage:[UIImage imageNamed:@"logo_wechat"]];
                    [array addObject:model];
                    continue;
                }
                if ([name isEqualToString:@"99bill"]) {
                    PaymentTypeModel *model = [[PaymentTypeModel alloc] initWithPaymentName:@"快钱" paymenttype:PaymentType99Bill logoImage:[UIImage imageNamed:@"logo_99bill"]];
                    [array addObject:model];
                    continue;
                }
            }
            self.supportedPaymentTypes = [NSArray arrayWithArray:array];
        }
        if ([self.supportedPaymentTypes count] > 0) {
            PaymentTypeModel *model = [self.supportedPaymentTypes firstObject];
            self.currentPaymentType = model;
        }
        NSArray *usableCouponsArray = [data objectForKey:@"coupon"];
        if ([usableCouponsArray isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempCoupons = [[NSMutableArray alloc] init];
            for (NSDictionary *couponDic in usableCouponsArray) {
                CouponFullCutModel *model = [[CouponFullCutModel alloc] initWithRawData:couponDic];
                if (model) {
                    [tempCoupons addObject:model];
                }
            }
            if ([tempCoupons count] > 0) {
                self.usableCoupons = [NSArray arrayWithArray:tempCoupons];
            }
        }
        NSDictionary *promotionDic = [data objectForKey:@"promotion"];
        if ([promotionDic isKindOfClass:[NSDictionary class]]) {
            self.promotionModel = [[PromotionFullCutModel alloc] initWithRawData:promotionDic];
        }
        self.score = [[data objectForKey:@"scorenum"] integerValue];
        
        _totalPrice = (self.price * self.count) - self.promotionModel.cutAmount - (self.usedScore * ScoreCoefficient);
    }
    return self;
}

- (void)setUsedCoupon:(CouponFullCutModel *)usedCoupon {
    NSInteger selectedIndex = -1;
    for (NSUInteger index = 0; index < [self.usableCoupons count]; index ++) {
        CouponFullCutModel *model = [self.usableCoupons objectAtIndex:index];
        if ([model.couponId isEqualToString:usedCoupon.couponId]) {
            selectedIndex = index;
            break;
        }
    }
    if (selectedIndex >= 0) {
        _usedCoupon = usedCoupon;
        _totalPrice = (self.price * self.count) - usedCoupon.discount - (self.usedScore * ScoreCoefficient);
    } else {
        _usedCoupon = nil;
        _totalPrice = (self.price * self.count) - self.promotionModel.cutAmount - (self.usedScore * ScoreCoefficient);
    }
}

- (void)setUsedScore:(NSUInteger)usedScore {
    if (self.score >= usedScore) {
        _usedScore = usedScore;
    } else {
        _usedScore = 0;
    }
    if (self.usedCoupon) {
        _totalPrice = (self.price * self.count) - self.usedCoupon.discount - (_usedScore * ScoreCoefficient);
    } else {
        _totalPrice = (self.price * self.count) - self.promotionModel.cutAmount - (_usedScore * ScoreCoefficient);
    }
}

@end
