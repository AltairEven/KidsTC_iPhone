//
//  NewsRecommendListViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 9/24/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsRecommendListViewModel.h"

@interface NewsRecommendListViewModel () <NewsRecommendListViewDataSource>

@property (nonatomic, weak) NewsRecommendListView *view;

@property (nonatomic, strong) HttpRequestClient *loadNewsRequest;

@property (nonatomic, strong) NSMutableArray *listModels;

@property (nonatomic, assign) NSUInteger currentPage;

- (void)loadNewsSucceed:(NSDictionary *)data;

- (void)loadNewsFailed:(NSError *)error;

- (void)loadMoreNewsSucceed:(NSDictionary *)data;

- (void)loadMoreNewsFailed:(NSError *)error;

- (void)reloadListViewWithData:(NSDictionary *)data;

@end

@implementation NewsRecommendListViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (NewsRecommendListView *)view;
        self.view.dataSource = self;
        self.currentPage = 1;
        self.listModels = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)resultListItems {
    return [NSArray arrayWithArray:self.listModels];
}

#pragma mark NewsListViewDataSource

- (NSArray *)newsRecommendListModelsForNewsRecommendListView:(NewsRecommendListView *)listView {
    return [self resultListItems];
}

#pragma mark Private methods

- (void)loadNewsSucceed:(NSDictionary *)data {
    [self.listModels removeAllObjects];
    [self reloadListViewWithData:data];
}

- (void)loadNewsFailed:(NSError *)error {
    [self.listModels removeAllObjects];
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
        }
            break;
        default:
            break;
    }
    [self reloadListViewWithData:nil];
    [self.view endLoadMore];
}

- (void)loadMoreNewsSucceed:(NSDictionary *)data {
    self.currentPage ++;
    [self reloadListViewWithData:data];
    [self.view endLoadMore];
}

- (void)loadMoreNewsFailed:(NSError *)error {
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
        }
            break;
        default:
            break;
    }
    [self reloadListViewWithData:nil];
    [self.view endLoadMore];
}

- (void)reloadListViewWithData:(NSDictionary *)data {
    NSArray *dataArray = [data objectForKey:@"data"];
    if ([dataArray isKindOfClass:[NSArray class]] && [dataArray count] > 0) {
        NSMutableArray *tempContainer = [[NSMutableArray alloc] init];
        for (NSDictionary *singleItem in dataArray) {
            NewsRecommendListModel *model = [[NewsRecommendListModel alloc] initWithRawData:singleItem];
            if (model) {
                [tempContainer addObject:model];
            }
        }
        [self.listModels addObjectsFromArray:tempContainer];
        
        if ([dataArray count] < [self.view pageSize]) {
            //没有更多
        }
    } else {
        //没有更多
    }
    [self.view reloadData];
    [self.view endLoadMore];
}

#pragma mark Public methods

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadNewsRequest) {
        self.loadNewsRequest = [HttpRequestClient clientWithUrlAliasName:@"SEARCH_ARTICLE"];
    }
    [self.loadNewsRequest cancel];
    self.currentPage = 1;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:self.currentPage], @"page",
                           [NSNumber numberWithInteger:[self.view pageSize]], @"pagecount", nil];
    __weak NewsRecommendListViewModel *weakSelf = self;
    [weakSelf.loadNewsRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadNewsSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadNewsFailed:error];
    }];
}

- (void)getMoreRecommendNewsWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadNewsRequest) {
        self.loadNewsRequest = [HttpRequestClient clientWithUrlAliasName:@"SEARCH_ARTICLE"];
    }
    [self.loadNewsRequest cancel];
    NSUInteger nextPage = self.currentPage + 1;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:nextPage], @"page",
                           [NSNumber numberWithInteger:[self.view pageSize]], @"pagecount", nil];
    __weak NewsRecommendListViewModel *weakSelf = self;
    [weakSelf.loadNewsRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadMoreNewsSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadMoreNewsFailed:error];
    }];
}

- (void)stopUpdateData {
    [self.loadNewsRequest cancel];
    [self.view endLoadMore];
}

@end
