//
//  PaymentTypeModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PaymentTypeAlipay = 1,
    PaymentTypeWechat,
    PaymentType99Bill
}PaymentType;

@interface PaymentTypeModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) PaymentType type;

@property (nonatomic, strong) UIImage *logo;

- (instancetype)initWithPaymentName:(NSString *)name paymenttype:(PaymentType)type logoImage:(UIImage *)logo;

@end
