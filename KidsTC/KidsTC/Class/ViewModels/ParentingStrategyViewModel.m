//
//  ParentingStrategyViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/24/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ParentingStrategyViewModel.h"

#define PageSize (10)

@interface ParentingStrategyViewModel () <ParentingStrategyViewDataSource>

@property (nonatomic, weak) ParentingStrategyView *view;

@property (nonatomic, strong) HttpRequestClient *loadStrategriesRequest;

@property (nonatomic, strong) NSMutableArray *itemModelsArray;

@property (nonatomic, assign) NSUInteger currentPage;

- (void)loadStrategyListSucceed:(NSDictionary *)data;
- (void)loadStrategyListFailed:(NSError *)error;
- (void)loadMoreStrategyListSucceed:(NSDictionary *)data;
- (void)loadMoreStrategyListFailed:(NSError *)error;

- (void)reloadListViewWithData:(NSDictionary *)data;

@end

@implementation ParentingStrategyViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (ParentingStrategyView *)view;
        self.view.dataSource = self;
        self.itemModelsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadStrategriesRequest) {
        self.loadStrategriesRequest = [HttpRequestClient clientWithUrlAliasName:@"STRATEGY_SEARCH"];
    }
    [self.loadStrategriesRequest cancel];
    self.currentPage = 1;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:self.currentPage], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pageCount",
                           [NSNumber numberWithInteger:self.currentSortType], @"orderByType", nil];
    __weak ParentingStrategyViewModel *weakSelf = self;
    [weakSelf.loadStrategriesRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadStrategyListSucceed:responseData];
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadStrategyListFailed:error];
        if (failure) {
            failure(error);
        }
    }];
}


- (void)stopUpdateData {
    [self.loadStrategriesRequest cancel];
    [self.view endRefresh];
    [self.view endLoadMore];
}


#pragma mark StrategyListViewDataSource

- (NSArray *)listItemModelsOfParentingStrategyView:(ParentingStrategyView *)strategyView {
    return [self resutlStrategies];
}

#pragma mark Private methods

- (void)loadStrategyListSucceed:(NSDictionary *)data {
    [self.itemModelsArray removeAllObjects];
    [self reloadListViewWithData:data];
}

- (void)loadStrategyListFailed:(NSError *)error {
    [self.itemModelsArray removeAllObjects];
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

- (void)loadMoreStrategyListSucceed:(NSDictionary *)data {
    self.currentPage ++;
    [self reloadListViewWithData:data];
}

- (void)loadMoreStrategyListFailed:(NSError *)error {
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
            for (NSDictionary *singleStrategy in dataArray) {
                ParentingStrategyListItemModel *model = [[ParentingStrategyListItemModel alloc] initWithRawData:singleStrategy];
                if (model) {
                    [self.itemModelsArray addObject:model];
                }
            }
            if ([dataArray count] < PageSize) {
                [self.view noMoreData:YES];
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

- (NSArray *)resutlStrategies {
    return [NSArray arrayWithArray:self.itemModelsArray];
}

- (void)getMoreStrategies {
    if (!self.loadStrategriesRequest) {
        self.loadStrategriesRequest = [HttpRequestClient clientWithUrlAliasName:@"STRATEGY_SEARCH"];
    }
    [self.loadStrategriesRequest cancel];
    NSUInteger nextPage = self.currentPage + 1;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:self.currentSortType], @"orderByType",
                           [NSNumber numberWithInteger:nextPage], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pagecount", nil];
    __weak ParentingStrategyViewModel *weakSelf = self;
    [weakSelf.loadStrategriesRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadMoreStrategyListSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadMoreStrategyListFailed:error];
    }];
}

@end
