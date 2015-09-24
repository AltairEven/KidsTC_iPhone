//
//  AppointmentOrderListViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/12/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AppointmentOrderListViewModel.h"

#define PageSize (10)

@interface AppointmentOrderListViewModel () <AppointmentOrderListViewDataSource>

@property (nonatomic, weak) AppointmentOrderListView *view;

@property (nonatomic, strong) NSMutableArray *allResultArray;

@property (nonatomic, strong) NSMutableArray *waitingUseResultArray;

@property (nonatomic, strong) NSMutableArray *waitingCommentResultArray;

@property (nonatomic, strong) NSMutableArray *overDataResultArray;

@property (nonatomic, strong) HttpRequestClient *loadOrderListRequest;

@property (nonatomic, assign) AppointmentOrderListStatus currentListStatus;

@property (nonatomic, assign) NSUInteger currentAllPage;

@property (nonatomic, assign) NSUInteger currentWaitingUsePage;

@property (nonatomic, assign) NSUInteger currentWaitingCommentPage;

@property (nonatomic, assign) NSUInteger currentOverDatePage;

- (void)clearDataForOrderListStatus:(AppointmentOrderListStatus)status;

- (void)loadOrderSucceedWithData:(NSDictionary *)data orderListStatus:(AppointmentOrderListStatus)status;

- (void)loadOrderFailedWithError:(NSError *)error orderListStatus:(AppointmentOrderListStatus)status;

- (void)loadMoreOrderSucceedWithData:(NSDictionary *)data orderListStatus:(AppointmentOrderListStatus)status;

- (void)loadMoreOrderFailedWithError:(NSError *)error orderListStatus:(AppointmentOrderListStatus)status;

- (void)reloadOrderViewWithData:(NSDictionary *)data fororderListStatus:(AppointmentOrderListStatus)status;

@end

@implementation AppointmentOrderListViewModel


- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (AppointmentOrderListView *)view;
        self.view.dataSource = self;
        self.currentListStatus = AppointmentOrderListStatusAll;
        self.currentAllPage = 1;
        self.currentWaitingUsePage = 1;
        self.currentWaitingCommentPage = 1;
        self.currentOverDatePage = 1;
        [self.view hideLoadMoreFooter:YES forListStatus:AppointmentOrderListStatusAll];
        [self.view hideLoadMoreFooter:YES forListStatus:AppointmentOrderListStatusWaitingUse];
        [self.view hideLoadMoreFooter:YES forListStatus:AppointmentOrderListStatusWaitingComment];
        [self.view hideLoadMoreFooter:YES forListStatus:AppointmentOrderListStatusHasOverDate];
        self.allResultArray = [[NSMutableArray alloc] init];
        self.waitingUseResultArray = [[NSMutableArray alloc] init];
        self.waitingCommentResultArray = [[NSMutableArray alloc] init];
        self.overDataResultArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark AppointmentOrderListViewDataSource

- (NSArray *)orderModelsForOrderListView:(AppointmentOrderListView *)listView forListStatus:(AppointmentOrderListStatus)status {
    NSArray *retArray = nil;
    switch (status) {
        case AppointmentOrderListStatusAll:
        {
            retArray = [NSArray arrayWithArray:self.allResultArray];
        }
            break;
        case AppointmentOrderListStatusWaitingUse:
        {
            retArray = [NSArray arrayWithArray:self.waitingUseResultArray];
        }
            break;
        case AppointmentOrderListStatusWaitingComment:
        {
            retArray = [NSArray arrayWithArray:self.waitingCommentResultArray];
        }
            break;
        case AppointmentOrderListStatusHasOverDate:
        {
            retArray = [NSArray arrayWithArray:self.overDataResultArray];
        }
            break;
        default:
            break;
    }
    return retArray;
}

#pragma mark Private methods

- (void)clearDataForOrderListStatus:(AppointmentOrderListStatus)status {
    switch (status) {
        case AppointmentOrderListStatusAll:
        {
            [self.allResultArray removeAllObjects];
        }
            break;
        case AppointmentOrderListStatusWaitingUse:
        {
            [self.waitingUseResultArray removeAllObjects];
        }
            break;
        case AppointmentOrderListStatusWaitingComment:
        {
            [self.waitingCommentResultArray removeAllObjects];
        }
            break;
        case AppointmentOrderListStatusHasOverDate:
        {
            [self.overDataResultArray removeAllObjects];
        }
            break;
        default:
            break;
    }
}

- (void)loadOrderSucceedWithData:(NSDictionary *)data orderListStatus:(AppointmentOrderListStatus)status {
    [self clearDataForOrderListStatus:status];
    [self reloadOrderViewWithData:data fororderListStatus:status];
}

- (void)loadOrderFailedWithError:(NSError *)error orderListStatus:(AppointmentOrderListStatus)status {
    [self clearDataForOrderListStatus:status];
    switch (error.code) {
        case -999:
        {
            //cancel
            return;
        }
            break;
        case -1003:
        {
            //没有数据
            [self.view noMoreData:YES forListStatus:status];
        }
            break;
        default:
            break;
    }
    [self reloadOrderViewWithData:nil fororderListStatus:status];
    [self.view endRefresh];
}

- (void)loadMoreOrderSucceedWithData:(NSDictionary *)data orderListStatus:(AppointmentOrderListStatus)status {
    switch (status) {
        case AppointmentOrderListStatusAll:
        {
            self.currentAllPage ++;
        }
            break;
        case AppointmentOrderListStatusWaitingUse:
        {
            self.currentWaitingUsePage ++;
        }
            break;
        case AppointmentOrderListStatusWaitingComment:
        {
            self.currentWaitingCommentPage ++;
        }
            break;
        case AppointmentOrderListStatusHasOverDate:
        {
            self.currentOverDatePage ++;
        }
            break;
        default:
            break;
    }
    [self reloadOrderViewWithData:data fororderListStatus:status];
    [self.view endLoadMore];
}

- (void)loadMoreOrderFailedWithError:(NSError *)error orderListStatus:(AppointmentOrderListStatus)status {
    switch (error.code) {
        case -999:
        {
            //cancel
            return;
        }
            break;
        case -1003:
        {
            //没有数据
            [self.view noMoreData:YES forListStatus:status];
        }
            break;
        default:
            break;
    }
    [self reloadOrderViewWithData:nil fororderListStatus:status];
    [self.view endLoadMore];
}

- (void)reloadOrderViewWithData:(NSDictionary *)data fororderListStatus:(AppointmentOrderListStatus)status {
    NSArray *dataArray = [data objectForKey:@"data"];
    if ([dataArray isKindOfClass:[NSArray class]] && [dataArray count] > 0) {
        [self.view hideLoadMoreFooter:NO forListStatus:status];
        for (NSDictionary *singleOrder in dataArray) {
            AppointmentOrderModel *model = [[AppointmentOrderModel alloc] initWithRawData:singleOrder];
            if (model) {
                switch (status) {
                    case AppointmentOrderListStatusAll:
                    {
                        [self.allResultArray addObject:model];
                    }
                        break;
                    case AppointmentOrderListStatusWaitingUse:
                    {
                        [self.waitingUseResultArray addObject:model];
                    }
                        break;
                    case AppointmentOrderListStatusWaitingComment:
                    {
                        [self.waitingCommentResultArray addObject:model];
                    }
                        break;
                    case AppointmentOrderListStatusHasOverDate:
                    {
                        [self.overDataResultArray addObject:model];
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        if ([dataArray count] < PageSize) {
            [self.view noMoreData:YES forListStatus:status];
        } else {
            [self.view noMoreData:NO forListStatus:status];
        }
    } else {
        [self.view noMoreData:YES forListStatus:status];
        [self.view hideLoadMoreFooter:YES forListStatus:status];
    }
    [self.view reloadDataforListStatus:status];
    [self.view endRefresh];
    [self.view endLoadMore];
}

#pragma mark Public methods

- (NSArray *)currentResultArray {
    NSArray *array = nil;
    switch (self.currentListStatus) {
        case AppointmentOrderListStatusAll:
        {
            array = [NSArray arrayWithArray:self.allResultArray];
        }
            break;
        case AppointmentOrderListStatusWaitingUse:
        {
            array = [NSArray arrayWithArray:self.waitingUseResultArray];
        }
            break;
        case AppointmentOrderListStatusWaitingComment:
        {
            array = [NSArray arrayWithArray:self.waitingCommentResultArray];
        }
            break;
        case AppointmentOrderListStatusHasOverDate:
        {
            array = [NSArray arrayWithArray:self.overDataResultArray];
        }
            break;
        default:
            break;
    }
    return array;
}

- (void)startUpdateDataWithOrderListStatus:(AppointmentOrderListStatus)status {
    NSDictionary *param = nil;
    switch (status) {
        case AppointmentOrderListStatusAll:
        {
            self.currentAllPage = 1;
            param = [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSNumber numberWithInteger:AppointmentOrderListStatusAll], @"status",
                     [NSNumber numberWithInteger:self.currentAllPage], @"page",
                     [NSNumber numberWithInteger:PageSize], @"pagecount", nil];
        }
            break;
        case AppointmentOrderListStatusWaitingUse:
        {
            self.currentWaitingUsePage = 1;
            param = [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSNumber numberWithInteger:AppointmentOrderListStatusWaitingUse], @"status",
                     [NSNumber numberWithInteger:self.currentWaitingUsePage], @"page",
                     [NSNumber numberWithInteger:PageSize], @"pagecount",
                     @"100,100", @"mapaddr", nil];
        }
            break;
        case AppointmentOrderListStatusWaitingComment:
        {
            self.currentWaitingCommentPage = 1;
            param = [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSNumber numberWithInteger:AppointmentOrderListStatusWaitingComment], @"status",
                     [NSNumber numberWithInteger:self.currentWaitingCommentPage], @"page",
                     [NSNumber numberWithInteger:PageSize], @"pagecount", nil];
        }
            break;
        case AppointmentOrderListStatusHasOverDate:
        {
            self.currentOverDatePage = 1;
            param = [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSNumber numberWithInteger:AppointmentOrderListStatusHasOverDate], @"status",
                     [NSNumber numberWithInteger:self.currentOverDatePage], @"page",
                     [NSNumber numberWithInteger:PageSize], @"pagecount", nil];
        }
            break;
        default:
            break;
    }
    if (!self.loadOrderListRequest) {
        self.loadOrderListRequest = [HttpRequestClient clientWithUrlAliasName:@"ORDER_SEARCH_APPOINTMENTORDER"];
    }
    [self.loadOrderListRequest cancel];
    __weak AppointmentOrderListViewModel *weakSelf = self;
    [weakSelf.loadOrderListRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadOrderSucceedWithData:responseData orderListStatus:status];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadOrderFailedWithError:error orderListStatus:status];
    }];
}

- (void)getMoreDataWithOrderListStatus:(AppointmentOrderListStatus)status {
    NSDictionary *param = nil;
    switch (status) {
        case AppointmentOrderListStatusAll:
        {
            NSUInteger nextPage = self.currentAllPage + 1;
            param = [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSNumber numberWithInteger:AppointmentOrderListStatusAll], @"status",
                     [NSNumber numberWithInteger:nextPage], @"page",
                     [NSNumber numberWithInteger:PageSize], @"pagecount", nil];
        }
            break;
        case AppointmentOrderListStatusWaitingUse:
        {
            NSUInteger nextPage = self.currentWaitingUsePage + 1;
            param = [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSNumber numberWithInteger:AppointmentOrderListStatusWaitingUse], @"status",
                     [NSNumber numberWithInteger:nextPage], @"page",
                     [NSNumber numberWithInteger:PageSize], @"pagecount", nil];
        }
            break;
        case AppointmentOrderListStatusWaitingComment:
        {
            NSUInteger nextPage = self.currentWaitingCommentPage + 1;
            param = [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSNumber numberWithInteger:AppointmentOrderListStatusWaitingComment], @"status",
                     [NSNumber numberWithInteger:nextPage], @"page",
                     [NSNumber numberWithInteger:PageSize], @"pagecount", nil];
        }
            break;
        case AppointmentOrderListStatusHasOverDate:
        {
            NSUInteger nextPage = self.currentOverDatePage + 1;
            param = [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSNumber numberWithInteger:AppointmentOrderListStatusHasOverDate], @"status",
                     [NSNumber numberWithInteger:nextPage], @"page",
                     [NSNumber numberWithInteger:PageSize], @"pagecount", nil];
        }
            break;
        default:
            break;
    }
    if (!self.loadOrderListRequest) {
        self.loadOrderListRequest = [HttpRequestClient clientWithUrlAliasName:@"ORDER_SEARCH_APPOINTMENTORDER"];
    }
    [self.loadOrderListRequest cancel];
    __weak AppointmentOrderListViewModel *weakSelf = self;
    [weakSelf.loadOrderListRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadMoreOrderSucceedWithData:responseData orderListStatus:status];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadMoreOrderFailedWithError:error orderListStatus:status];
    }];
}

- (void)resetResultWithOrderListStatus:(AppointmentOrderListStatus)status {
    self.currentListStatus = status;
    [self stopUpdateData];
    switch (status) {
        case AppointmentOrderListStatusAll:
        {
            if ([self.allResultArray count] > 0) {
                [self.view reloadDataforListStatus:status];
            } else {
                [self startUpdateDataWithOrderListStatus:status];
            }
        }
            break;
        case AppointmentOrderListStatusWaitingUse:
        {
            if ([self.waitingUseResultArray count] > 0) {
                [self.view reloadDataforListStatus:status];
            } else {
                [self startUpdateDataWithOrderListStatus:status];
            }
        }
            break;
        case AppointmentOrderListStatusWaitingComment:
        {
            if ([self.waitingCommentResultArray count] > 0) {
                [self.view reloadDataforListStatus:status];
            } else {
                [self startUpdateDataWithOrderListStatus:status];
            }
        }
            break;
        case AppointmentOrderListStatusHasOverDate:
        {
            if ([self.overDataResultArray count] > 0) {
                [self.view reloadDataforListStatus:status];
            } else {
                [self startUpdateDataWithOrderListStatus:status];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark Super methods

- (void)stopUpdateData {
    [self.loadOrderListRequest cancel];
    [self.view endRefresh];
    [self.view endLoadMore];
}

@end
