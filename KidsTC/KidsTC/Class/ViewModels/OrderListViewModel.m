//
//  OrderListViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/11/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "OrderListViewModel.h"

#define PageSize (10)

@interface OrderListViewModel () <OrderListViewDataSource>

@property (nonatomic, weak) OrderListView *view;

@property (nonatomic, strong) HttpRequestClient *loadOrderRequest;

@property (nonatomic, strong) NSMutableArray *orderArray;

@property (nonatomic, assign) NSUInteger currentPage;

- (void)loadOrderListSucceed:(NSDictionary *)data;
- (void)loadOrderListFailed:(NSError *)error;
- (void)loadMoreOrderListSucceed:(NSDictionary *)data;
- (void)loadMoreOrderListFailed:(NSError *)error;

- (void)reloadListViewWithData:(NSDictionary *)data;

@end

@implementation OrderListViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (OrderListView *)view;
        self.view.dataSource = self;
        self.orderArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadOrderRequest) {
        self.loadOrderRequest = [HttpRequestClient clientWithUrlAliasName:@"ORDER_SEARCH_ORDER"];
    }
    [self.loadOrderRequest cancel];
    self.currentPage = 1;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:self.orderListType], @"type",
                           [NSNumber numberWithInteger:self.currentPage], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pagecount", nil];
    __weak OrderListViewModel *weakSelf = self;
    [weakSelf.loadOrderRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadOrderListSucceed:responseData];
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadOrderListFailed:error];
        if (failure) {
            failure(error);
        }
    }];
}


- (void)stopUpdateData {
    [self.loadOrderRequest cancel];
    [self.view endRefresh];
    [self.view endLoadMore];
}


#pragma mark OrderListViewDataSource

- (NSArray *)orderListModelsForOrderListView:(OrderListView *)listView {
    return self.orderArray;
}

#pragma mark Private methods

- (void)loadOrderListSucceed:(NSDictionary *)data {
    [self.orderArray removeAllObjects];
    [self reloadListViewWithData:data];
}

- (void)loadOrderListFailed:(NSError *)error {
    [self.orderArray removeAllObjects];
    switch (error.code) {
        case -999:
        {
            //cancel
            return;
        }
            break;
        case -2001:
        {
            //没有数据
            [self.view noMoreData:YES];
        }
            break;
        default:
            break;
    }
    [self reloadListViewWithData:nil];
    [self.view endRefresh];
}

- (void)loadMoreOrderListSucceed:(NSDictionary *)data {
    self.currentPage ++;
    [self reloadListViewWithData:data];
}

- (void)loadMoreOrderListFailed:(NSError *)error {
    switch (error.code) {
        case -999:
        {
            //cancel
            return;
        }
            break;
        case -2001:
        {
            //没有数据
            [self.view noMoreData:YES];
        }
            break;
        default:
            break;
    }
    [self.view endLoadMore];
}

- (void)reloadListViewWithData:(NSDictionary *)data {
    if ([data count] > 0) {
        NSArray *dataArray = [data objectForKey:@"data"];
        if ([dataArray isKindOfClass:[NSArray class]] && [dataArray count] > 0) {
            [self.view hideLoadMoreFooter:NO];
            for (NSDictionary *singleOrder in dataArray) {
                OrderListModel *model = [[OrderListModel alloc] initWithRawData:singleOrder];
                if (model) {
                    [self.orderArray addObject:model];
                }
            }
            if ([dataArray count] < PageSize) {
                [self.view noMoreData:YES];
            } else {
                [self.view noMoreData:NO];
            }
        } else {
            [self.view noMoreData:YES];
            [self.view hideLoadMoreFooter:YES];
        }
    } else {
        [self.view hideLoadMoreFooter:YES];
    }
    [self.view reloadData];
    [self stopUpdateData];
}

#pragma mark Public methods

- (NSArray *)orderModels {
    return [NSArray arrayWithArray:self.orderArray];
}

- (void)getMoreOrders {
    if (!self.loadOrderRequest) {
        self.loadOrderRequest = [HttpRequestClient clientWithUrlAliasName:@"ORDER_SEARCH_ORDER"];
    }
    [self.loadOrderRequest cancel];
    NSUInteger nextPage = self.currentPage + 1;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:self.orderListType], @"type",
                           [NSNumber numberWithInteger:nextPage], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pagecount", nil];
    __weak OrderListViewModel *weakSelf = self;
    [weakSelf.loadOrderRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadMoreOrderListSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadMoreOrderListFailed:error];
    }];
}

@end
