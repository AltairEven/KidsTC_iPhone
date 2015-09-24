//
//  KTCSearchResultViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/6/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "KTCSearchResultView.h"
#import "ServiceListItemModel.h"
#import "StoreListItemModel.h"

@interface KTCSearchResultViewModel : BaseViewModel

@property (nonatomic, assign) KTCSearchType searchType;

@property (nonatomic, strong) KTCSearchServiceCondition *searchServiceCondition;

@property (nonatomic, strong) KTCSearchStoreCondition *searchStoreCondition;

@property (nonatomic, strong, readonly) KTCSearchResultFilterModel *areaFilterModel;

@property (nonatomic, strong, readonly) KTCSearchResultFilterModel *sortFilterModel;

@property (nonatomic, strong, readonly) KTCSearchResultFilterModel *ageFilterModel;

@property (nonatomic, strong, readonly) NSArray *categoryFilterModels;

@property (nonatomic, assign) KTCSearchResultFilterCoordinate serviceAreaFilterCoordinate;

@property (nonatomic, assign) KTCSearchResultFilterCoordinate serviceSortFilterCoordinate;

@property (nonatomic, assign) KTCSearchResultFilterCoordinate serviceAgeFilterCoordinate;

@property (nonatomic, assign) KTCSearchResultFilterCoordinate serviceCategoryFilterCoordinate;

@property (nonatomic, assign) KTCSearchResultFilterCoordinate storeAreaFilterCoordinate;

@property (nonatomic, assign) KTCSearchResultFilterCoordinate storeSortFilterCoordinate;

@property (nonatomic, assign) KTCSearchResultFilterCoordinate storeAgeFilterCoordinate;

@property (nonatomic, assign) KTCSearchResultFilterCoordinate storeCategoryFilterCoordinate;

- (void)startUpdateDataWithSearchType:(KTCSearchType)type;

- (void)getMoreDataWithSearchType:(KTCSearchType)type;

- (void)resetSearchResultViewWithSearchType:(KTCSearchType)type;

- (void)stopUpdateDataWithSearchType:(KTCSearchType)type;

- (NSArray *)serviceResult;

- (NSArray *)storeResult;

@end
