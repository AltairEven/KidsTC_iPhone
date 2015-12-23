//
//  CouponUsableListViewController.h
//  KidsTC
//
//  Created by 钱烨 on 9/7/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "GViewController.h"
#import "CouponUsableListView.h"

typedef void(^ CouponUsableDismissBlock)(CouponBaseModel *selectedCoupon); //小于0，则未选中任何优惠券

@interface CouponUsableListViewController : GViewController

@property (nonatomic, copy) CouponUsableDismissBlock dismissBlock;

- (instancetype)initWithCouponModels:(NSArray *)modelsArray selectedCoupon:(CouponBaseModel *)coupon;

@end
