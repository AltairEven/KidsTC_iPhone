//
//  PaymentTypeModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "PaymentTypeModel.h"

@implementation PaymentTypeModel

- (instancetype)initWithPaymentName:(NSString *)name paymenttype:(PaymentType)type logoImage:(UIImage *)logo {
    self = [super init];
    if (self) {
        self.name = name;
        self.type = type;
        self.logo = logo;
    }
    return self;
}

@end
