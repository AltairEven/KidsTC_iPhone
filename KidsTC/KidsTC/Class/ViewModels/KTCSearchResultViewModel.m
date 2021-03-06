//
//  KTCSearchResultViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/6/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCSearchResultViewModel.h"
#import "IcsonCategoryManager.h"

@interface KTCSearchResultViewModel () <KTCSearchResultViewDataSource>

@property (nonatomic, strong) KTCSearchResultView *view;

@property (nonatomic, strong) NSMutableArray *serviceResultArray;

@property (nonatomic, strong) NSMutableArray *storeResultArray;

@property (nonatomic, assign) NSUInteger currentServicePage;

@property (nonatomic, assign) NSUInteger serviceTotalCount;

@property (nonatomic, assign) NSUInteger currentStorePage;

@property (nonatomic, assign) NSUInteger storeTotalCount;

- (void)dataInitialization;

- (void)loadServiceDataSucceed:(NSDictionary *)data;

- (void)loadServiceDataFailed:(NSError *)error;

- (void)loadMoreServiceDataSucceed:(NSDictionary *)data;

- (void)loadMoreServiceDataFailed:(NSError *)error;

- (void)loadStoreDataSucceed:(NSDictionary *)data;

- (void)loadStoreDataFailed:(NSError *)error;

- (void)loadMoreStoreDataSucceed:(NSDictionary *)data;

- (void)loadMoreStoreDataFailed:(NSError *)error;

- (void)reloadServiceWithData:(NSDictionary *)data;

- (void)reloadStoreWithData:(NSDictionary *)data;

@end

@implementation KTCSearchResultViewModel


- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (KTCSearchResultView *)view;
        self.view.dataSource = self;
        self.searchType = KTCSearchTypeService;
        self.currentServicePage = 1;
        self.currentStorePage = 1;
        [self.view hideLoadMoreFooter:YES forSearchType:KTCSearchTypeService];
        [self.view hideLoadMoreFooter:YES forSearchType:KTCSearchTypeStore];
        [self dataInitialization];
        self.serviceResultArray = [[NSMutableArray alloc] init];
        self.storeResultArray = [[NSMutableArray alloc] init];
        self.serviceAreaFilterCoordinate = FilterCoordinateMake(-1, -1);
        self.serviceSortFilterCoordinate = FilterCoordinateMake(-1, -1);
        self.serviceAgeFilterCoordinate = FilterCoordinateMake(-1, -1);
        self.serviceCategoryFilterCoordinate = FilterCoordinateMake(-1, -1);
        self.storeAreaFilterCoordinate = FilterCoordinateMake(-1, -1);
        self.storeSortFilterCoordinate = FilterCoordinateMake(-1, -1);
        self.storeAgeFilterCoordinate = FilterCoordinateMake(-1, -1);
        self.storeCategoryFilterCoordinate = FilterCoordinateMake(-1, -1);
    }
    return self;
}

- (void)setSearchServiceCondition:(KTCSearchServiceCondition *)searchServiceCondition {
    _searchServiceCondition = searchServiceCondition;
    //area
    NSInteger index = 0;
    BOOL hasFiltered = NO;
    for (; index < [self.areaFilterModel.subArray count]; index ++) {
        KTCSearchResultFilterModel *areaFilter = [self.areaFilterModel.subArray objectAtIndex:index];
        if ([searchServiceCondition.area.identifier isEqualToString:areaFilter.identifier]) {
            hasFiltered = YES;
            break;
        }
    }
    if (hasFiltered) {
        KTCSearchResultFilterCoordinate areaCoord = FilterCoordinateMake(0, index);
        self.serviceAreaFilterCoordinate = areaCoord;
    }
    //age
    index = 0;
    hasFiltered = NO;
    for (; index < [self.ageFilterModel.subArray count]; index ++) {
        KTCSearchResultFilterModel *ageFilter = [self.ageFilterModel.subArray objectAtIndex:index];
        if ([searchServiceCondition.age.identifier isEqualToString:ageFilter.identifier]) {
            hasFiltered = YES;
            break;
        }
    }
    if (hasFiltered) {
        KTCSearchResultFilterCoordinate ageCoord = FilterCoordinateMake(0, index);
        self.serviceAreaFilterCoordinate = ageCoord;
    }
    //category
    NSArray *lvl1Categories = [[IcsonCategoryManager sharedManager] getCategoryArrayWithLevel:CategoryLevel1 Error:nil];
    KTCSearchResultFilterCoordinate cateCoord = FilterCoordinateMake(-1, -1);
    for (NSUInteger index = 0; index < [lvl1Categories count]; index ++) {
        IcsonLevel1Category *category = [lvl1Categories objectAtIndex:index];
        NSArray *nextLevel = [category nextLevel];
        for (NSUInteger nextIndex = 0; nextIndex < [nextLevel count]; nextIndex ++) {
            IcsonLevel2Category *level2Category = [nextLevel objectAtIndex:nextIndex];
            if ([level2Category.identifier isEqualToString:searchServiceCondition.categoryIdentifier]) {
                cateCoord = FilterCoordinateMake(index, nextIndex);
            }
        }
    }
    self.serviceCategoryFilterCoordinate = cateCoord;
}


- (void)setSearchStoreCondition:(KTCSearchStoreCondition *)searchStoreCondition {
    _searchStoreCondition = searchStoreCondition;
    //area
    NSInteger index = 0;
    BOOL hasFiltered = NO;
    for (; index < [self.areaFilterModel.subArray count]; index ++) {
        KTCSearchResultFilterModel *areaFilter = [self.areaFilterModel.subArray objectAtIndex:index];
        if ([searchStoreCondition.area.identifier isEqualToString:areaFilter.identifier]) {
            hasFiltered = YES;
            break;
        }
    }
    if (hasFiltered) {
        KTCSearchResultFilterCoordinate areaCoord = FilterCoordinateMake(0, index);
        self.storeAreaFilterCoordinate = areaCoord;
    }
    //age
    index = 0;
    hasFiltered = NO;
    for (; index < [self.ageFilterModel.subArray count]; index ++) {
        KTCSearchResultFilterModel *ageFilter = [self.ageFilterModel.subArray objectAtIndex:index];
        if ([searchStoreCondition.age.identifier isEqualToString:ageFilter.identifier]) {
            hasFiltered = YES;
            break;
        }
    }
    if (hasFiltered) {
        KTCSearchResultFilterCoordinate ageCoord = FilterCoordinateMake(0, index);
        self.storeAgeFilterCoordinate = ageCoord;
    }
    //category
    NSArray *lvl1Categories = [[IcsonCategoryManager sharedManager] getCategoryArrayWithLevel:CategoryLevel1 Error:nil];
    KTCSearchResultFilterCoordinate cateCoord = FilterCoordinateMake(-1, -1);
    for (NSUInteger index = 0; index < [lvl1Categories count]; index ++) {
        IcsonLevel1Category *category = [lvl1Categories objectAtIndex:index];
        NSArray *nextLevel = [category nextLevel];
        for (NSUInteger nextIndex = 0; nextIndex < [nextLevel count]; nextIndex ++) {
            IcsonLevel2Category *level2Category = [nextLevel objectAtIndex:nextIndex];
            if ([level2Category.identifier isEqualToString:searchStoreCondition.categoryIdentifier]) {
                cateCoord = FilterCoordinateMake(index, nextIndex);
            }
        }
    }
    self.storeCategoryFilterCoordinate = cateCoord;
}

- (void)setServiceAreaFilterCoordinate:(KTCSearchResultFilterCoordinate)serviceAreaFilterCoordinate {
    _serviceAreaFilterCoordinate = serviceAreaFilterCoordinate;
    if (serviceAreaFilterCoordinate.level1Index >=0 && serviceAreaFilterCoordinate.level2Index >= 0) {
        self.searchServiceCondition.area = [self.areaFilterModel.subArray objectAtIndex:serviceAreaFilterCoordinate.level2Index];
    }
}

- (void)setServiceSortFilterCoordinate:(KTCSearchResultFilterCoordinate)serviceSortFilterCoordinate {
    _serviceSortFilterCoordinate = serviceSortFilterCoordinate;
    if (serviceSortFilterCoordinate.level1Index >=0 && serviceSortFilterCoordinate.level2Index >= 0) {
        KTCSearchResultFilterModel *sortModel = [self.sortFilterModel.subArray objectAtIndex:serviceSortFilterCoordinate.level2Index];
        self.searchServiceCondition.sortType = (KTCSearchResultServiceSortType)[sortModel.identifier integerValue];
    }
}

- (void)setServiceAgeFilterCoordinate:(KTCSearchResultFilterCoordinate)serviceAgeFilterCoordinate {
    _serviceAgeFilterCoordinate = serviceAgeFilterCoordinate;
    if (serviceAgeFilterCoordinate.level1Index >=0 && serviceAgeFilterCoordinate.level2Index >= 0) {
        self.searchServiceCondition.age = [self.ageFilterModel.subArray objectAtIndex:serviceAgeFilterCoordinate.level2Index];
    } else {
        self.searchServiceCondition.age = nil;
    }
}

- (void)setServiceCategoryFilterCoordinate:(KTCSearchResultFilterCoordinate)serviceCategoryFilterCoordinate {
    _serviceCategoryFilterCoordinate = serviceCategoryFilterCoordinate;
    if (serviceCategoryFilterCoordinate.level1Index >=0 && serviceCategoryFilterCoordinate.level2Index >= 0) {
        KTCSearchResultFilterModel *level1Model = [self.categoryFilterModels objectAtIndex:serviceCategoryFilterCoordinate.level1Index];
        KTCSearchResultFilterModel *level2Model = [level1Model.subArray objectAtIndex:serviceCategoryFilterCoordinate.level2Index];
        self.searchServiceCondition.categoryIdentifier = level2Model.identifier;
    } else {
        self.searchServiceCondition.categoryIdentifier = 0;
    }
}

- (void)setStoreAreaFilterCoordinate:(KTCSearchResultFilterCoordinate)storeAreaFilterCoordinate {
    _storeAreaFilterCoordinate = storeAreaFilterCoordinate;
    if (storeAreaFilterCoordinate.level1Index >=0 && storeAreaFilterCoordinate.level2Index >= 0) {
        self.searchStoreCondition.area = [self.areaFilterModel.subArray objectAtIndex:storeAreaFilterCoordinate.level2Index];
    }
}


- (void)setStoreSortFilterCoordinate:(KTCSearchResultFilterCoordinate)storeSortFilterCoordinate {
    _storeSortFilterCoordinate = storeSortFilterCoordinate;
    if (storeSortFilterCoordinate.level1Index >=0 && storeSortFilterCoordinate.level2Index >= 0) {
        KTCSearchResultFilterModel *sortModel = [self.sortFilterModel.subArray objectAtIndex:storeSortFilterCoordinate.level2Index];
        self.searchStoreCondition.sortType = (KTCSearchResultStoreSortType)[sortModel.identifier integerValue];
    }
}


- (void)setStoreAgeFilterCoordinate:(KTCSearchResultFilterCoordinate)storeAgeFilterCoordinate {
    _storeAgeFilterCoordinate = storeAgeFilterCoordinate;
    if (storeAgeFilterCoordinate.level1Index >=0 && storeAgeFilterCoordinate.level2Index >= 0) {
        self.searchStoreCondition.age = [self.ageFilterModel.subArray objectAtIndex:storeAgeFilterCoordinate.level2Index];
    } else {
        self.searchStoreCondition.age = nil;
    }
}

- (void)setStoreCategoryFilterCoordinate:(KTCSearchResultFilterCoordinate)storeCategoryFilterCoordinate {
    _storeCategoryFilterCoordinate = storeCategoryFilterCoordinate;
    if (storeCategoryFilterCoordinate.level1Index >=0 && storeCategoryFilterCoordinate.level2Index >= 0) {
        KTCSearchResultFilterModel *level1Model = [self.categoryFilterModels objectAtIndex:storeCategoryFilterCoordinate.level1Index];
        KTCSearchResultFilterModel *level2Model = [level1Model.subArray objectAtIndex:storeCategoryFilterCoordinate.level2Index];
        self.searchStoreCondition.categoryIdentifier = level2Model.identifier;
    } else {
        self.searchStoreCondition.categoryIdentifier = 0;
    }
}

#pragma mark KTCSearchResultViewDataSource


- (NSArray *)serviceItemModelArrayForSearchResultView:(KTCSearchResultView *)resultView {
    return [NSArray arrayWithArray:self.serviceResultArray];
}

- (NSArray *)storeItemModelArrayForSearchResultView:(KTCSearchResultView *)resultView {
    return [NSArray arrayWithArray:self.storeResultArray];
}

#pragma mark Private methods


- (void)dataInitialization {
    //category
    NSArray *level1Array = [[IcsonCategoryManager sharedManager] level1Categories];
    NSMutableArray *tempLevel1 = [[NSMutableArray alloc] init];
    NSMutableArray *tempLevel2 = [[NSMutableArray alloc] init];
    for (IcsonLevel2Category *level1Category in level1Array) {
        KTCSearchResultFilterModel *filterModel = [[KTCSearchResultFilterModel alloc] init];
        filterModel.name = level1Category.name;
        filterModel.identifier = level1Category.identifier;
        [tempLevel2 removeAllObjects];
        NSArray *level2Array = [level1Category nextLevel];
        for (IcsonLevel2Category *level2Category in level2Array) {
            KTCSearchResultFilterModel *subModel = [[KTCSearchResultFilterModel alloc] init];
            subModel.name = level2Category.name;
            subModel.identifier = level2Category.identifier;
            [tempLevel2 addObject:subModel];
        }
        filterModel.subArray = [NSArray arrayWithArray:tempLevel2];
        [tempLevel1 addObject:filterModel];
    }
    _categoryFilterModels = [NSArray arrayWithArray:tempLevel1];
    //area
    _areaFilterModel = [[KTCSearchResultFilterModel alloc] init];
    _areaFilterModel.name = @"区域";
    NSMutableArray *tempArea = [[NSMutableArray alloc] init];
    for (KTCAreaItem *areaItem in [[KTCArea area] areaItems]) {
        KTCSearchResultFilterModel *areaFilter = [[KTCSearchResultFilterModel alloc] init];
        areaFilter.name = areaItem.name;
        areaFilter.identifier = areaItem.identifier;
        [tempArea addObject:areaFilter];
    }
    _areaFilterModel.subArray = [NSArray arrayWithArray:tempArea];
    //age
    _ageFilterModel = [[KTCSearchResultFilterModel alloc] init];
    _ageFilterModel.name = @"人群";
    NSMutableArray *tempAge = [[NSMutableArray alloc] init];
    for (KTCAgeItem *areaItem in [[KTCAgeScope sharedAgeScope] ageItems]) {
        KTCSearchResultFilterModel *ageFilter = [[KTCSearchResultFilterModel alloc] init];
        ageFilter.name = areaItem.name;
        ageFilter.identifier = areaItem.identifier;
        [tempAge addObject:ageFilter];
    }
    _ageFilterModel.subArray = [NSArray arrayWithArray:tempAge];
    //sort
    [self resetSortFilterWithSearchType:KTCSearchTypeService];
    //set result filter
    [self.view setAreaFilterModel:self.areaFilterModel];
    [self.view setSortFilterModel:self.sortFilterModel];
    [self.view setPeopleFilterModel:self.ageFilterModel];
    [self.view setCategoriesFilterModelArray:self.categoryFilterModels];
}


- (void)resetSortFilterWithSearchType:(KTCSearchType)type {
    _sortFilterModel = [[KTCSearchResultFilterModel alloc] init];
    
    KTCSearchResultFilterCoordinate areaFilterCoordinate;
    KTCSearchResultFilterCoordinate sortFilterCoordinate;
    KTCSearchResultFilterCoordinate ageFilterCoordinate;
    KTCSearchResultFilterCoordinate cateFilterCoordinate;
    
    switch (type) {
        case KTCSearchTypeService:
        {
            KTCSearchResultFilterModel *sortFilter1 = [[KTCSearchResultFilterModel alloc] init];
            sortFilter1.name = @"智能排序";
            sortFilter1.identifier = [NSString stringWithFormat:@"%d", KTCSearchResultServiceSortTypeSmart];
            
            KTCSearchResultFilterModel *sortFilter2 = [[KTCSearchResultFilterModel alloc] init];
            sortFilter2.name = @"按评分排序";
            sortFilter2.identifier = [NSString stringWithFormat:@"%d", KTCSearchResultServiceSortTypeGoodRate];
            
            KTCSearchResultFilterModel *sortFilter3 = [[KTCSearchResultFilterModel alloc] init];
            sortFilter3.name = @"按价格从低到高";
            sortFilter3.identifier = [NSString stringWithFormat:@"%d", KTCSearchResultServiceSortTypePriceAscending];
            
            KTCSearchResultFilterModel *sortFilter4 = [[KTCSearchResultFilterModel alloc] init];
            sortFilter4.name = @"按价格从高到低";
            sortFilter4.identifier = [NSString stringWithFormat:@"%d", KTCSearchResultServiceSortTypePriceDescending];
            
            KTCSearchResultFilterModel *sortFilter5 = [[KTCSearchResultFilterModel alloc] init];
            sortFilter5.name = @"按销量排序";
            sortFilter5.identifier = [NSString stringWithFormat:@"%d", KTCSearchResultServiceSortTypeSaleCount];
            
            
            _sortFilterModel.subArray = [NSArray arrayWithObjects:sortFilter1, sortFilter2, sortFilter3, sortFilter4, sortFilter5, nil];
            areaFilterCoordinate = self.serviceAreaFilterCoordinate;
            sortFilterCoordinate = self.serviceSortFilterCoordinate;
            ageFilterCoordinate = self.serviceAgeFilterCoordinate;
            cateFilterCoordinate = self.serviceCategoryFilterCoordinate;
            if (sortFilterCoordinate.level2Index <= 0) {
                _sortFilterModel.name = sortFilter1.name;
            } else if (sortFilterCoordinate.level2Index == 1) {
                _sortFilterModel.name = sortFilter2.name;
            } else if (sortFilterCoordinate.level2Index == 2) {
                _sortFilterModel.name = sortFilter3.name;
            } else if (sortFilterCoordinate.level2Index == 3) {
                _sortFilterModel.name = sortFilter4.name;
            } else if (sortFilterCoordinate.level2Index == 4) {
                _sortFilterModel.name = sortFilter5.name;
            }
        }
            break;
        case KTCSearchTypeStore:
        {
            KTCSearchResultFilterModel *sortFilter1 = [[KTCSearchResultFilterModel alloc] init];
            sortFilter1.name = @"智能排序";
            sortFilter1.identifier = [NSString stringWithFormat:@"%d", KTCSearchResultStoreSortTypeSmart];
            
            KTCSearchResultFilterModel *sortFilter2 = [[KTCSearchResultFilterModel alloc] init];
            sortFilter2.name = @"按评分排序";
            sortFilter2.identifier = [NSString stringWithFormat:@"%d", KTCSearchResultStoreSortTypeGoodRate];
            
            KTCSearchResultFilterModel *sortFilter3 = [[KTCSearchResultFilterModel alloc] init];
            sortFilter3.name = @"按距离排序";
            sortFilter3.identifier = [NSString stringWithFormat:@"%d", KTCSearchResultStoreSortTypeDistance];
            
            _sortFilterModel.subArray = [NSArray arrayWithObjects:sortFilter1, sortFilter2, sortFilter3, nil];
            areaFilterCoordinate = self.storeAreaFilterCoordinate;
            sortFilterCoordinate = self.storeSortFilterCoordinate;
            ageFilterCoordinate = self.storeAgeFilterCoordinate;
            cateFilterCoordinate = self.storeCategoryFilterCoordinate;
            if (sortFilterCoordinate.level2Index <= 0) {
                _sortFilterModel.name = sortFilter1.name;
            } else if (sortFilterCoordinate.level2Index == 1) {
                _sortFilterModel.name = sortFilter2.name;
            } else if (sortFilterCoordinate.level2Index == 2) {
                _sortFilterModel.name = sortFilter3.name;
            }
        }
            break;
        default:
            break;
    }
    [self.view setAreaFilterModel:self.areaFilterModel];
    [self.view setSortFilterModel:self.sortFilterModel];
    [self.view setPeopleFilterModel:self.ageFilterModel];
    [self.view setCategoriesFilterModelArray:self.categoryFilterModels];
    [self.view setAreaFilterCoordinate:areaFilterCoordinate];
    [self.view setSortFilterCoordinate:sortFilterCoordinate];
    [self.view setAgeFilterCoordinate:ageFilterCoordinate];
    [self.view setCategoryFilterCoordinate:cateFilterCoordinate];
}


- (void)loadServiceDataSucceed:(NSDictionary *)data {
    [self.serviceResultArray removeAllObjects];
    [self reloadServiceWithData:data];
    [self.view endRefreshWithSearchType:KTCSearchTypeService];
}

- (void)loadServiceDataFailed:(NSError *)error {
    [self.view endRefreshWithSearchType:KTCSearchTypeService];
    [self.serviceResultArray removeAllObjects];
    [self reloadServiceWithData:nil];
    switch (error.code) {
        case -999:
        {
            //cancel
            return;
        }
            break;
        case -2001:
        {
            //没有数据
            [self.view noMoreDataWithSearchType:KTCSearchTypeService];
            return;
        }
            break;
        default:
        {
        }
            break;
    }
}

- (void)loadMoreServiceDataSucceed:(NSDictionary *)data {
    self.currentServicePage ++;
    [self reloadServiceWithData:data];
    [self.view endLoadMoreWithSearchType:KTCSearchTypeService];
}

- (void)loadMoreServiceDataFailed:(NSError *)error {
    [self.view endLoadMoreWithSearchType:KTCSearchTypeService];
    switch (error.code) {
        case -999:
        {
            //cancel
            return;
        }
            break;
        case -2001:
        {
            //没有数据
            [self.view noMoreDataWithSearchType:KTCSearchTypeService];
            return;
        }
            break;
        default:
            break;
    }
}

- (void)loadStoreDataSucceed:(NSDictionary *)data {
    [self.storeResultArray removeAllObjects];
    [self reloadStoreWithData:data];
    [self.view endRefreshWithSearchType:KTCSearchTypeStore];
}

- (void)loadStoreDataFailed:(NSError *)error {
    [self.view endRefreshWithSearchType:KTCSearchTypeStore];
    [self.storeResultArray removeAllObjects];
    [self reloadStoreWithData:nil];
    switch (error.code) {
        case -999:
        {
            //cancel
        }
            break;
        case -2001:
        {
            //没有数据
            [self.view noMoreDataWithSearchType:KTCSearchTypeStore];
            return;
        }
            break;
        default:
        {
        }
            break;
    }
}

- (void)loadMoreStoreDataSucceed:(NSDictionary *)data {
    self.currentStorePage ++;
    [self reloadStoreWithData:data];
    [self.view endLoadMoreWithSearchType:KTCSearchTypeStore];
}

- (void)loadMoreStoreDataFailed:(NSError *)error {
    switch (error.code) {
        case -999:
        {
            //cancel
        }
            break;
        case -2001:
        {
            //没有数据
            [self.view noMoreDataWithSearchType:KTCSearchTypeStore];
            return;
        }
            break;
        default:
            break;
    }
    [self.view endLoadMoreWithSearchType:KTCSearchTypeStore];
}

- (void)reloadServiceWithData:(NSDictionary *)data {
    if ([data count] > 0) {
        self.serviceTotalCount = [[data objectForKey:@"count"] integerValue];
        NSArray *dataArray = [data objectForKey:@"data"];
        if ([dataArray isKindOfClass:[NSArray class]] && [dataArray count] > 0) {
            [self.view hideLoadMoreFooter:NO forSearchType:KTCSearchTypeService];
            for (NSDictionary *singleService in dataArray) {
                ServiceListItemModel *model = [[ServiceListItemModel alloc] initWithRawData:singleService];
                if (model) {
                    [self.serviceResultArray addObject:model];
                }
            }
            if ([dataArray count] < [self.view serviceListPageSize]) {
                [self.view noMoreDataWithSearchType:KTCSearchTypeService];
            }
        } else {
            [self.view noMoreDataWithSearchType:KTCSearchTypeService];
            [self.view hideLoadMoreFooter:YES forSearchType:KTCSearchTypeService];
        }
    } else {
        [self.view hideLoadMoreFooter:YES forSearchType:KTCSearchTypeService];
    }
    [self.view reloadDataForSearchType:KTCSearchTypeService];
}

- (void)reloadStoreWithData:(NSDictionary *)data {
    if ([data count] > 0) {
        self.storeTotalCount = [[data objectForKey:@"count"] integerValue];
        NSArray *dataArray = [data objectForKey:@"data"];
        if ([dataArray isKindOfClass:[NSArray class]] && [dataArray count] > 0) {
            [self.view hideLoadMoreFooter:NO forSearchType:KTCSearchTypeStore];
            for (NSDictionary *singleStore in dataArray) {
                StoreListItemModel *model = [[StoreListItemModel alloc] initWithRawData:singleStore];
                if (model) {
                    [self.storeResultArray addObject:model];
                }
            }
            if ([dataArray count] < [self.view storeListPageSize]) {
                [self.view noMoreDataWithSearchType:KTCSearchTypeStore];
            }
        } else {
            [self.view noMoreDataWithSearchType:KTCSearchTypeStore];
            [self.view hideLoadMoreFooter:YES forSearchType:KTCSearchTypeStore];
        }
    } else {
        [self.view hideLoadMoreFooter:YES forSearchType:KTCSearchTypeStore];
    }
    [self.view reloadDataForSearchType:KTCSearchTypeStore];
}

#pragma mark Public methods

- (void)startUpdateDataWithSearchType:(KTCSearchType)type {
    switch (type) {
        case KTCSearchTypeService:
        {
            self.currentServicePage = 1;
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInteger:self.searchType], @"type",
                                   [NSNumber numberWithInteger:self.currentServicePage], @"page",
                                   [NSNumber numberWithInteger:[self.view serviceListPageSize]], @"pageSize", nil];
            [[GAlertLoadingView sharedAlertLoadingView] showInView:self.view.listBG];
            [[KTCSearchService sharedService] startServiceSearchWithParamDic:param Condition:self.searchServiceCondition success:^(NSDictionary *responseData) {
                [self loadServiceDataSucceed:responseData];
                [[GAlertLoadingView sharedAlertLoadingView] hide];
            } failure:^(NSError *error) {
                [self loadServiceDataFailed:error];
                [[GAlertLoadingView sharedAlertLoadingView] hide];
            }];
        }
            break;
        case KTCSearchTypeStore:
        {
            self.currentStorePage = 1;
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInteger:self.searchType], @"type",
                                   [NSNumber numberWithInteger:self.currentStorePage], @"page",
                                   [NSNumber numberWithInteger:[self.view storeListPageSize]], @"pageSize",
                                   [[GConfig sharedConfig] currentLocationCoordinateString], @"mapaddr", nil];
            [[GAlertLoadingView sharedAlertLoadingView] showInView:self.view.listBG];
            [[KTCSearchService sharedService] startStoreSearchWithParamDic:param Condition:self.searchStoreCondition success:^(NSDictionary *responseData) {
                [self loadStoreDataSucceed:responseData];
                [[GAlertLoadingView sharedAlertLoadingView] hide];
            } failure:^(NSError *error) {
                [self loadStoreDataFailed:error];
                [[GAlertLoadingView sharedAlertLoadingView] hide];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)getMoreDataWithSearchType:(KTCSearchType)type {
    switch (type) {
        case KTCSearchTypeService:
        {
            NSUInteger nextPage = self.currentServicePage + 1;
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInteger:self.searchType], @"type",
                                   [NSNumber numberWithInteger:nextPage], @"page",
                                   [NSNumber numberWithInteger:[self.view serviceListPageSize]], @"pageSize", nil];
            [[KTCSearchService sharedService] startServiceSearchWithParamDic:param Condition:self.searchServiceCondition success:^(NSDictionary *responseData) {
                [self loadMoreServiceDataSucceed:responseData];
            } failure:^(NSError *error) {
                [self loadMoreServiceDataFailed:error];
            }];
        }
            break;
        case KTCSearchTypeStore:
        {
            NSUInteger nextPage = self.currentStorePage + 1;
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInteger:self.searchType], @"type",
                                   [NSNumber numberWithInteger:nextPage], @"page",
                                   [NSNumber numberWithInteger:[self.view storeListPageSize]], @"pageSize",
                                   [[GConfig sharedConfig] currentLocationCoordinateString], @"mapaddr", nil];
            [[KTCSearchService sharedService] startStoreSearchWithParamDic:param Condition:self.searchStoreCondition success:^(NSDictionary *responseData) {
                [self loadMoreStoreDataSucceed:responseData];
            } failure:^(NSError *error) {
                [self loadMoreStoreDataFailed:error];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)stopUpdateDataWithSearchType:(KTCSearchType)type {
    [[GAlertLoadingView sharedAlertLoadingView] hide];
    switch (type) {
        case KTCSearchTypeService:
        {
            [[KTCSearchService sharedService] stopServiceSearch];
        }
            break;
        case KTCSearchTypeStore:
        {
            [[KTCSearchService sharedService] stopStoreSearch];
        }
            break;
        default:
            break;
    }
}

- (void)resetSearchResultViewWithSearchType:(KTCSearchType)type {
    self.searchType = type;
    [self resetSortFilterWithSearchType:type];
    switch (type) {
        case KTCSearchTypeService:
        {
            if ([self.serviceResultArray count] == 0) {
                [self stopUpdateDataWithSearchType:KTCSearchTypeStore];
                [self startUpdateDataWithSearchType:KTCSearchTypeService];
            }
        }
            break;
        case KTCSearchTypeStore:
        {
            if ([self.storeResultArray count] == 0) {
                [self stopUpdateDataWithSearchType:KTCSearchTypeService];
                [self startUpdateDataWithSearchType:KTCSearchTypeStore];
            }
        }
            break;
        default:
            break;
    }
}

- (NSArray *)serviceResult {
    return [NSArray arrayWithArray:self.serviceResultArray];
}

- (NSArray *)storeResult {
    return [NSArray arrayWithArray:self.storeResultArray];
}

#pragma mark Super methods

- (void)stopUpdateData {
    [self stopUpdateDataWithSearchType:KTCSearchTypeService];
    [self stopUpdateDataWithSearchType:KTCSearchTypeStore];
}

@end
