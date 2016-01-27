//
//  OrderRefundModel.h
//  KidsTC
//
//  Created by Altair on 11/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    OrderRefundStatusApply,
    OrderRefundStatusSucceed
}OrderRefundStatus;

@class OrderRefundReasonItem;

@interface OrderRefundModel : NSObject

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, assign) NSUInteger maxRefundCount;

@property (nonatomic, assign) NSUInteger refundCount;

@property (nonatomic, assign) CGFloat unitRefundAmount;

@property (nonatomic, assign) CGFloat totalRefundAmount;

@property (nonatomic, assign) NSUInteger unitPointNumber;

@property (nonatomic, assign) NSUInteger totalPointNumber;

@property (nonatomic, strong) NSArray<OrderRefundReasonItem *> *refundReasons;

@property (nonatomic, strong) OrderRefundReasonItem *selectedReasonItem;

@property (nonatomic, copy) NSString *refundDescription;

- (BOOL)fillWithRawData:(NSDictionary *)data;

- (CGFloat)refundAmount;

- (NSUInteger)backPoint;

@end


@interface OrderRefundReasonItem : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *reasonName;

+ (instancetype)reasonItemWithIdentifier:(NSString *)identifier name:(NSString *)name;

@end


@interface OrderRefundFlowModel : NSObject

@property (nonatomic, assign) OrderRefundStatus status;

@property (nonatomic, strong) NSArray *refundCodes;

@property (nonatomic, copy) NSString *applyTimeDes;

@property (nonatomic, copy) NSString *statusDescription;

@property (nonatomic, copy) NSString *flowDescription;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (NSString *)codeString;

- (CGFloat)cellHeight;

@end
