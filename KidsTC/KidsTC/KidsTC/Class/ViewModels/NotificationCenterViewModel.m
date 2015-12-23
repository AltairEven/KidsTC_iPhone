//
//  NotificationCenterViewModel.m
//  KidsTC
//
//  Created by Altair on 11/30/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NotificationCenterViewModel.h"

#define PageSize (10)

@interface NotificationCenterViewModel () <NotificationCenterViewDataSource>

@property (nonatomic, weak) NotificationCenterView *view;

@property (nonatomic, strong) HttpRequestClient *loadNotificationsRequest;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSUInteger currentPageIndex;

- (void)loadNotificationsSucceedWithData:(NSDictionary *)data;

- (void)loadNotificationsFailedWithError:(NSError *)error;

- (void)loadMoreNotificationsSucceedWithData:(NSDictionary *)data;

- (void)loadMoreNotificationsFailedWithError:(NSError *)error;

- (void)reloadNotificationCenterViewWithData:(NSDictionary *)data;

@end

@implementation NotificationCenterViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (NotificationCenterView *)view;
        self.view.dataSource = self;
        self.dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark

- (NSArray<PushNotificationModel *> *)notificationModelsForNotificationCenterView:(NotificationCenterView *)view {
    return [self resultArray];
}

#pragma mark Private methods

- (void)loadNotificationsSucceedWithData:(NSDictionary *)data {
    [self.dataArray removeAllObjects];
    [self reloadNotificationCenterViewWithData:data];
}

- (void)loadNotificationsFailedWithError:(NSError *)error {
    [self.dataArray removeAllObjects];
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
            [self.view noMoreData:YES];
        }
            break;
        default:
            break;
    }
    [self reloadNotificationCenterViewWithData:nil];
    [self.view endRefresh];
}

- (void)loadMoreNotificationsSucceedWithData:(NSDictionary *)data {
    self.currentPageIndex += 1;
    [self reloadNotificationCenterViewWithData:data];
    [self.view endLoadMore];
}

- (void)loadMoreNotificationsFailedWithError:(NSError *)error {
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
            [self.view noMoreData:YES];
        }
            break;
        default:
            break;
    }
    [self reloadNotificationCenterViewWithData:nil];
    [self.view endLoadMore];
}

- (void)reloadNotificationCenterViewWithData:(NSDictionary *)data {
    NSArray *dataArray = [data objectForKey:@"data"];
    if ([dataArray isKindOfClass:[NSArray class]] && [dataArray count] > 0) {
        [self.view hideLoadMoreFooter:NO];
        for (NSDictionary *singleItem in dataArray) {
            PushNotificationModel *model = [[PushNotificationModel alloc] initWithRawData:singleItem];
            if (model) {
                [self.dataArray addObject:model];
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
    [self.view reloadData];
    [self.view endRefresh];
    [self.view endLoadMore];
}

#pragma mark Public methods

- (NSArray *)resultArray {
    return [NSArray arrayWithArray:self.dataArray];
}

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadNotificationsRequest) {
        self.loadNotificationsRequest = [HttpRequestClient clientWithUrlAliasName:@"PUSH_SEARCH_USER_MESSAGE"];
    }
    self.currentPageIndex = 1;
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:self.currentPageIndex], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pageCount", nil];
    
    __weak NotificationCenterViewModel *weakSelf = self;
    [weakSelf.loadNotificationsRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadNotificationsSucceedWithData:responseData];
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadNotificationsFailedWithError:error];
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getMoreDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadNotificationsRequest) {
        self.loadNotificationsRequest = [HttpRequestClient clientWithUrlAliasName:@"PUSH_SEARCH_USER_MESSAGE"];
    }
    
    NSUInteger pageIndex = self.currentPageIndex + 1;
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:pageIndex], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pageCount", nil];
    
    __weak NotificationCenterViewModel *weakSelf = self;
    [weakSelf.loadNotificationsRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadMoreNotificationsSucceedWithData:responseData];
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadMoreNotificationsFailedWithError:error];
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark Super methods

- (void)stopUpdateData {
    [self.loadNotificationsRequest cancel];
    [self.view endRefresh];
    [self.view endLoadMore];
}

@end
