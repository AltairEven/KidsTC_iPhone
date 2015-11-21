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



//@property (nonatomic, strong) CouponFullCutModel *usedCoupon;
//
//@property (nonatomic, assign) NSUInteger usedScore;
//
//@property (nonatomic, assign) CGFloat totalPrice;
#pragma mark Private methods

- (void)loadSettlementSucceed:(NSDictionary *)data {
    NSArray *dataArray = [data objectForKey:@"data"];
    if ([dataArray isKindOfClass:[NSArray class]]) {
        _dataModel = [[SettlementModel alloc] initWithRawData:[dataArray firstObject]];
        _dataModel.soleId = [data objectForKey:@"soleid"];
        
        [_dataModel setUsedCoupon:self.lastDataModel.usedCoupon];
        [_dataModel setUsedScore:self.lastDataModel.usedScore];
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

- (void)resetWithUsedCoupon:(CouponBaseModel *)coupon {
    CouponFullCutModel *model = (CouponFullCutModel *)coupon;
    [self.dataModel setUsedCoupon:model];
    [self.view reloadData];
}

- (void)resetWithUsedScore:(NSUInteger)score {
    [self.dataModel setUsedScore:score];
    [self.view reloadData];
}

- (void)resetWithSelectedPaymentIndex:(NSUInteger)index {
    PaymentTypeModel *model = [self.dataModel.supportedPaymentTypes objectAtIndex:index];
    [self.dataModel setCurrentPaymentType:model];
}

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadSettlementRequest) {
        self.loadSettlementRequest = [HttpRequestClient clientWithUrlAliasName:@"SHOPPINGCART_GET"];
        [self.loadSettlementRequest setErrorBlock:self.netErrorBlock];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObject:[KTCUser currentUser].uid forKey:@"uid"];
    
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
        self.submitOrderRequest = [HttpRequestClient clientWithUrlAliasName:@"ORDER_PLACE_ORDER"];
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
            _orderId = [dataDic objectForKey:@"orderNo"];
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
