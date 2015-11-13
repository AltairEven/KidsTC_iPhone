//
//  HospitalListViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/14/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HospitalListViewModel.h"

#define PageSize (10)

@interface HospitalListViewModel () <HospitalListViewDataSource>

@property (nonatomic, weak) HospitalListView *view;

@property (nonatomic, strong) HttpRequestClient *loadHouseRequest;

@property (nonatomic, strong) NSMutableArray *itemModelsArray;

@property (nonatomic, assign) NSUInteger currentPage;

- (void)loadHospitalListSucceed:(NSDictionary *)data;
- (void)loadHospitalListFailed:(NSError *)error;
- (void)loadMoreHospitalListSucceed:(NSDictionary *)data;
- (void)loadMoreHospitalListFailed:(NSError *)error;

- (void)reloadListViewWithData:(NSDictionary *)data;

@end

@implementation HospitalListViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (HospitalListView *)view;
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
                           [NSNumber numberWithInteger:HospitalLoadType], @"type",
                           [NSNumber numberWithInteger:self.currentPage], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pageCount", nil];
    __weak HospitalListViewModel *weakSelf = self;
    [weakSelf.loadHouseRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadHospitalListSucceed:responseData];
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadHospitalListFailed:error];
        if (failure) {
            failure(error);
        }
    }];
}


- (void)stopUpdateData {
    [self.loadHouseRequest cancel];
    [self.view endLoadMore];
}


#pragma mark HospitalListViewDataSource

- (NSArray *)itemModelsOfHospitalListView:(HospitalListView *)listView {
    return [self resutlItemModels];
}

#pragma mark Private methods

- (void)loadHospitalListSucceed:(NSDictionary *)data {
    [self.itemModelsArray removeAllObjects];
    [self reloadListViewWithData:data];
}

- (void)loadHospitalListFailed:(NSError *)error {
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

- (void)loadMoreHospitalListSucceed:(NSDictionary *)data {
    self.currentPage ++;
    [self reloadListViewWithData:data];
}

- (void)loadMoreHospitalListFailed:(NSError *)error {
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
                HospitalListItemModel *model = [[HospitalListItemModel alloc] initWithRawData:singleEle];
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

- (void)getMoreHospitals {
    if (!self.loadHouseRequest) {
        self.loadHouseRequest = [HttpRequestClient clientWithUrlAliasName:@"WELFARE_GET"];
    }
    [self.loadHouseRequest cancel];
    NSUInteger nextPage = self.currentPage + 1;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:HospitalLoadType], @"type",
                           [NSNumber numberWithInteger:nextPage], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pageCount", nil];
    __weak HospitalListViewModel *weakSelf = self;
    [weakSelf.loadHouseRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadMoreHospitalListSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadMoreHospitalListFailed:error];
    }];
}

@end
