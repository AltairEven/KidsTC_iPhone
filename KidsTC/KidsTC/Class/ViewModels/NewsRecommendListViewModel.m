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

@property (nonatomic, copy) NSString *requestTimeDes;

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
        self.listModels = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)requestTimeDes {
    if (!_requestTimeDes) {
        _requestTimeDes = @"";
    }
    return _requestTimeDes;
}

- (NSArray *)resultListItems {
    return [NSArray arrayWithArray:self.listModels];
}

#pragma mark NewsListViewDataSource

- (NSArray *)newsRecommendListModelsForNewsRecommendListView:(NewsRecommendListView *)listView {
    return [self resultListItems];
}

#pragma mark Private methods

- (void)loadMoreNewsSucceed:(NSDictionary *)data {
    self.requestTimeDes = [data objectForKey:@"time"];
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
        case -3001:
        {
            //没有数据
            [self.view noMoreEarlierData:YES];
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
        [self.view noMoreEarlierData:NO];
        NSMutableArray *tempContainer = [[NSMutableArray alloc] init];
        for (NSDictionary *singleItem in dataArray) {
            NewsRecommendListModel *model = [[NewsRecommendListModel alloc] initWithRawData:singleItem];
            if (model) {
                [tempContainer insertObject:model atIndex:0];
            }
        }
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [tempContainer count])];
        [self.listModels insertObjects:tempContainer atIndexes:indexSet];
    } else {
        //没有更多
        [self.view noMoreEarlierData:YES];
    }
    [self.view reloadData];
    [self.view endLoadMore];
}

#pragma mark Public methods

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if ([self.listModels count] == 0) {
        [self getMoreRecommendNewsWithSucceed:succeed failure:failure];
    } else {
        succeed(nil);
    }
}

- (void)getMoreRecommendNewsWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadNewsRequest) {
        self.loadNewsRequest = [HttpRequestClient clientWithUrlAliasName:@"ARTICLE_GET_RECOMMEND_LIST"];
    }
    [self.loadNewsRequest cancel];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.requestTimeDes, @"time", [[KTCUser currentUser].userRole userRoleIdentifierString], @"population_type", nil];
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
