//
//  MyCommentListViewModel.m
//  KidsTC
//
//  Created by Altair on 12/1/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "MyCommentListViewModel.h"

#define PageSize (10)

@interface MyCommentListViewModel () <MyCommentListViewDataSource>

@property (nonatomic, weak) MyCommentListView *view;

@property (nonatomic, strong) KTCCommentManager *commentManager;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSUInteger currentPageIndex;

- (void)loadNotificationsSucceedWithData:(NSDictionary *)data;

- (void)loadNotificationsFailedWithError:(NSError *)error;

- (void)loadMoreNotificationsSucceedWithData:(NSDictionary *)data;

- (void)loadMoreNotificationsFailedWithError:(NSError *)error;

- (void)reloadActivityViewWithData:(NSDictionary *)data;

@end

@implementation MyCommentListViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (MyCommentListView *)view;
        self.view.dataSource = self;
        self.dataArray = [[NSMutableArray alloc] init];
        self.commentManager = [[KTCCommentManager alloc] init];
    }
    return self;
}

#pragma mark

- (NSArray<MyCommentListItemModel *> *)itemModelsForCommentListView:(MyCommentListView *)view {
    return [self resultArray];
}

#pragma mark Private methods

- (void)loadNotificationsSucceedWithData:(NSDictionary *)data {
    [self.dataArray removeAllObjects];
    [self reloadActivityViewWithData:data];
}

- (void)loadNotificationsFailedWithError:(NSError *)error {
    self.currentPageIndex = 0;
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
    [self reloadActivityViewWithData:nil];
    [self.view endRefresh];
}

- (void)loadMoreNotificationsSucceedWithData:(NSDictionary *)data {
    self.currentPageIndex += 1;
    [self reloadActivityViewWithData:data];
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
    [self reloadActivityViewWithData:nil];
    [self.view endLoadMore];
}

- (void)reloadActivityViewWithData:(NSDictionary *)data {
    NSArray *dataArray = [data objectForKey:@"data"];
    if ([dataArray isKindOfClass:[NSArray class]] && [dataArray count] > 0) {
        [self.view hideLoadMoreFooter:NO];
        for (NSDictionary *singleItem in dataArray) {
            MyCommentListItemModel *model = [[MyCommentListItemModel alloc] initWithRawData:singleItem];
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
    
    self.currentPageIndex = 1;
    __weak MyCommentListViewModel *weakSelf = self;
    [weakSelf.commentManager loadUserCommentsWithPageIndex:weakSelf.currentPageIndex pageSize:PageSize succeed:^(NSDictionary *data) {
        [weakSelf loadNotificationsSucceedWithData:data];
        if (succeed) {
            succeed(data);
        }
    } failure:^(NSError *error) {
        [weakSelf loadNotificationsFailedWithError:error];
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getMoreDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    NSUInteger pageIndex = self.currentPageIndex + 1;
    __weak MyCommentListViewModel *weakSelf = self;
    [weakSelf.commentManager loadUserCommentsWithPageIndex:pageIndex pageSize:PageSize succeed:^(NSDictionary *data) {
        [weakSelf loadMoreNotificationsSucceedWithData:data];
        if (succeed) {
            succeed(data);
        }
    } failure:^(NSError *error) {
        [weakSelf loadMoreNotificationsFailedWithError:error];
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark Super methods

- (void)stopUpdateData {
    [self.commentManager stopLoadingUserComments];
    [self.view endRefresh];
    [self.view endLoadMore];
}

@end
