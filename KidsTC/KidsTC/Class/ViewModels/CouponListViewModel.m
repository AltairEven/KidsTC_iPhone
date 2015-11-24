//
//  CouponListViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 9/6/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CouponListViewModel.h"
#import "CouponFullCutModel.h"

#define PageSize (10)

#define CouponListTabNumberKeyUnused (@"CouponListTabNumberKeyUnused")
#define CouponListTabNumberKeyHasUsed (@"CouponListTabNumberKeyHasUsed")
#define CouponListTabNumberKeyHasOverTime (@"CouponListTabNumberKeyHasOverTime")

@interface CouponListViewModel () <CouponListViewDataSource>

@property (nonatomic, weak) CouponListView *view;

@property (nonatomic, strong) HttpRequestClient *loadCouponsRequest;

@property (nonatomic, strong) NSMutableArray *unusedResultArray;

@property (nonatomic, strong) NSMutableArray *hasUsedResultArray;

@property (nonatomic, strong) NSMutableArray *hasOverTimeResultArray;

@property (nonatomic, assign) CouponListViewTag currentTag;

@property (nonatomic, assign) NSUInteger currentUnusedPage;

@property (nonatomic, assign) NSUInteger currentHasUsedPage;

@property (nonatomic, assign) NSUInteger currentHasOverTimePage;

@property (nonatomic, strong) NSMutableDictionary *tabNumbersDic;

- (void)clearDataForTag:(CouponListViewTag)tag;

- (void)loadCouponsSucceedWithData:(NSDictionary *)data segmmentTag:(CouponListViewTag)tag;

- (void)loadCouponsFailedWithError:(NSError *)error segmmentTag:(CouponListViewTag)tag;

- (void)loadMoreCouponsSucceedWithData:(NSDictionary *)data segmmentTag:(CouponListViewTag)tag;

- (void)loadMoreCouponsFailedWithError:(NSError *)error segmmentTag:(CouponListViewTag)tag;

- (void)fillTabNumberWithData:(NSDictionary *)data;

- (void)reloadCouponListViewWithData:(NSDictionary *)data forSegmmentTag:(CouponListViewTag)tag;

@end

@implementation CouponListViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (CouponListView *)view;
        self.view.dataSource = self;
        self.currentTag = CouponListViewTagUnused;
        self.currentUnusedPage = 1;
        self.currentHasUsedPage = 1;
        self.currentHasOverTimePage = 1;
        [self.view hideLoadMoreFooter:YES forViewTag:CouponListViewTagUnused];
        [self.view hideLoadMoreFooter:YES forViewTag:CouponListViewTagHasUsed];
        [self.view hideLoadMoreFooter:YES forViewTag:CouponListViewTagHasOverTime];
        self.unusedResultArray = [[NSMutableArray alloc] init];
        self.hasUsedResultArray = [[NSMutableArray alloc] init];
        self.hasOverTimeResultArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark CouponListViewDataSource

- (NSArray *)couponModelsOfCouponListView:(CouponListView *)listView withTag:(CouponListViewTag)tag {
    switch (tag) {
        case CouponListViewTagUnused:
        {
            return [NSArray arrayWithArray:self.unusedResultArray];
        }
            break;
        case CouponListViewTagHasUsed:
        {
            return [NSArray arrayWithArray:self.hasUsedResultArray];
        }
            break;
        case CouponListViewTagHasOverTime:
        {
            return [NSArray arrayWithArray:self.hasOverTimeResultArray];
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark Private methods

- (void)clearDataForTag:(CouponListViewTag)tag {
    switch (tag) {
        case CouponListViewTagUnused:
        {
            [self.unusedResultArray removeAllObjects];
        }
            break;
        case CouponListViewTagHasUsed:
        {
            [self.hasUsedResultArray removeAllObjects];
        }
            break;
        case CouponListViewTagHasOverTime:
        {
            [self.hasOverTimeResultArray removeAllObjects];
        }
            break;
        default:
            break;
    }
}

- (void)loadCouponsSucceedWithData:(NSDictionary *)data segmmentTag:(CouponListViewTag)tag {
    [self clearDataForTag:tag];
    [self reloadCouponListViewWithData:data forSegmmentTag:tag];
}

- (void)loadCouponsFailedWithError:(NSError *)error segmmentTag:(CouponListViewTag)tag {
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
            [self.view noMoreData:YES forViewTag:tag];
        }
            break;
        default:
            break;
    }
    [self clearDataForTag:tag];
    [self reloadCouponListViewWithData:nil forSegmmentTag:tag];
}

- (void)loadMoreCouponsSucceedWithData:(NSDictionary *)data segmmentTag:(CouponListViewTag)tag {
    switch (tag) {
        case CouponListViewTagUnused:
        {
            self.currentUnusedPage ++;
        }
            break;
        case CouponListViewTagHasUsed:
        {
            self.currentHasUsedPage ++;
        }
            break;
        case CouponListViewTagHasOverTime:
        {
            self.currentHasOverTimePage ++;
        }
            break;
        default:
            break;
    }
    [self reloadCouponListViewWithData:data forSegmmentTag:tag];
    [self.view endLoadMore];
}

- (void)loadMoreCouponsFailedWithError:(NSError *)error segmmentTag:(CouponListViewTag)tag {
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
            [self.view noMoreData:YES forViewTag:tag];
        }
            break;
        default:
            break;
    }
    [self reloadCouponListViewWithData:nil forSegmmentTag:tag];
    [self.view endLoadMore];
}

- (void)fillTabNumberWithData:(NSDictionary *)data {
    if (!self.tabNumbersDic) {
        self.tabNumbersDic = [[NSMutableDictionary alloc] init];
    }
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSNumber *unusedCount = [NSNumber numberWithInteger:[[data objectForKey:@"all"] integerValue]];
        if (unusedCount) {
            [self.tabNumbersDic setObject:unusedCount forKey:CouponListTabNumberKeyUnused];
        }
        NSNumber *hasUsedCount = [NSNumber numberWithInteger:[[data objectForKey:@"all"] integerValue]];
        if (hasUsedCount) {
            [self.tabNumbersDic setObject:hasUsedCount forKey:CouponListTabNumberKeyUnused];
        }
        NSNumber *hasOverTimeCount = [NSNumber numberWithInteger:[[data objectForKey:@"all"] integerValue]];
        if (hasOverTimeCount) {
            [self.tabNumbersDic setObject:hasOverTimeCount forKey:CouponListTabNumberKeyUnused];
        }
    }
    [self.view reloadSegmentHeader];
}

- (void)reloadCouponListViewWithData:(NSDictionary *)data forSegmmentTag:(CouponListViewTag)tag {
    NSArray *itemsArray = [data objectForKey:@"data"];
    if ([itemsArray isKindOfClass:[NSArray class]] ) {
        [self.view hideLoadMoreFooter:NO forViewTag:tag];
        for (NSDictionary *singleItem in itemsArray) {
            CouponFullCutModel *model = [[CouponFullCutModel alloc] initWithRawData:singleItem];
            if (model) {
                switch (tag) {
                    case CouponListViewTagUnused:
                    {
                        [self.unusedResultArray addObject:model];
                    }
                        break;
                    case CouponListViewTagHasUsed:
                    {
                        [self.hasUsedResultArray addObject:model];
                    }
                        break;
                    case CouponListViewTagHasOverTime:
                    {
                        [self.hasOverTimeResultArray addObject:model];
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        if ([itemsArray count] < PageSize) {
            [self.view noMoreData:YES forViewTag:tag];
        } else {
            [self.view noMoreData:NO forViewTag:tag];
        }
    }
    if (self.currentTag == tag) {
        [self.view reloadDataforViewTag:tag];
        [self.view endRefresh];
        [self.view endLoadMore];
    }
}

#pragma mark Public methods

- (void)startUpdateDataWithViewTag:(CouponListViewTag)tag {
    if (!self.loadCouponsRequest) {
        self.loadCouponsRequest = [HttpRequestClient clientWithUrlAliasName:@"COUPON_QUERRY"];
    }
    
    CouponStatus status = CouponStatusUnknown;
    NSUInteger index = 1;
    switch (tag) {
        case CouponListViewTagUnused:
        {
            index = self.currentUnusedPage;
            status = CouponStatusUnused;
        }
            break;
        case CouponListViewTagHasUsed:
        {
            index = self.currentHasUsedPage;
            status = CouponStatusHasUsed;
        }
            break;
        case CouponListViewTagHasOverTime:
        {
            index = self.currentHasOverTimePage;
            status = CouponStatusHasOverTime;
        }
            break;
        default:
            break;
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber  numberWithInteger:status], @"status",
                           [NSNumber numberWithInteger:index], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pagecount", nil];
    
    
    __weak CouponListViewModel *weakSelf = self;
    [weakSelf.loadCouponsRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadCouponsSucceedWithData:responseData segmmentTag:weakSelf.currentTag];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadCouponsFailedWithError:error segmmentTag:weakSelf.currentTag];
    }];
}

- (void)getMoreDataWithViewTag:(CouponListViewTag)tag {
    if (!self.loadCouponsRequest) {
        self.loadCouponsRequest = [HttpRequestClient clientWithUrlAliasName:@"COUPON_QUERRY"];
    }
    
    CouponStatus status = CouponStatusUnknown;
    NSUInteger index = 1;
    switch (tag) {
        case CouponListViewTagUnused:
        {
            index = self.currentUnusedPage + 1;
            status = CouponStatusUnused;
        }
            break;
        case CouponListViewTagHasUsed:
        {
            index = self.currentHasUsedPage + 1;
            status = CouponStatusHasUsed;
        }
            break;
        case CouponListViewTagHasOverTime:
        {
            index = self.currentHasOverTimePage + 1;
            status = CouponStatusHasOverTime;
        }
            break;
        default:
            break;
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber  numberWithInteger:status], @"status",
                           [NSNumber numberWithInteger:index], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pagecount", nil];
    
    __weak CouponListViewModel *weakSelf = self;
    [weakSelf.loadCouponsRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadCouponsSucceedWithData:responseData segmmentTag:weakSelf.currentTag];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadCouponsFailedWithError:error segmmentTag:weakSelf.currentTag];
    }];
}

- (void)resetResultWithViewTag:(CouponListViewTag)tag {
    [self.view endRefresh];
    [self.view endLoadMore];
    self.currentTag = tag;
    switch (tag) {
        case CouponListViewTagUnused:
        {
            if ([self.unusedResultArray count] > 0) {
                [self.view reloadDataforViewTag:self.currentTag];
            } else {
                [self startUpdateDataWithViewTag:tag];
            }
        }
            break;
        case CouponListViewTagHasUsed:
        {
            if ([self.hasUsedResultArray count] > 0) {
                [self.view reloadDataforViewTag:self.currentTag];
            } else {
                [self startUpdateDataWithViewTag:tag];
            }
        }
            break;
        case CouponListViewTagHasOverTime:
        {
            if ([self.hasOverTimeResultArray count] > 0) {
                [self.view reloadDataforViewTag:self.currentTag];
            } else {
                [self startUpdateDataWithViewTag:tag];
            }
        }
            break;
        default:
            break;
    }
}

- (NSArray *)resultOfCurrentViewTag {
    NSArray *array = nil;
    switch (self.currentTag) {
        case CouponListViewTagUnused:
        {
            array = [NSArray arrayWithArray:self.unusedResultArray];
        }
            break;
        case CouponListViewTagHasUsed:
        {
            array = [NSArray arrayWithArray:self.hasUsedResultArray];
        }
            break;
        case CouponListViewTagHasOverTime:
        {
            array = [NSArray arrayWithArray:self.hasOverTimeResultArray];
        }
            break;
        default:
            break;
    }
    return array;
}


#pragma mark Super methods

- (void)stopUpdateData {
    [self.loadCouponsRequest cancel];
    [self.view endRefresh];
    [self.view endLoadMore];
}

@end
