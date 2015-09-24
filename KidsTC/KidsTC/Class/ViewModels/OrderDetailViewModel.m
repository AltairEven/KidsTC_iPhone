//
//  OrderDetailViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/12/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "OrderDetailViewModel.h"

@interface OrderDetailViewModel () <OrderDetailViewDataSource>

@property (nonatomic, weak) OrderDetailView *view;

@property (nonatomic, strong) HttpRequestClient *loadOrderRequest;

@property (nonatomic, strong) HttpRequestClient *cancelOrderRequest;

@property (nonatomic, strong) HttpRequestClient *refundRequest;

@property (nonatomic, strong) HttpRequestClient *getCodeRequest;

- (void)loadOrderDetailSucceed:(NSDictionary *)data;

- (void)loadOrderDetailFailed:(NSError *)error;

- (void)cancelOrderSucceed:(NSDictionary *)data;

- (void)cancelOrderFailed:(NSError *)error;

- (void)refundSucceed:(NSDictionary *)data;

- (void)refundFailed:(NSError *)error;

- (void)getCodeSucceed:(NSDictionary *)data;

- (void)getCodeFailed:(NSError *)error;

@end

@implementation OrderDetailViewModel


- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (OrderDetailView *)view;
        self.view.dataSource = self;
    }
    return self;
}

#pragma mark OrderDetailViewDataSource & OrderDetailViewDelegate

- (OrderDetailModel *)orderDetailModelForOrderDetailView:(OrderDetailView *)detailView {
    return self.detailModel;
}

#pragma mark Private methods

- (void)loadOrderDetailSucceed:(NSDictionary *)data {
    NSDictionary *orderData = [data objectForKey:@"data"];
    _detailModel = [[OrderDetailModel alloc] initWithRawData:orderData];
    [self.view reloadData];
}

- (void)loadOrderDetailFailed:(NSError *)error {
    
}

- (void)cancelOrderSucceed:(NSDictionary *)data {
    [self startUpdateDataWithSucceed:nil failure:nil];
}

- (void)cancelOrderFailed:(NSError *)error {

}

- (void)refundSucceed:(NSDictionary *)data {
    
}

- (void)refundFailed:(NSError *)error {
    
}

- (void)getCodeSucceed:(NSDictionary *)data {
    
}

- (void)getCodeFailed:(NSError *)error {
    
}


#pragma mark Public methods

- (void)cancelOrder {
    if (!self.cancelOrderRequest) {
        self.cancelOrderRequest = [HttpRequestClient clientWithUrlAliasName:@"ORDER_CANCLE_ORDER"];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObject:self.orderId forKey:@"orderId"];
    __weak OrderDetailViewModel *weakSelf = self;
    [weakSelf.cancelOrderRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf cancelOrderSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf cancelOrderFailed:error];
    }];
}

- (void)refund {
    
}

- (void)getConsumptionCode {
    
}

#pragma mark Super methods

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadOrderRequest) {
        self.loadOrderRequest = [HttpRequestClient clientWithUrlAliasName:@"ORDER_GET_ORDER_DETAIL"];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObject:self.orderId forKey:@"orderId"];
    __weak OrderDetailViewModel *weakSelf = self;
    [weakSelf.loadOrderRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadOrderDetailSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadOrderDetailFailed:error];
    }];
}


- (void)stopUpdateData {
    [self.loadOrderRequest cancel];
}

@end
