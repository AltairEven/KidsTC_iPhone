//
//  ServiceMoreDetailHotSalesItemModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/15/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceMoreDetailHotSalesItemModel.h"

@implementation ServiceMoreDetailHotSalesItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        self.imageUrl = nil;
        self.name = @"韩国专业宝宝摄影套餐，特价优惠，活动限量，先到先得";
        self.price = 12000;
    }
    return self;
}

@end
