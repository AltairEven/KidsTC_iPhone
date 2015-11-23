//
//  LoveHouseListViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/13/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "LoveHouseListViewModel.h"

#define PageSize (10)

@interface LoveHouseListViewModel () <LoveHouseListViewDataSource>

@property (nonatomic, weak) LoveHouseListView *view;

@property (nonatomic, strong) HttpRequestClient *loadHouseRequest;

@property (nonatomic, strong) NSMutableArray *itemModelsArray;

@property (nonatomic, assign) NSUInteger currentPage;

- (void)loadHouseListSucceed:(NSDictionary *)data;
- (void)loadHouseListFailed:(NSError *)error;
- (void)loadMoreHouseListSucceed:(NSDictionary *)data;
- (void)loadMoreHouseListFailed:(NSError *)error;

- (void)reloadListViewWithData:(NSDictionary *)data;

@end

@implementation LoveHouseListViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (LoveHouseListView *)view;
        self.view.dataSource = self;
        self.itemModelsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadHouseRequest) {
        self.loadHouseRequest = [HttpRequestClient clientWithUrlAliasName:@"WELFARE_GET"];
    }
    [self.loadHouseRequest cancel];
    self.currentPage = 1;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:LoveHouseLoadType], @"type",
                           [NSNumber numberWithInteger:self.currentPage], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pageCount",
                           [[GConfig sharedConfig] currentLocationCoordinateString], @"mapAddr", nil];
    __weak LoveHouseListViewModel *weakSelf = self;
    [weakSelf.loadHouseRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadHouseListSucceed:responseData];
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadHouseListFailed:error];
        if (failure) {
            failure(error);
        }
    }];
}


- (void)stopUpdateData {
    [self.loadHouseRequest cancel];
    [self.view endLoadMore];
}


#pragma mark HouseListViewDataSource

- (NSArray *)itemModelsOfLoveHouseListView:(LoveHouseListView *)listView {
    return [self resutlItemModels];
}

#pragma mark Private methods

- (void)loadHouseListSucceed:(NSDictionary *)data {
    [self.itemModelsArray removeAllObjects];
    [self reloadListViewWithData:data];
}

- (void)loadHouseListFailed:(NSError *)error {
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
}

- (void)loadMoreHouseListSucceed:(NSDictionary *)data {
    self.currentPage ++;
    [self reloadListViewWithData:data];
}

- (void)loadMoreHouseListFailed:(NSError *)error {
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
            for (NSDictionary *singleEle in dataArray) {
                LoveHouseListItemModel *model = [[LoveHouseListItemModel alloc] initWithRawData:singleEle];
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

- (NSArray *)resutlItemModels {
    return [NSArray arrayWithArray:self.itemModelsArray];
}

- (void)getMoreHouses {
    if (!self.loadHouseRequest) {
        self.loadHouseRequest = [HttpRequestClient clientWithUrlAliasName:@"WELFARE_GET"];
    }
    [self.loadHouseRequest cancel];
    NSUInteger nextPage = self.currentPage + 1;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:LoveHouseLoadType], @"type",
                           [NSNumber numberWithInteger:nextPage], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pageCount",
                           [[GConfig sharedConfig] currentLocationCoordinateString], @"mapAddr", nil];
    __weak LoveHouseListViewModel *weakSelf = self;
    [weakSelf.loadHouseRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadMoreHouseListSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadMoreHouseListFailed:error];
    }];
}

@end
