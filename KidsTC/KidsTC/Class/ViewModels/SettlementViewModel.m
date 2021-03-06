//
//  SettlementViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/19/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "SettlementViewModel.h"

@interface SettlementViewModel () <SettlementViewDataSource>

@property (nonatomic, weak) SettlementView *view;

@property (nonatomic, strong) HttpRequestClient *loadSettlementRequest;

@property (nonatomic, strong) HttpRequestClient *submitOrderRequest;

@property (nonatomic, strong) SettlementModel *lastDataModel;

- (void)loadSettlementSucceed:(NSDictionary *)data;

- (void)loadSettlementFailed:(NSError *)error;

- (void)submitOrderSucceed:(NSDictionary *)data;

@end

@implementation SettlementViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (SettlementView *)view;
        self.view.dataSource = self;
    }
    return self;
}

#pragma mark SettlementViewDataSource

- (SettlementModel *)settlementModelForSettlementView:(SettlementView *)settlementView {
    return self.dataModel;
}


#pragma mark Private methods

- (void)loadSettlementSucceed:(NSDictionary *)data {
    NSArray *dataArray = [data objectForKey:@"data"];
    if ([dataArray isKindOfClass:[NSArray class]]) {
        _dataModel = [[SettlementModel alloc] initWithRawData:[dataArray firstObject]];
        _dataModel.soleId = [data objectForKey:@"soleid"];
        
        if (self.lastDataModel) {
            [_dataModel setUsedCoupon:self.lastDataModel.usedCoupon];
            [_dataModel setUsedScore:self.lastDataModel.usedScore];
        }
    }
    [self.view reloadData];
}

- (void)loadSettlementFailed:(NSError *)error {
    
}


- (void)submitOrderSucceed:(NSDictionary *)data {
    NSDictionary *payInfo = [data objectForKey:@"payInfo"];
    _paymentInfo = [KTCPaymentInfo instanceWithRawData:payInfo];
}

#pragma mark Public methods

- (void)resetWithUsedCoupon:(CouponBaseModel *)coupon succeed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    CouponFullCutModel *model = (CouponFullCutModel *)coupon;
    [self.dataModel setUsedCoupon:model];
    [self startUpdateDataWithSucceed:succeed failure:failure];
}

- (void)resetWithUsedScore:(NSUInteger)score succeed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    [self.dataModel setUsedScore:score];
    [self startUpdateDataWithSucceed:succeed failure:failure];
}

- (void)resetWithSelectedPaymentIndex:(NSUInteger)index {
    PaymentTypeModel *model = [self.dataModel.supportedPaymentTypes objectAtIndex:index];
    [self.dataModel setCurrentPaymentType:model];
}

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadSettlementRequest) {
        self.loadSettlementRequest = [HttpRequestClient clientWithUrlAliasName:@"SHOPPINGCART_GET_V2"];
        [self.loadSettlementRequest setErrorBlock:self.netErrorBlock];
    }
    
    NSString *couponCode = [[self.dataModel usedCoupon] couponId];
    if ([couponCode length] == 0) {
        couponCode = @"";
    }
    
    BOOL hasUsedCoupon = YES;
    if (self.dataModel) {
        hasUsedCoupon = self.dataModel.hasUsedCoupon;
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [KTCUser currentUser].uid, @"uid",
                           couponCode, @"couponCode",
                           [NSNumber numberWithInteger:self.dataModel.usedScore], @"scoreNum",
                           [NSNumber numberWithBool:!hasUsedCoupon], @"isCancelCoupon", nil];
    
    self.lastDataModel = self.dataModel;
    
    __weak SettlementViewModel *weakSelf = self;
    [weakSelf.loadSettlementRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadSettlementSucceed:responseData];
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadSettlementFailed:error];
        if (failure) {
            failure(error);
        }
    }];
}


- (void)submitOrderWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.submitOrderRequest) {
        self.submitOrderRequest = [HttpRequestClient clientWithUrlAliasName:@"ORDER_PLACE_ORDER_V2"];
    }
    NSString *couponCode = @"";
    BOOL isPromotion = NO;
    if (!self.dataModel.usedCoupon) {
        //没有使用优惠券
        if (self.dataModel.promotionModel) {
            isPromotion = YES;
        }
    } else {
        //使用优惠券
        couponCode = self.dataModel.usedCoupon.couponId;
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:self.dataModel.currentPaymentType.type], @"paytype",
                           self.dataModel.soleId, @"soleid",
                           couponCode, @"couponCode",
                           [NSNumber numberWithInteger:self.dataModel.usedScore], @"point",
                           [NSNumber numberWithBool:isPromotion], @"isFullCut",
                           [NSNumber numberWithFloat:self.dataModel.totalPrice], @"price", nil];
    
    __weak SettlementViewModel *weakSelf = self;
    [weakSelf.submitOrderRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        NSDictionary *dataDic = [responseData objectForKey:@"data"];
        if (dataDic && [dataDic isKindOfClass:[NSDictionary class]]) {
            _orderId = [NSString stringWithFormat:@"%@", [dataDic objectForKey:@"orderNo"]];
        }
        if ([weakSelf.orderId length] > 0) {
            [weakSelf submitOrderSucceed:dataDic];
            if (succeed) {
                succeed(responseData);
            }
        } else {
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"Submit Order" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"下单失败" forKey:kErrMsgKey]];
                failure(error);
            }
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end
