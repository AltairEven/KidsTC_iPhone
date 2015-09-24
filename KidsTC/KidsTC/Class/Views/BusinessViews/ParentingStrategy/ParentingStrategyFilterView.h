//
//  ParentingStrategyFilterView.h
//  KidsTC
//
//  Created by 钱烨 on 7/23/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ParentingStrategySortTypeDefault,
    ParentingStrategySortTypeRecommend,
    ParentingStrategySortTypeTime
}ParentingStrategySortType;

@class ParentingStrategyFilterView;

@protocol ParentingStrategyFilterViewDelegate <NSObject>

- (void)didClickedConfirmButtonOnParentingStrategyFilterView:(ParentingStrategyFilterView *)filterView withSelectedSortType:(ParentingStrategySortType)type selectedAreaIndex:(NSUInteger)index;

@end

@interface ParentingStrategyFilterView : UIView

@property (nonatomic, assign) id<ParentingStrategyFilterViewDelegate> delegate;

@property (nonatomic, strong) NSArray *areaNameArray;

@property (nonatomic, readonly) ParentingStrategySortType currentSortType;

@property (nonatomic, readonly) NSUInteger currentAreaSelectedIndex;

- (void)show;

- (void)showWithSelectedSortType:(ParentingStrategySortType)type selectedAreaIndex:(NSUInteger)index;

- (void)dismiss;

@end
