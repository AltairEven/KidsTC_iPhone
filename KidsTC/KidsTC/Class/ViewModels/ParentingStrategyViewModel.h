//
//  ParentingStrategyViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/24/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "ParentingStrategyView.h"
#import "ParentingStrategyFilterView.h"
#import "ParentingStrategyListItemModel.h"

@interface ParentingStrategyViewModel : BaseViewModel

@property (nonatomic, assign) ParentingStrategySortType currentSortType;

@property (nonatomic, assign) NSUInteger currentAreaIndex;

- (void)startUpdateDataWithCalendarIndex:(NSUInteger)index;

- (void)getMoreDataWithCalendarIndex:(NSUInteger)index;

- (void)resetResultWithCalendarIndex:(NSUInteger)index;

@end
