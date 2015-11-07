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

@property (nonatomic, strong) HttpRequestClient *loadCategoriesRequest;

@property (nonatomic, strong) HttpRequestClient *loadActivitiesRequest;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSUInteger currentPageIndex;

//- (void)fillDateDescriptionsWithData:(NSDictionary *)data;
//
//- (NSArray *)getDayDescriptionsWithOriginalDates:(NSArray *)datesArray outDateFormatter:(NSDateFormatter *)formatter;

- (void)loadActivitiesSucceedWithData:(NSDictionary *)data;

- (void)loadActivitiesFailedWithError:(NSError *)error;

- (void)loadMoreActivitiesSucceedWithData:(NSDictionary *)data;

- (void)loadMoreActivitiesFailedWithError:(NSError *)error;

- (void)reloadActivityViewWithData:(NSDictionary *)data;

@end

@implementation ActivityViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (ActivityView *)view;
        self.view.dataSource = self;
        self.dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark

- (NSArray *)listItemModelsOfActivityView:(ActivityView *)view {
    return [self resultArray];
}

#pragma mark Private methods

//- (void)fillDateDescriptionsWithData:(NSDictionary *)data {
//    NSArray *timesArray = [NSArray arrayWithObjects:@"2015-10-13", @"2015-10-14", @"2015-10-15", @"2015-10-16", @"2015-10-17", @"2015-10-18", @"2015-10-19", nil];
////    NSArray *timesArray = [data objectForKey:@"time"];
//    if ([timesArray isKindOfClass:[NSArray class]]) {
//        NSString *firstResult = [timesArray firstObject];
//        if ([self.dateDesArray count] > 0) {
//            NSString *firstDate = [self.dateDesArray firstObject];
//            if (![firstDate isEqualToString:firstResult]) {
//                self.dateDesArray = [NSArray arrayWithArray:timesArray];
//                NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
//                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//                NSMutableArray *tempDates = [[NSMutableArray alloc] init];
//                for (NSString *dateString in self.dateDesArray) {
//                    NSDate *date = [dateFormatter dateFromString:dateString];
//                    [tempDates addObject:date];
//                }
//                [dateFormatter setDateFormat:@"EEM月dd日"];
//                dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"];
//                [self.view setCalendarTitles:[self getDayDescriptionsWithOriginalDates:[NSArray arrayWithArray:tempDates] outDateFormatter:dateFormatter]];
//            }
//        } else {
//            self.dateDesArray = [NSArray arrayWithArray:timesArray];
//            NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//            NSMutableArray *tempDates = [[NSMutableArray alloc] init];
//            for (NSString *dateString in self.dateDesArray) {
//                NSDate *date = [dateFormatter dateFromString:dateString];
//                [tempDates addObject:date];
//            }
//            [dateFormatter setDateFormat:@"EEM月dd日"];
//            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"];
//            [self.view setCalendarTitles:[self getDayDescriptionsWithOriginalDates:[NSArray arrayWithArray:tempDates] outDateFormatter:dateFormatter]];
//        }
//    }
//}
//
//- (NSArray *)getDayDescriptionsWithOriginalDates:(NSArray *)datesArray outDateFormatter:(NSDateFormatter *)formatter {
//    NSMutableArray *retArray = [[NSMutableArray alloc] init];
//    for (NSUInteger left = 0; left < [datesArray count]; left ++) {
//        NSDate *newDate = [datesArray objectAtIndex:left];
//        NSString *dateString = nil;
//        NSString *day =[formatter stringFromDate:newDate];
//        if (left == 0) {
//            dateString = [NSString stringWithFormat:@"今天%@", [day substringFromIndex:2]];
//        } else if (left == 1) {
//            dateString = [NSString stringWithFormat:@"明天%@", [day substringFromIndex:2]];
//        } else if (left == 2) {
//            dateString = [NSString stringWithFormat:@"后天%@", [day substringFromIndex:2]];
//        } else {
//            dateString = day;
//        }
//        [retArray addObject:dateString];
//    }
//    if ([retArray count] > 0) {
//        return [NSArray arrayWithArray:retArray];
//    }
//    return nil;
//}

- (void)loadActivitiesSucceedWithData:(NSDictionary *)data {
    [self.dataArray removeAllObjects];
    [self reloadActivityViewWithData:data];
}

- (void)loadActivitiesFailedWithError:(NSError *)error {
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

- (void)loadMoreActivitiesSucceedWithData:(NSDictionary *)data {
    self.currentPageIndex += 1;
    [self reloadActivityViewWithData:data];
    [self.view endLoadMore];
}

- (void)loadMoreActivitiesFailedWithError:(NSError *)error {
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
            ActivityListItemModel *model = [[ActivityListItemModel alloc] initWithRawData:singleItem];
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

- (void)getCategoryDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadCategoriesRequest) {
        self.loadCategoriesRequest = [HttpRequestClient clientWithUrlAliasName:@"PRODUCT_ACTIVITY_FILTER_GET"];
    }
    
    __weak ActivityViewModel *weakSelf = self;
    [weakSelf.loadCategoriesRequest startHttpRequestWithParameter:nil success:^(HttpRequestClient *client, NSDictionary *responseData) {
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (NSArray *)resultArray {
    return [NSArray arrayWithArray:self.dataArray];
}

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadActivitiesRequest) {
        self.loadActivitiesRequest = [HttpRequestClient clientWithUrlAliasName:@"PRODUCT_ACTIVITY_GET_LIST"];
    }
    self.currentPageIndex = 1;
    
    NSString *areaId = @"0";
    if (self.currentAreaItem) {
        areaId = self.currentAreaItem.identifier;
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"", @"category",
                           [NSNumber numberWithInteger:self.currentPageIndex], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pageCount",
                           areaId, @"distinct", nil];
    
    __weak ActivityViewModel *weakSelf = self;
    [weakSelf.loadActivitiesRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadActivitiesSucceedWithData:responseData];
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadActivitiesFailedWithError:error];
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getMoreDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadActivitiesRequest) {
        self.loadActivitiesRequest = [HttpRequestClient clientWithUrlAliasName:@"PRODUCT_ACTIVITY_GET_LIST"];
    }
    
    NSUInteger pageIndex = self.currentPageIndex + 1;
    
    NSString *areaId = @"0";
    if (self.currentAreaItem) {
        areaId = self.currentAreaItem.identifier;
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"", @"category",
                           [NSNumber numberWithInteger:pageIndex], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pageCount",
                           areaId, @"distinct", nil];
    
    __weak ActivityViewModel *weakSelf = self;
    [weakSelf.loadActivitiesRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadMoreActivitiesSucceedWithData:responseData];
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadMoreActivitiesFailedWithError:error];
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark Super methods

- (void)stopUpdateData {
    [self.loadActivitiesRequest cancel];
    [self.view endRefresh];
    [self.view endLoadMore];
}

@end
