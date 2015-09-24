//
//  CouponBaseModel.h
//  KidsTC
//
//  Created by 钱烨 on 9/6/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CouponStatusUnknown,
    CouponStatusUnused,
    CouponStatusHasUsed,
    CouponStatusNotReachTimel,
    CouponStatusHasOverTime
}CouponStatus;

typedef enum {
    CouponUseTagUnknow,
    CouponUseTagUsable,
    CouponUseTagUnusable
}CouponUseTag;

@interface CouponBaseModel : NSObject

@property (nonatomic, copy) NSString *couponId;

@property (nonatomic, copy) NSString *couponTitle;

@property (nonatomic, copy) NSString *couponDescription;

@property (nonatomic, copy) NSString *fetchTime;

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, assign) CouponStatus status;

@property (nonatomic, copy) NSString *statusDescription;

@property (nonatomic, assign) CouponUseTag useTag;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
