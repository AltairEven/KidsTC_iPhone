//
//  OrderRefundViewModel.m
//  KidsTC
//
//  Created by Altair on 11/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "OrderRefundViewModel.h"

@interface OrderRefundViewModel () <OrderRefundViewDataSource>

@property (nonatomic, weak) OrderRefundView *view;

@property (nonatomic, strong) HttpRequestClient *loadRefundRequest;

@property (nonatomic, strong) HttpRequestClient *createRefundRequest;

- (void)loadRefundSucceed:(NSDictionary *)data;

- (void)loadRefundFailed:(NSError *)error;

- (void)createRefundSucceed:(NSDictionary *)data;

- (void)createRefundFailed:(NSError *)error;

@end

@implementation OrderRefundViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (OrderRefundView *)view;
        self.view.dataSource = self;
        self.refundModel = [[OrderRefundModel alloc] init];
    }
    return self;
}

#pragma mark SoftwareSettingViewDataSource

- (OrderRefundModel *)refundModelForOrderRefundView:(OrderRefundView *)view {
    return self.refundModel;
}

#pragma mark Private methods

- (void)loadRefundSucceed:(NSDictionary *)data {
    NSDictionary *refundData = [data objectForKey:@"data"];
    [self.refundModel fillWithRawData:refundData];
    [self.view reloadData];
}

- (void)loadRefundFailed:(NSError *)error {
    
}

- (void)createRefundSucceed:(NSDictionary *)data {
    
}

- (void)createRefundFailed:(NSError *)error {
    
}

#pragma mark Public methods

- (void)createOrderRefundWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.createRefundRequest) {
        self.createRefundRequest = [HttpRequestClient clientWithUrlAliasName:@"ORDER_CREATE_REFUND"];
    } else {
        [self.createRefundRequest cancel];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.refundModel.orderId, @"orderid",
                           [GConfig generateSMSCodeKey], @"soleid",
                           self.refundModel.refundDescription, @"reason",
                           self.refundModel.selectedReasonItem.identifier, @"type",
                           [NSNumber numberWithInteger:self.refundModel.refundCount], @"refundNum", nil];
    
    __weak OrderRefundViewModel *weakSelf = self;
    [weakSelf.createRefundRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf createRefundSucceed:responseData];
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf createRefundFailed:error];
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark Super methods

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadRefundRequest) {
        self.loadRefundRequest = [HttpRequestClient clientWithUrlAliasName:@"ORDER_GET_USER_REFUND"];
    } else {
        [self.loadRefundRequest cancel];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObject:self.refundModel.orderId forKey:@"orderId"];
    __weak OrderRefundViewModel *weakSelf = self;
    [weakSelf.loadRefundRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadRefundSucceed:responseData];
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadRefundFailed:error];
        if (failure) {
            failure(error);
        }
    }];
}

- (void)stopUpdateData {
    [self.loadRefundRequest cancel];
    [self.createRefundRequest cancel];
}

@end
