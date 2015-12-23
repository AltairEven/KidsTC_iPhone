//
//  ActivityFilterView.h
//  KidsTC
//
//  Created by 钱烨 on 11/6/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define INVALID_INDEX (-1)

@class ActivityFilterView;

@protocol ActivityFilterViewDelegate <NSObject>

- (void)didClickedConfirmButtonOnActivityFilterView:(ActivityFilterView *)filterView withSelectedCategoryIndex:(NSUInteger)categoryIndex selectedAreaIndex:(NSUInteger)areaIndex;

@end

@interface ActivityFilterView : UIView

@property (nonatomic, assign) id<ActivityFilterViewDelegate> delegate;

@property (nonatomic, strong) NSArray *categoryNameArray;

@property (nonatomic, strong) NSArray *areaNameArray;

@property (nonatomic, readonly) NSInteger currentCategoryIndex;

@property (nonatomic, readonly) NSInteger currentAreaIndex;

- (void)showLoading:(BOOL)bShow;

- (void)show;

- (void)showWithSelectedCategoryIndex:(NSInteger)categoryIndex selectedAreaIndex:(NSInteger)areaIndex;

- (void)dismiss;

@end
