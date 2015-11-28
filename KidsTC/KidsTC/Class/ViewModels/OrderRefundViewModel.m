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

#pragma mark Super methods

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    [self.view reloadData];
}

- (void)stopUpdateData {
    
}

@end
