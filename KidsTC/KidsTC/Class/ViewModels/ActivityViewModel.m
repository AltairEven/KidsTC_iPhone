//
//  ActivityViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/12/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ActivityViewModel.h"

#define PageSize (10)

@interface ActivityViewModel () <ActivityViewDataSource>

@property (nonatomic, weak) ActivityView *view;

@property (nonatomic, strong) HttpRequestClient *loadStrategriesRequest;

@property (nonatomic, strong) NSMutableDictionary *totalResultsContainer;

@property (nonatomic, strong) NSArray *dateDesArray;

@property (nonatomic, strong) NSMutableDictionary *currentPageIndexs;

@property (nonatomic, assign) NSUInteger currentCalendarIndex;

- (void)fillDateDescriptionsWithData:(NSDictionary *)data;

- (NSArray *)getDayDescriptionsWithOriginalDates:(NSArray *)datesArray outDateFormatter:(NSDateFormatter *)formatter;

- (NSMutableArray *)activityResultAtCalendarIndex:(NSUInteger)index;

- (void)clearDataForCalendarIndex:(NSUInteger)index;

- (void)loadActivitiesSucceedWithData:(NSDictionary *)data calendarIndex:(NSUInteger)index;

- (void)loadActivitiesFailedWithError:(NSError *)error calendarIndex:(NSUInteger)index;

- (void)loadMoreActivitiesSucceedWithData:(NSDictionary *)data calendarIndex:(NSUInteger)index;

- (void)loadMoreActivitiesFailedWithError:(NSError *)error calendarIndex:(NSUInteger)index;

- (void)reloadActivityViewWithData:(NSDictionary *)data calendarIndex:(NSUInteger)index;

@end

@implementation ActivityViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (ActivityView *)view;
        self.view.dataSource = self;
        self.totalResultsContainer = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (KTCAreaItem *)currentAreaItem {
    if (!_currentAreaItem) {
        NSArray *itemsArray = [[KTCArea area] areaItems];
        if ([itemsArray count] > 0) {
            _currentAreaItem = [[[KTCArea area] areaItems] firstObject];
        }
    }
    return _currentAreaItem;
}

#pragma mark

- (NSArray *)listItemModelsOfActivityView:(ActivityView *)view atCalendarIndex:(NSUInteger)index {
    return [NSArray arrayWithArray:[self.totalResultsContainer objectForKey:[NSNumber numberWithInteger:index]]];
}

#pragma mark Private methods

- (void)fillDateDescriptionsWithData:(NSDictionary *)data {
    NSArray *timesArray = [NSArray arrayWithObjects:@"2015-10-13", @"2015-10-14", @"2015-10-15", @"2015-10-16", @"2015-10-17", @"2015-10-18", @"2015-10-19", nil];
//    NSArray *timesArray = [data objectForKey:@"time"];
    if ([timesArray isKindOfClass:[NSArray class]]) {
        NSString *firstResult = [timesArray firstObject];
        if ([self.dateDesArray count] > 0) {
            NSString *firstDate = [self.dateDesArray firstObject];
            if (![firstDate isEqualToString:firstResult]) {
                self.dateDesArray = [NSArray arrayWithArray:timesArray];
                NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSMutableArray *tempDates = [[NSMutableArray alloc] init];
                for (NSString *dateString in self.dateDesArray) {
                    NSDate *date = [dateFormatter dateFromString:dateString];
                    [tempDates addObject:date];
                }
                [dateFormatter setDateFormat:@"EEM月dd日"];
                dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"];
                [self.view setCalendarTitles:[self getDayDescriptionsWithOriginalDates:[NSArray arrayWithArray:tempDates] outDateFormatter:dateFormatter]];
            }
        } else {
            self.dateDesArray = [NSArray arrayWithArray:timesArray];
            NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSMutableArray *tempDates = [[NSMutableArray alloc] init];
            for (NSString *dateString in self.dateDesArray) {
                NSDate *date = [dateFormatter dateFromString:dateString];
                [tempDates addObject:date];
            }
            [dateFormatter setDateFormat:@"EEM月dd日"];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"];
            [self.view setCalendarTitles:[self getDayDescriptionsWithOriginalDates:[NSArray arrayWithArray:tempDates] outDateFormatter:dateFormatter]];
        }
    }
}

- (NSArray *)getDayDescriptionsWithOriginalDates:(NSArray *)datesArray outDateFormatter:(NSDateFormatter *)formatter {
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    for (NSUInteger left = 0; left < [datesArray count]; left ++) {
        NSDate *newDate = [datesArray objectAtIndex:left];
        NSString *dateString = nil;
        NSString *day =[formatter stringFromDate:newDate];
        if (left == 0) {
            dateString = [NSString stringWithFormat:@"今天%@", [day substringFromIndex:2]];
        } else if (left == 1) {
            dateString = [NSString stringWithFormat:@"明天%@", [day substringFromIndex:2]];
        } else if (left == 2) {
            dateString = [NSString stringWithFormat:@"后天%@", [day substringFromIndex:2]];
        } else {
            dateString = day;
        }
        [retArray addObject:dateString];
    }
    if ([retArray count] > 0) {
        return [NSArray arrayWithArray:retArray];
    }
    return nil;
}

- (NSMutableArray *)activityResultAtCalendarIndex:(NSUInteger)index {
    if ([self.totalResultsContainer count] > index) {
        NSMutableArray *dataArray = [self.totalResultsContainer objectForKey:[NSNumber numberWithInteger:index]];
        if (dataArray) {
            return dataArray;
        }
    }
    return nil;
}

- (void)clearDataForCalendarIndex:(NSUInteger)index {
    NSMutableArray *dataArray = [self activityResultAtCalendarIndex:index];
    if (dataArray) {
        [dataArray removeAllObjects];
    }
}

- (void)loadActivitiesSucceedWithData:(NSDictionary *)data calendarIndex:(NSUInteger)index {
    [self clearDataForCalendarIndex:index];
    [self reloadActivityViewWithData:data calendarIndex:index];
}

- (void)loadActivitiesFailedWithError:(NSError *)error calendarIndex:(NSUInteger)index {
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
            [self.view noMoreData:YES forCalendarIndex:index];
        }
            break;
        default:
            break;
    }
    [self reloadActivityViewWithData:nil calendarIndex:index];
    [self.view endRefresh];
}

- (void)loadMoreActivitiesSucceedWithData:(NSDictionary *)data calendarIndex:(NSUInteger)index {
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)index];
    NSUInteger currentIndex = [[self.currentPageIndexs objectForKey:key] integerValue];
    [self.currentPageIndexs setObject:[NSNumber numberWithInteger:currentIndex + 1] forKey:key];
    [self reloadActivityViewWithData:data calendarIndex:index];
    [self.view endLoadMore];
}

- (void)loadMoreActivitiesFailedWithError:(NSError *)error calendarIndex:(NSUInteger)index {
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
            [self.view noMoreData:YES forCalendarIndex:index];
        }
            break;
        default:
            break;
    }
    [self reloadActivityViewWithData:nil calendarIndex:index];
    [self.view endLoadMore];
}

- (void)reloadActivityViewWithData:(NSDictionary *)data calendarIndex:(NSUInteger)index {
    [self fillDateDescriptionsWithData:data];
    if ([self.dateDesArray count] > 0) {
        NSArray *dataArray = [data objectForKey:@"data"];
        dataArray = [[NSArray alloc] initWithObjects:@"0", @"1", nil];
        if ([dataArray isKindOfClass:[NSArray class]] && [dataArray count] > 0) {
            [self.view hideLoadMoreFooter:NO forCalendarIndex:index];
            
            NSMutableArray *tempContainer = [[NSMutableArray alloc] init];
            for (NSDictionary *singleItem in dataArray) {
                ActivityListItemModel *model = [[ActivityListItemModel alloc] initWithRawData:singleItem];
                if (model) {
                    [tempContainer addObject:model];
                }
            }
            NSMutableArray *resultArray = [self activityResultAtCalendarIndex:index];
            if (resultArray) {
                [resultArray addObjectsFromArray:tempContainer];
            } else {
                [self.totalResultsContainer setObject:tempContainer forKey:[NSNumber numberWithInteger:index]];
            }
            
            if ([dataArray count] < PageSize) {
                [self.view noMoreData:YES forCalendarIndex:index];
            } else {
                [self.view noMoreData:NO forCalendarIndex:index];
            }
        } else {
            [self.view noMoreData:YES forCalendarIndex:index];
            [self.view hideLoadMoreFooter:YES forCalendarIndex:index];
        }
        [self.view reloadData];
        [self.view endRefresh];
        [self.view endLoadMore];
    }
}

#pragma mark Public methods

- (void)startUpdateDataWithCalendarIndex:(NSUInteger)index {
    if (!self.loadStrategriesRequest) {
        self.loadStrategriesRequest = [HttpRequestClient clientWithUrlAliasName:@"SEARCH_STRATEGY"];
    }
    
    NSString *dateString = @"";
    if ([self.dateDesArray count] > index) {
        //已经有数据的情况
        dateString = [self.dateDesArray objectAtIndex:index];
    }
    
    NSUInteger pageIndex = [[self.currentPageIndexs objectForKey:[NSNumber numberWithInteger:index]] integerValue];
    if (pageIndex <= 0) {
        pageIndex = 1;
    }
    
    NSString *areaId = @"0";
    if (self.currentAreaItem) {
        areaId = self.currentAreaItem.identifier;
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           dateString, @"time",
                           [NSNumber numberWithInteger:pageIndex], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pagecount",
                           areaId, @"area", nil];
    __weak ActivityViewModel *weakSelf = self;
    [weakSelf.loadStrategriesRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadActivitiesSucceedWithData:responseData calendarIndex:index];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadActivitiesFailedWithError:error calendarIndex:index];
    }];
}

- (void)getMoreDataWithCalendarIndex:(NSUInteger)index {
    
}

- (void)resetResultWithCalendarIndex:(NSUInteger)index {
    self.currentCalendarIndex = index;
    [self stopUpdateData];
    NSMutableArray *dataArray = [self activityResultAtCalendarIndex:index];
    
    if ([dataArray count] > 0) {
        [self.view reloadData];
    } else {
        [self startUpdateDataWithCalendarIndex:index];
    }
}


#pragma mark Super methods

- (void)stopUpdateData {
    [self.loadStrategriesRequest cancel];
    [self.view endRefresh];
    [self.view endLoadMore];
}

@end
