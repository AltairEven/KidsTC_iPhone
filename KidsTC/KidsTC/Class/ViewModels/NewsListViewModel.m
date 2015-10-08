//
//  NewsListViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "NewsListViewModel.h"

@interface NewsListViewModel () <NewsListViewDataSource>

@property (nonatomic, weak) NewsListView *view;

@property (nonatomic, strong) HttpRequestClient *loadNewsRequest;

@property (nonatomic, strong) NSMutableArray *listModels;

@property (nonatomic, assign) NSUInteger currentPage;

- (void)loadNewsSucceed:(NSDictionary *)data;

- (void)loadNewsFailed:(NSError *)error;

- (void)loadMoreNewsSucceed:(NSDictionary *)data;

- (void)loadMoreNewsFailed:(NSError *)error;

- (void)reloadListViewWithData:(NSDictionary *)data;

@end

@implementation NewsListViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (NewsListView *)view;
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

- (NSArray *)newsListItemModelsForNewsListView:(NewsListView *)listView {
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
            [self.view noMoreLoad];
        }
            break;
        default:
            break;
    }
    [self reloadListViewWithData:nil];
    [self.view endRefresh];
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
            [self.view noMoreLoad];
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
        [self.view hideLoadMoreFooter:NO];
        
        NSMutableArray *tempContainer = [[NSMutableArray alloc] init];
        for (NSDictionary *singleItem in dataArray) {
            NewsListItemModel *model = [[NewsListItemModel alloc] initWithRawData:singleItem];
            if (model) {
                [tempContainer addObject:model];
            }
        }
        [self.listModels addObjectsFromArray:tempContainer];
        
        if ([dataArray count] < [self.view pageSize]) {
            [self.view noMoreLoad];
        }
    } else {
        [self.view noMoreLoad];
        [self.view hideLoadMoreFooter:YES];
    }
    [self.view reloadData];
    [self.view endRefresh];
    [self.view endLoadMore];
}

#pragma mark Public methods

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (YES) {
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"资讯" ofType:@".txt"]];
        NSError *error = nil;
        NSDictionary *respData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        [self loadNewsSucceed:respData];
        return;
    }
    if (!self.loadNewsRequest) {
        self.loadNewsRequest = [HttpRequestClient clientWithUrlAliasName:@"SEARCH_ARTICLE"];
    }
    [self.loadNewsRequest cancel];
    self.currentPage = 1;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:self.currentPage], @"page",
                           [NSNumber numberWithInteger:[self.view pageSize]], @"pagecount", nil];
    __weak NewsListViewModel *weakSelf = self;
    [weakSelf.loadNewsRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadNewsSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadNewsFailed:error];
    }];
}

- (void)getMoreNewsWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadNewsRequest) {
        self.loadNewsRequest = [HttpRequestClient clientWithUrlAliasName:@"SEARCH_ARTICLE"];
    }
    [self.loadNewsRequest cancel];
    NSUInteger nextPage = self.currentPage + 1;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:nextPage], @"page",
                           [NSNumber numberWithInteger:[self.view pageSize]], @"pagecount", nil];
    __weak NewsListViewModel *weakSelf = self;
    [weakSelf.loadNewsRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadMoreNewsSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadMoreNewsFailed:error];
    }];
}

- (void)stopUpdateData {
    [self.loadNewsRequest cancel];
    [self.view endRefresh];
    [self.view endLoadMore];
}


@end
