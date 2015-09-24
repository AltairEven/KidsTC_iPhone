//
//  FavourateViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/10/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "FavourateViewModel.h"
#import "KTCFavouriteManager.h"

@interface FavourateViewModel () <FavourateViewDataSource>

@property (nonatomic, weak) FavourateView *view;

@property (nonatomic, strong) NSMutableArray *serviceResultArray;

@property (nonatomic, strong) NSMutableArray *storeResultArray;

@property (nonatomic, strong) NSMutableArray *strategyResultArray;

@property (nonatomic, strong) NSMutableArray *newsResultArray;

@property (nonatomic, assign) FavourateViewSegmentTag currentTag;

@property (nonatomic, assign) NSUInteger currentServicePage;

@property (nonatomic, assign) NSUInteger currentStorePage;

@property (nonatomic, assign) NSUInteger currentStrategyPage;

@property (nonatomic, assign) NSUInteger currentNewsPage;

- (void)clearDataForTag:(FavourateViewSegmentTag)tag;

- (void)loadFavourateSucceedWithData:(NSDictionary *)data segmmentTag:(FavourateViewSegmentTag)tag;

- (void)loadFavourateFailedWithError:(NSError *)error segmmentTag:(FavourateViewSegmentTag)tag;

- (void)loadMoreFavourateSucceedWithData:(NSDictionary *)data segmmentTag:(FavourateViewSegmentTag)tag;

- (void)loadMoreFavourateFailedWithError:(NSError *)error segmmentTag:(FavourateViewSegmentTag)tag;

- (void)deleteFavourateSucceedAtIndex:(NSUInteger)index forSegmmentTag:(FavourateViewSegmentTag)tag;

- (void)deleteFavourateFailedWithError:(NSError *)error atIndex:(NSUInteger)index forSegmmentTag:(FavourateViewSegmentTag)tag;

- (void)reloadFavourateViewWithData:(NSDictionary *)data forSegmmentTag:(FavourateViewSegmentTag)tag;

@end

@implementation FavourateViewModel


- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (FavourateView *)view;
        self.view.dataSource = self;
        self.currentTag = KTCSearchTypeService;
        self.currentServicePage = 1;
        self.currentStorePage = 1;
        self.currentStrategyPage = 1;
        self.currentNewsPage = 1;
        [self.view hideLoadMoreFooter:YES ForTag:FavourateViewSegmentTagService];
        [self.view hideLoadMoreFooter:YES ForTag:FavourateViewSegmentTagStore];
        [self.view hideLoadMoreFooter:YES ForTag:FavourateViewSegmentTagStrategy];
        [self.view hideLoadMoreFooter:YES ForTag:FavourateViewSegmentTagNews];
        self.serviceResultArray = [[NSMutableArray alloc] init];
        self.storeResultArray = [[NSMutableArray alloc] init];
        self.strategyResultArray = [[NSMutableArray alloc] init];
        self.newsResultArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark FavourateViewDataSource

- (NSArray *)favourateView:(FavourateView *)favourateView itemModelsForSegmentTag:(FavourateViewSegmentTag)tag {
    NSArray *retArray = nil;
    switch (tag) {
        case FavourateViewSegmentTagService:
        {
            retArray = [NSArray arrayWithArray:self.serviceResultArray];
        }
            break;
        case FavourateViewSegmentTagStore:
        {
            retArray = [NSArray arrayWithArray:self.storeResultArray];
        }
            break;
        case FavourateViewSegmentTagStrategy:
        {
            retArray = [NSArray arrayWithArray:self.strategyResultArray];
        }
            break;
        case FavourateViewSegmentTagNews:
        {
            retArray = [NSArray arrayWithArray:self.newsResultArray];
        }
            break;
        default:
            break;
    }
    return retArray;
}

#pragma mark Private methods

- (void)clearDataForTag:(FavourateViewSegmentTag)tag {
    switch (tag) {
        case FavourateViewSegmentTagService:
        {
            [self.serviceResultArray removeAllObjects];
        }
            break;
        case FavourateViewSegmentTagStore:
        {
            [self.storeResultArray removeAllObjects];
        }
            break;
        case FavourateViewSegmentTagStrategy:
        {
            [self.strategyResultArray removeAllObjects];
        }
            break;
        case FavourateViewSegmentTagNews:
        {
            [self.newsResultArray removeAllObjects];
        }
            break;
        default:
            break;
    }
}

- (void)loadFavourateSucceedWithData:(NSDictionary *)data segmmentTag:(FavourateViewSegmentTag)tag {
    [self clearDataForTag:tag];
    [self reloadFavourateViewWithData:data forSegmmentTag:tag];
}

- (void)loadFavourateFailedWithError:(NSError *)error segmmentTag:(FavourateViewSegmentTag)tag {
    [self clearDataForTag:tag];
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
            [self.view noMoreData:YES forTag:tag];
        }
            break;
        default:
            break;
    }
    [self reloadFavourateViewWithData:nil forSegmmentTag:tag];
    [self.view endRefresh];
}

- (void)loadMoreFavourateSucceedWithData:(NSDictionary *)data segmmentTag:(FavourateViewSegmentTag)tag {
    switch (tag) {
        case FavourateViewSegmentTagService:
        {
            self.currentServicePage ++;
        }
            break;
        case FavourateViewSegmentTagStore:
        {
            self.currentStorePage ++;
        }
            break;
        case FavourateViewSegmentTagStrategy:
        {
            self.currentStrategyPage ++;
        }
            break;
        case FavourateViewSegmentTagNews:
        {
            self.currentNewsPage ++;
        }
            break;
        default:
            break;
    }
    [self reloadFavourateViewWithData:data forSegmmentTag:tag];
    [self.view endLoadMore];
}

- (void)loadMoreFavourateFailedWithError:(NSError *)error segmmentTag:(FavourateViewSegmentTag)tag {
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
            [self.view noMoreData:YES forTag:tag];
            return;
        }
            break;
        default:
            break;
    }
    [self.view endLoadMore];
}

- (void)deleteFavourateSucceedAtIndex:(NSUInteger)index forSegmmentTag:(FavourateViewSegmentTag)tag {
    
}

- (void)deleteFavourateFailedWithError:(NSError *)error atIndex:(NSUInteger)index forSegmmentTag:(FavourateViewSegmentTag)tag {
    
}

- (void)reloadFavourateViewWithData:(NSDictionary *)data forSegmmentTag:(FavourateViewSegmentTag)tag {
    NSArray *dataArray = [data objectForKey:@"data"];
    if ([dataArray isKindOfClass:[NSArray class]] && [dataArray count] > 0) {
        [self.view hideLoadMoreFooter:NO ForTag:tag];
        switch (tag) {
            case FavourateViewSegmentTagService:
            {
                for (NSDictionary *singleService in dataArray) {
                    ServiceListItemModel *model = [[ServiceListItemModel alloc] initWithRawData:singleService];
                    if (model) {
                        [self.serviceResultArray addObject:model];
                    }
                }
                if ([dataArray count] < [self.view serviceListPageSize]) {
                    [self.view noMoreData:YES forTag:tag];
                } else {
                    [self.view noMoreData:NO forTag:tag];
                }
            }
                break;
            case FavourateViewSegmentTagStore:
            {
                for (NSDictionary *singleStore in dataArray) {
                    StoreListItemModel *model = [[StoreListItemModel alloc] initWithRawData:singleStore];
                    if (model) {
                        [self.storeResultArray addObject:model];
                    }
                }
                if ([dataArray count] < [self.view storeListPageSize]) {
                    [self.view noMoreData:YES forTag:tag];
                } else {
                    [self.view noMoreData:NO forTag:tag];
                }
            }
                break;
            case FavourateViewSegmentTagStrategy:
            {
                for (NSDictionary *singleStrategy in dataArray) {
                    ParentingStrategyListItemModel *model = [[ParentingStrategyListItemModel alloc] initWithRawData:singleStrategy];
                    if (model) {
                        [self.strategyResultArray addObject:model];
                    }
                }
                if ([dataArray count] < [self.view strategyListPageSize]) {
                    [self.view noMoreData:YES forTag:tag];
                } else {
                    [self.view noMoreData:NO forTag:tag];
                }
            }
                break;
            case FavourateViewSegmentTagNews:
            {
                for (NSDictionary *singleStrategy in dataArray) {
                    NewsListItemModel *model = [[NewsListItemModel alloc] initWithRawData:singleStrategy];
                    if (model) {
                        [self.newsResultArray addObject:model];
                    }
                }
                if ([dataArray count] < [self.view strategyListPageSize]) {
                    [self.view noMoreData:YES forTag:tag];
                } else {
                    [self.view noMoreData:NO forTag:tag];
                }
            }
                break;
            default:
                break;
        }
    } else {
        [self.view noMoreData:YES forTag:tag];
        [self.view hideLoadMoreFooter:YES ForTag:tag];
    }
    [self.view reloadDataForTag:tag];
    [self.view endRefresh];
    [self.view endLoadMore];
}

#pragma mark Public methods

- (void)startUpdateDataWithFavouratedTag:(FavourateViewSegmentTag)tag {
    KTCFavouriteType type = KTCFavouriteTypeService;
    NSUInteger page = 1;
    NSUInteger pageSize = 10;
    switch (tag) {
        case FavourateViewSegmentTagService:
        {
            self.currentServicePage = 1;
            type = KTCFavouriteTypeService;
            page = self.currentServicePage;
            pageSize = [self.view serviceListPageSize];
        }
            break;
        case FavourateViewSegmentTagStore:
        {
            self.currentStorePage = 1;
            type = KTCFavouriteTypeStore;
            page = self.currentStorePage;
            pageSize = [self.view storeListPageSize];
        }
            break;
        case FavourateViewSegmentTagStrategy:
        {
            self.currentStrategyPage = 1;
            type = KTCFavouriteTypeStrategy;
            page = self.currentStrategyPage;
            pageSize = [self.view strategyListPageSize];
        }
            break;
        case FavourateViewSegmentTagNews:
        {
            self.currentNewsPage = 1;
            type = KTCFavouriteTypeNews;
            page = self.currentNewsPage;
            pageSize = [self.view newsListPageSize];
        }
            break;
        default:
            break;
    }
    __weak FavourateViewModel *weakSelf = self;
    [[KTCFavouriteManager sharedManager] loadFavouriteWithType:type page:page pageSize:pageSize succeed:^(NSDictionary *data) {
        [weakSelf loadFavourateSucceedWithData:data segmmentTag:tag];
    } failure:^(NSError *error) {
        [weakSelf loadFavourateFailedWithError:error segmmentTag:tag];
    }];
}

- (void)getMoreDataWithFavouratedTag:(FavourateViewSegmentTag)tag {
    KTCFavouriteType type = KTCFavouriteTypeService;
    NSUInteger page = 1;
    NSUInteger pageSize = 10;
    switch (tag) {
        case FavourateViewSegmentTagService:
        {
            type = KTCFavouriteTypeService;
            page = self.currentServicePage + 1;
            pageSize = [self.view serviceListPageSize];
        }
            break;
        case FavourateViewSegmentTagStore:
        {
            type = KTCFavouriteTypeStore;
            page = self.currentStorePage + 1;
            pageSize = [self.view storeListPageSize];
        }
            break;
        case FavourateViewSegmentTagStrategy:
        {
            type = KTCFavouriteTypeStrategy;
            page = self.currentStrategyPage + 1;
            pageSize = [self.view strategyListPageSize];
        }
            break;
        case FavourateViewSegmentTagNews:
        {
            type = KTCFavouriteTypeNews;
            page = self.currentNewsPage + 1;
            pageSize = [self.view newsListPageSize];
        }
            break;
        default:
            break;
    }
    __weak FavourateViewModel *weakSelf = self;
    [[KTCFavouriteManager sharedManager] loadFavouriteWithType:type page:page pageSize:pageSize succeed:^(NSDictionary *data) {
        [weakSelf loadMoreFavourateSucceedWithData:data segmmentTag:tag];
    } failure:^(NSError *error) {
        [weakSelf loadMoreFavourateFailedWithError:error segmmentTag:tag];
    }];
}

- (void)resetResultWithFavouratedTag:(FavourateViewSegmentTag)tag {
    self.currentTag = tag;
    [self stopUpdateData];
    switch (tag) {
        case FavourateViewSegmentTagService:
        {
            if ([self.serviceResultArray count] > 0) {
                [self.view reloadDataForTag:FavourateViewSegmentTagService];
            } else {
                [self startUpdateDataWithFavouratedTag:FavourateViewSegmentTagService];
            }
        }
            break;
        case FavourateViewSegmentTagStore:
        {
            if ([self.storeResultArray count] > 0) {
                [self.view reloadDataForTag:FavourateViewSegmentTagStore];
            } else {
                [self startUpdateDataWithFavouratedTag:FavourateViewSegmentTagStore];
            }
        }
            break;
        case FavourateViewSegmentTagStrategy:
        {
            if ([self.strategyResultArray count] > 0) {
                [self.view reloadDataForTag:FavourateViewSegmentTagStrategy];
            } else {
                [self startUpdateDataWithFavouratedTag:FavourateViewSegmentTagStrategy];
            }
        }
            break;
        case FavourateViewSegmentTagNews:
        {
            if ([self.newsResultArray count] > 0) {
                [self.view reloadDataForTag:FavourateViewSegmentTagNews];
            } else {
                [self startUpdateDataWithFavouratedTag:FavourateViewSegmentTagNews];
            }
        }
            break;
        default:
            break;
    }
}

- (void)stopUpdateData {
    [[KTCFavouriteManager sharedManager] stopLoadFavourite];
    [self.view endRefresh];
    [self.view endLoadMore];
}

- (void)deleteFavourateDataForTag:(FavourateViewSegmentTag)tag atInde:(NSUInteger)index {
    [self stopUpdateData];
    KTCFavouriteType type = KTCFavouriteTypeService;
    NSString *identifier = @"0";
    switch (tag) {
        case FavourateViewSegmentTagService:
        {
            type = KTCFavouriteTypeService;
            ServiceListItemModel *model = [self.serviceResultArray objectAtIndex:index];
            identifier = model.identifier;
        }
            break;
        case FavourateViewSegmentTagStore:
        {
            type = KTCFavouriteTypeStore;
            StoreListItemModel *model = [self.storeResultArray objectAtIndex:index];
            identifier = model.identifier;
        }
            break;
        case FavourateViewSegmentTagStrategy:
        {
            type = KTCFavouriteTypeStore;
            StoreListItemModel *model = [self.storeResultArray objectAtIndex:index];
            identifier = model.identifier;
        }
            break;
        case FavourateViewSegmentTagNews:
        {
            type = KTCFavouriteTypeStore;
            StoreListItemModel *model = [self.storeResultArray objectAtIndex:index];
            identifier = model.identifier;
        }
            break;
        default:
            break;
    }
    __weak FavourateViewModel *weakSelf = self;
    [[KTCFavouriteManager sharedManager] deleteFavouriteWithIdentifier:identifier type:type succeed:^(NSDictionary *data) {
        [weakSelf deleteFavourateSucceedAtIndex:index forSegmmentTag:tag];
    } failure:^(NSError *error) {
        [weakSelf deleteFavourateFailedWithError:error atIndex:index forSegmmentTag:tag];
    }];
}

@end
