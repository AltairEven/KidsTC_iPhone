//
//  OrderDetailView.h
//  KidsTC
//
//  Created by 钱烨 on 7/9/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    OrderDetailActionTagPay = 0,
    OrderDetailActionTagCancel,
    OrderDetailActionTagComment,
    OrderDetailActionTagReturn,
    OrderDetailActionTagGotoService,
    OrderDetailActionTagGetCode
}OrderDetailActionTag;

@class OrderDetailView;
@class OrderDetailModel;

@protocol OrderDetailViewDataSource <NSObject>

- (OrderDetailModel *)orderDetailModelForOrderDetailView:(OrderDetailView *)detailView;

@end

@protocol OrderDetailViewDelegate <NSObject>

- (void)orderDetailView:(OrderDetailView *)detailView executeActionWithTag:(OrderDetailActionTag)tag;

@end

@interface OrderDetailView : UIView

@property (nonatomic, strong) id<OrderDetailViewDataSource> dataSource;
@property (nonatomic, strong) id<OrderDetailViewDelegate> delegate;

- (void)reloadData;

@end
