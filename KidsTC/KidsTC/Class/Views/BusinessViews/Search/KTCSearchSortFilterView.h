//
//  KTCSearchSortFilterView.h
//  KidsTC
//
//  Created by 钱烨 on 8/3/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTCSearchResultFilterModel.h"

@class KTCSearchSortFilterView;

@protocol KTCSearchSortFilterViewDelegate <NSObject>

- (void)searchSortFilterView:(KTCSearchSortFilterView *)filterView didSelectedAtIndex:(NSUInteger)index;

- (void)searchSortFilterViewNeedDismiss:(KTCSearchSortFilterView *)filterView;

@end

@interface KTCSearchSortFilterView : UIView

@property (nonatomic, assign) id<KTCSearchSortFilterViewDelegate> delegate;

@property (nonatomic, strong) KTCSearchResultFilterModel *filterModel;

@property (nonatomic, readonly) NSUInteger currentSelectedIndex;

//-1 no selected
- (CGFloat)showWithSelectedIndex:(NSInteger)index maxHeight:(CGFloat)maxHeight;

@end
