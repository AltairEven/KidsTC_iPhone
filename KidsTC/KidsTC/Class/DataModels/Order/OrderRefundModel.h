//
//  OrderRefundModel.h
//  KidsTC
//
//  Created by Altair on 11/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderRefundReasonItem;

@interface OrderRefundModel : NSObject

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, assign) CGFloat refundAmount;

@property (nonatomic, assign) NSUInteger backPointNumber;

@property (nonatomic, strong) NSArray<OrderRefundReasonItem *> *refundReasons;

@property (nonatomic, strong) OrderRefundReasonItem *selectedReasonItem;

@property (nonatomic, copy) NSString *refundDescription;

- (void)fillWithRawData:(NSDictionary *)data;

@end


@interface OrderRefundReasonItem : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *reasonName;

+ (instancetype)reasonItemWithIdentifier:(NSString *)identifier name:(NSString *)name;

@end
