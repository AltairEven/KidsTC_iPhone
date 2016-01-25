//
//  NewsListViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "NewsListViewModel.h"
#import "NewsTagItemModel.h"

#define PageSize (10)

@interface NewsListViewModel () <NewsListViewDataSource>

@property (nonatomic, weak) NewsListView *view;

@property (nonatomic, strong) HttpRequestClient *loadNewsTagRequest;

@property (nonatomic, strong) HttpRequestClient *loadNewsRequest;

@property (nonatomic, strong) NSMutableDictionary *totalResultsContainer;

@property (nonatomic, strong) NSMutableDictionary *currentPageIndexs;

@property (nonatomic, assign) BOOL gettingNewsTag;

- (void)getNewsTags;

- (void)parseTagsWithData:(NSDictionary *)data;

- (NSMutableArray *)newsResultAtTagIndex:(NSUInteger)index;

- (void)clearDataForTagIndex:(NSUInteger)index;

- (void)loadNewsSucceedWithData:(NSDictionary *)data tagIndex:(NSUInteger)index;

- (void)loadNewsFailedWithError:(NSError *)error tagIndex:(NSUInteger)index;

- (void)loadMoreNewsSucceedWithData:(NSDictionary *)data tagIndex:(NSUInteger)index;

- (void)loadMoreNewsFailedWithError:(NSError *)error tagIndex:(NSUInteger)index;

- (void)reloadNewsListViewWithData:(NSDictionary *)data tagIndex:(NSUInteger)index;

@end

@implementation NewsListViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (NewsListView *)view;
        self.view.dataSource = self;
        self.totalResultsContainer = [[NSMutableDictionary alloc] init];
        self.newsTagItemModels = [[NSMutableArray alloc] init];
        self.currentPageIndexs = [[NSMutableDictionary alloc] init];
        _currentTagType = [NewsTagTypeModel tagTypeFromUserRole:[KTCUser currentUser].userRole];
    }
    return self;
}

#pragma mark NewsListViewDataSource

- (NSArray *)newsTagItemModelsForNewsListView:(NewsListView *)listView {
    return [NSArray arrayWithArray:self.newsTagItemModels];
}

- (NSArray *)newsListItemModelsForNewsListView:(NewsListView *)listView ofNewsTagIndex:(NSUInteger)index {
    return [NSArray arrayWithArray:[self.totalResultsContainer objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)index]]];
}

#pragma mark Private methods

- (void)getNewsTags {
    self.gettingNewsTag = YES;
    if (!self.loadNewsTagRequest) {
        self.loadNewsTagRequest = [HttpRequestClient clientWithUrlAliasName:@"ARTICLE_GET_KNOWLEDGE"];
    }
    [self.loadNewsTagRequest cancel];
    __weak NewsListViewModel *weakSelf = self;
    [weakSelf.loadNewsTagRequest startHttpRequestWithParameter:nil success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf parseTagsWithData:responseData];
        [weakSelf.view reloadNewsTag];
        [weakSelf startUpdateDataWithNewsTagIndex:weakSelf.currentTagIndex];
        weakSelf.gettingNewsTag = NO;
    } failure:^(HttpRequestClient *client, NSError *error) {
        weakSelf.gettingNewsTag = NO;
    }];
}

- (void)parseTagsWithData:(NSDictionary *)data {
    _newsTagTypeModels = nil;
    [self.newsTagItemModels removeAllObjects];
    
    NSArray *array = [data objectForKey:@"data"];
    if ([array isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *singleTypeElem in array) {
            NewsTagTypeModel *typeModel = [[NewsTagTypeModel alloc] initWithRawData:singleTypeElem];
            if (typeModel) {
                [tempArray addObject:typeModel];
            }
        }
        _newsTagTypeModels = [NSArray arrayWithArray:tempArray];
        NSUInteger index = self.currentTagType - 1;
        if ([self.newsTagTypeModels count] > index) {
            NewsTagTypeModel *model = [self.newsTagTypeModels objectAtIndex:index];
            for (NewsTagItemModel *itemModel in model.tagItems) {
                [self.newsTagItemModels addObject:itemModel];
            }
        }
    }
}

- (NSMutableArray *)newsResultAtTagIndex:(NSUInteger)index {
    if ([self.totalResultsContainer count] > 0) {
        NSMutableArray *dataArray = [self.totalResultsContainer objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)index]];
        if (dataArray) {
            return dataArray;
        }
    }
    return nil;
}

- (void)clearDataForTagIndex:(NSUInteger)index {
    NSMutableArray *dataArray = [self newsResultAtTagIndex:index];
    if (dataArray) {
        [dataArray removeAllObjects];
    }
}

- (void)loadNewsSucceedWithData:(NSDictionary *)data tagIndex:(NSUInteger)index {
    [self clearDataForTagIndex:index];
    [self reloadNewsListViewWithData:data tagIndex:index];
}

- (void)loadNewsFailedWithError:(NSError *)error tagIndex:(NSUInteger)index {
    [self.view endRefresh];
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
            [self.view noMoreData:YES forNewsTagIndex:index];
        }
            break;
        default:
            break;
    }
    [self clearDataForTagIndex:index];
    [self reloadNewsListViewWithData:nil tagIndex:index];
}

- (void)loadMoreNewsSucceedWithData:(NSDictionary *)data tagIndex:(NSUInteger)index {
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)index];
    NSUInteger currentIndex = [[self.currentPageIndexs objectForKey:key] integerValue];
    [self.currentPageIndexs setObject:[NSNumber numberWithInteger:currentIndex + 1] forKey:key];
    [self reloadNewsListViewWithData:data tagIndex:index];
    [self.view endLoadMore];
}

- (void)loadMoreNewsFailedWithError:(NSError *)error tagIndex:(NSUInteger)index {
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
            [self.view noMoreData:YES forNewsTagIndex:index];
        }
            break;
        default:
            break;
    }
    [self reloadNewsListViewWithData:nil tagIndex:index];
    [self.view endLoadMore];
}

- (void)reloadNewsListViewWithData:(NSDictionary *)data tagIndex:(NSUInteger)index {
    if ([self.newsTagItemModels count] > 0) {
        NSArray *dataArray = [data objectForKey:@"data"];
        if ([dataArray isKindOfClass:[NSArray class]] && [dataArray count] > 0) {
            [self.view hideLoadMoreFooter:NO forNewsTagIndex:index];
            
            NSMutableArray *tempContainer = [[NSMutableArray alloc] init];
            for (NSDictionary *singleItem in dataArray) {
                NewsListItemModel *model = [[NewsListItemModel alloc] initWithRawData:singleItem];
                if (model) {
                    [tempContainer addObject:model];
                }
            }
            NSMutableArray *resultArray = [self newsResultAtTagIndex:index];
            if (resultArray) {
                [resultArray addObjectsFromArray:tempContainer];
            } else {
                [self.totalResultsContainer setObject:tempContainer forKey:[NSString stringWithFormat:@"%lu", (unsigned long)index]];
            }
            
            if ([dataArray count] < PageSize) {
                [self.view noMoreData:YES forNewsTagIndex:index];
            } else {
                [self.view noMoreData:NO forNewsTagIndex:index];
            }
        } else {
            [self.view noMoreData:YES forNewsTagIndex:index];
            [self.view hideLoadMoreFooter:YES forNewsTagIndex:index];
        }
        if (self.currentTagIndex == index) {
            [self.view reloadData];
            [self.view endRefresh];
            [self.view endLoadMore];
        }
    } else {
        
        [self.view reloadData];
        [self.view endRefresh];
        [self.view endLoadMore];
        [self.view noMoreData:YES forNewsTagIndex:index];
    }
}

#pragma mark Public methods

- (NSArray *)currentResultArray {
    return [NSArray arrayWithArray:[self newsResultAtTagIndex:self.currentTagIndex]];
}

- (void)startUpdateDataWithNewsTagIndex:(NSUInteger)index {
    if (self.gettingNewsTag == YES) {
        return;
    }
    if ([self.newsTagItemModels count] == 0) {
        [self getNewsTags];
        return;
    }
    if (!self.loadNewsRequest) {
        self.loadNewsRequest = [HttpRequestClient clientWithUrlAliasName:@"ARTICLE_GET_LIST"];
    }
    
    NSString *tagId = @"0";
    if ([self.newsTagItemModels count] > index) {
        //已经有数据的情况
        NewsTagItemModel *model = [self.newsTagItemModels objectAtIndex:index];
        tagId = model.identifier;
    }
    
    NSUInteger pageIndex = [[self.currentPageIndexs objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)index]] integerValue];
    if (pageIndex <= 0) {
        pageIndex = 1;
        [self.currentPageIndexs setObject:[NSNumber numberWithInteger:1] forKey:[NSString stringWithFormat:@"%lu", (unsigned long)index]];
    }
    NewsTagItemModel *model = [self.newsTagItemModels objectAtIndex:self.currentTagIndex];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:pageIndex], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pageCount",
                           model.identifier, @"tagId",
                           @"", @"authorId",
                           [NSNumber numberWithInteger:model.type], @"population_type", nil];
    __weak NewsListViewModel *weakSelf = self;
    [weakSelf.loadNewsRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadNewsSucceedWithData:responseData tagIndex:index];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadNewsFailedWithError:error tagIndex:index];
    }];
}

- (void)getMoreDataWithNewsTagIndex:(NSUInteger)index {
    if ([self.newsTagItemModels count] == 0) {
        [self.view noMoreData:YES forNewsTagIndex:index];
        [self.view hideLoadMoreFooter:YES forNewsTagIndex:index];        return;
    }
    if (!self.loadNewsRequest) {
        self.loadNewsRequest = [HttpRequestClient clientWithUrlAliasName:@"ARTICLE_GET_LIST"];
    }
    
    NSString *tagId = @"0";
    NSUInteger type = 0;
    if ([self.newsTagItemModels count] > index) {
        //已经有数据的情况
        NewsTagItemModel *model = [self.newsTagItemModels objectAtIndex:index];
        tagId = model.identifier;
        type = model.type;
    }
    
    NSUInteger pageIndex = [[self.currentPageIndexs objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)index]] integerValue];
    pageIndex ++;
    NewsTagItemModel *model = [self.newsTagItemModels objectAtIndex:self.currentTagIndex];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:pageIndex], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pageCount",
                           model.identifier, @"tagId",
                           @"", @"authorId",
                           [NSNumber numberWithInteger:type], @"population_type", nil];
    __weak NewsListViewModel *weakSelf = self;
    [weakSelf.loadNewsRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadMoreNewsSucceedWithData:responseData tagIndex:index];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadMoreNewsFailedWithError:error tagIndex:index];
    }];
}

- (void)resetResultWithNewsTagIndex:(NSUInteger)index{
    [self.view endRefresh];
    [self.view endLoadMore];
    self.currentTagIndex = index;
    NSMutableArray *dataArray = [self newsResultAtTagIndex:index];
    [self.view reloadData];
    
    if ([dataArray count] == 0) {
        [self.view startRefresh];
    }
}

- (void)setTagItemModel:(NewsTagItemModel *)model {
    _currentTagType = model.type;
    NSUInteger typeIndex = self.currentTagType - 1;
    if ([self.newsTagTypeModels count] > typeIndex) {
        [self.newsTagItemModels removeAllObjects];
        NewsTagTypeModel *model = [self.newsTagTypeModels objectAtIndex:typeIndex];
        for (NewsTagItemModel *itemModel in model.tagItems) {
            [self.newsTagItemModels addObject:itemModel];
        }
        [self.view reloadNewsTag];
    } else {
        return;
    }
    BOOL isExisting = NO;
    NSUInteger index = 0;
    for (; index < [self.newsTagItemModels count]; index ++) {
        NewsTagItemModel *existModel = [self.newsTagItemModels objectAtIndex:index];
        if ([existModel.identifier isEqualToString:model.identifier] && existModel.type == model.type) {
            isExisting = YES;
            break;
        }
    }
    if (isExisting) {
        [self.view selectNewsTagAtIndex:index];
    } else {
        [self.newsTagItemModels addObject:model];
        [self.view reloadNewsTag];
        [self.view selectNewsTagAtIndex:[self.newsTagItemModels count] - 1];
    }
}


#pragma mark Super methods

- (void)stopUpdateData {
    [self.loadNewsTagRequest cancel];
    [self.loadNewsRequest cancel];
    [self.view endRefresh];
    [self.view endLoadMore];
}

@end
