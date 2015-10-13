//
//  ParentingStrategyViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/24/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ParentingStrategyViewModel.h"

#define PageSize (10)

@interface ParentingStrategyViewModel () <ParentingStrategyViewDataSource>

@property (nonatomic, weak) ParentingStrategyView *view;

@property (nonatomic, strong) HttpRequestClient *loadStrategriesRequest;

@property (nonatomic, strong) NSMutableDictionary *totalResultsContainer;

@property (nonatomic, strong) NSMutableDictionary *currentPageIndexs;

- (void)clearDataForCalendarIndex:(NSUInteger)index;

- (void)loadStrategriesSucceedWithData:(NSDictionary *)data calendarIndex:(NSUInteger)index;

- (void)loadStrategriesFailedWithError:(NSError *)error calendarIndex:(NSUInteger)index;

- (void)loadMoreStrategriesSucceedWithData:(NSDictionary *)data calendarIndex:(NSUInteger)index;

- (void)loadMoreStrategriesFailedWithError:(NSError *)error calendarIndex:(NSUInteger)index;

- (void)reloadParentingStrategyViewWithData:(NSDictionary *)data calendarIndex:(NSUInteger)index;

@end

@implementation ParentingStrategyViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (ParentingStrategyView *)view;
        self.view.dataSource = self;
        self.totalResultsContainer = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark 

- (NSArray *)listItemModelsOfParentingStrategyView:(ParentingStrategyView *)strategyView atCalendarIndex:(NSUInteger)index {
    return [NSArray arrayWithArray:[self.totalResultsContainer objectForKey:[NSNumber numberWithInteger:index]]];
}

#pragma mark Private methods

- (void)clearDataForCalendarIndex:(NSUInteger)index {
    NSMutableArray *dataArray = nil;
    if (dataArray) {
        [dataArray removeAllObjects];
    }
}

- (void)loadStrategriesSucceedWithData:(NSDictionary *)data calendarIndex:(NSUInteger)index {
    [self clearDataForCalendarIndex:index];
    [self reloadParentingStrategyViewWithData:data calendarIndex:index];
}

- (void)loadStrategriesFailedWithError:(NSError *)error calendarIndex:(NSUInteger)index {
    [self clearDataForCalendarIndex:index];
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
    [self reloadParentingStrategyViewWithData:nil calendarIndex:index];
    [self.view endRefresh];
}

- (void)loadMoreStrategriesSucceedWithData:(NSDictionary *)data calendarIndex:(NSUInteger)index {
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)index];
    NSUInteger currentIndex = [[self.currentPageIndexs objectForKey:key] integerValue];
    [self.currentPageIndexs setObject:[NSNumber numberWithInteger:currentIndex + 1] forKey:key];
    [self reloadParentingStrategyViewWithData:data calendarIndex:index];
    [self.view endLoadMore];
}

- (void)loadMoreStrategriesFailedWithError:(NSError *)error calendarIndex:(NSUInteger)index {
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
    [self reloadParentingStrategyViewWithData:nil calendarIndex:index];
    [self.view endLoadMore];
}

- (void)reloadParentingStrategyViewWithData:(NSDictionary *)data calendarIndex:(NSUInteger)index {
//    if ([self.dateDesArray count] > 0) {
//        NSArray *dataArray = [data objectForKey:@"data"];
//        if ([dataArray isKindOfClass:[NSArray class]] && [dataArray count] > 0) {
//            [self.view hideLoadMoreFooter:NO forCalendarIndex:index];
//            
//            NSMutableArray *tempContainer = [[NSMutableArray alloc] init];
//            for (NSDictionary *singleItem in dataArray) {
//                ParentingStrategyListItemModel *model = [[ParentingStrategyListItemModel alloc] initWithRawData:singleItem];
//                if (model) {
//                    [tempContainer addObject:model];
//                }
//            }
//            NSMutableArray *resultArray = [self strategyResultAtCalendarIndex:index];
//            if (resultArray) {
//                [resultArray addObjectsFromArray:tempContainer];
//            } else {
//                [self.totalResultsContainer setObject:tempContainer forKey:[NSNumber numberWithInteger:index]];
//            }
//            
//            if ([dataArray count] < PageSize) {
//                [self.view noMoreData:YES forCalendarIndex:index];
//            } else {
//                [self.view noMoreData:NO forCalendarIndex:index];
//            }
//        } else {
//            [self.view noMoreData:YES forCalendarIndex:index];
//            [self.view hideLoadMoreFooter:YES forCalendarIndex:index];
//        }
//        [self.view reloadData];
//        [self.view endRefresh];
//        [self.view endLoadMore];
//    }
}

#pragma mark Public methods

- (void)startUpdateDataWithCalendarIndex:(NSUInteger)index {
    if (!self.loadStrategriesRequest) {
        self.loadStrategriesRequest = [HttpRequestClient clientWithUrlAliasName:@"SEARCH_STRATEGY"];
    }
    
    NSString *dateString = @"";
//    if ([self.dateDesArray count] > index) {
//        //已经有数据的情况
//        dateString = [self.dateDesArray objectAtIndex:index];
//    }
    
    NSUInteger pageIndex = [[self.currentPageIndexs objectForKey:[NSNumber numberWithInteger:index]] integerValue];
    if (pageIndex <= 0) {
        pageIndex = 1;
    }
    
    NSString *areaId = @"0";
    NSArray *areaArray = [[KTCArea area] areaItems];
    if ([areaArray count] > index) {
        KTCAreaItem *areaItem = [areaArray objectAtIndex:self.currentAreaIndex];
        if (areaItem) {
            areaId = areaItem.identifier;
        }
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           dateString, @"time",
                           [NSNumber numberWithInteger:pageIndex], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pagecount",
                           [NSNumber numberWithInteger:self.currentSortType], @"sort",
                           areaId, @"area", nil];
    __weak ParentingStrategyViewModel *weakSelf = self;
    [weakSelf.loadStrategriesRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadStrategriesSucceedWithData:responseData calendarIndex:index];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadStrategriesFailedWithError:error calendarIndex:index];
    }];
}

- (void)getMoreDataWithCalendarIndex:(NSUInteger)index {
    
}

- (void)resetResultWithCalendarIndex:(NSUInteger)index {
//    self.currentCalendarIndex = index;
//    [self stopUpdateData];
//    NSMutableArray *dataArray = [self strategyResultAtCalendarIndex:index];
//    
//    if ([dataArray count] > 0) {
//        [self.view reloadData];
//    } else {
//        [self startUpdateDataWithCalendarIndex:index];
//    }
}


#pragma mark Super methods

- (void)stopUpdateData {
    [self.loadStrategriesRequest cancel];
    [self.view endRefresh];
    [self.view endLoadMore];
}

@end
