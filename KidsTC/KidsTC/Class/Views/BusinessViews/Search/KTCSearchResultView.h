//
//  KTCSearchResultView.h
//  KidsTC
//
//  Created by 钱烨 on 7/20/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTCSearchFilterView.h"


typedef enum {
    KTCSearchResultFilterTagArea,
    KTCSearchResultFilterTagSort,
    KTCSearchResultFilterTagAge,
    KTCSearchResultFilterTagCategory
}KTCSearchResultFilterTag;

@class KTCSearchResultView;

@protocol KTCSearchResultViewDataSource <NSObject>

- (NSArray *)serviceItemModelArrayForSearchResultView:(KTCSearchResultView *)resultView;

- (NSArray *)storeItemModelArrayForSearchResultView:(KTCSearchResultView *)resultView;

@end

@protocol KTCSearchResultViewDelegate <NSObject>

- (void)didClickedBackButtonOnSearchResultView:(KTCSearchResultView *)resultView;

- (void)searchResultView:(KTCSearchResultView *)resultView didClickedSegmentControlWithSearchType:(KTCSearchType)type;

- (void)didClickedSearchButtonOnSearchResultView:(KTCSearchResultView *)headerView;

- (void)searchResultView:(KTCSearchResultView *)resultView didSelectedServiceAtIndex:(NSUInteger)index;

- (void)searchResultView:(KTCSearchResultView *)resultView didSelectedStoreAtIndex:(NSUInteger)index;

- (void)searchResultView:(KTCSearchResultView *)resultView needRefreshTableWithSearchType:(KTCSearchType)type;

- (void)searchResultView:(KTCSearchResultView *)resultView needLoadMoreWithSearchType:(KTCSearchType)type;

//filter

- (void)searchResultView:(KTCSearchResultView *)resultView didSelectedFilterWithCoordinate:(KTCSearchResultFilterCoordinate)coordinate forAreaOfSearchType:(KTCSearchType)type;

- (void)searchResultView:(KTCSearchResultView *)resultView didSelectedFilterWithCoordinate:(KTCSearchResultFilterCoordinate)coordinate forSortOfSearchType:(KTCSearchType)type;

- (void)searchResultView:(KTCSearchResultView *)resultView didConfirmedAgeCoordinate:(KTCSearchResultFilterCoordinate)ageCoordinate categoryCoordinate:(KTCSearchResultFilterCoordinate)categoryCoordinate forSearchType:(KTCSearchType)type;

- (void)didClickedLocateButtonOnSearchResultView:(KTCSearchResultView *)resultView;

@end

@interface KTCSearchResultView : UIView

@property (nonatomic, assign) id<KTCSearchResultViewDataSource> dataSource;
@property (nonatomic, assign) id<KTCSearchResultViewDelegate> delegate;

@property (nonatomic, readonly) KTCSearchType searchType;

@property (nonatomic, strong) KTCSearchResultFilterModel *areaFilterModel;
@property (nonatomic, strong) KTCSearchResultFilterModel *sortFilterModel;
@property (nonatomic, strong) KTCSearchResultFilterModel *peopleFilterModel;
@property (nonatomic, strong) NSArray *categoriesFilterModelArray;

@property (nonatomic, readonly) NSUInteger serviceListPageSize;
@property (nonatomic, readonly) NSUInteger storeListPageSize;

- (void)setCurrentSearchType:(KTCSearchType)type;

- (void)reloadDataForSearchType:(KTCSearchType)type;

- (void)startRefreshWithSearchType:(KTCSearchType)type;

- (void)endRefreshWithSearchType:(KTCSearchType)type;

- (void)endLoadMoreWithSearchType:(KTCSearchType)type;

- (void)noMoreDataWithSearchType:(KTCSearchType)type;

- (void)hideLoadMoreFooter:(BOOL)hidden forSearchType:(KTCSearchType)type;

- (void)setLocation:(NSString *)locationString;

@end
