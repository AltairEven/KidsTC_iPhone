//
//  OrderListViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/11/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "OrderListView.h"
#import "OrderListModel.h"

@interface OrderListViewModel : BaseViewModel

@property (nonatomic, assign) OrderListType orderListType;

- (NSArray *)orderModels;

- (void)getMoreOrders;

@end
