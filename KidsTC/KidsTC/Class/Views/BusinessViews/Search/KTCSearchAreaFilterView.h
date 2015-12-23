//
//  KTCSearchAreaFilterView.h
//  KidsTC
//
//  Created by 钱烨 on 8/3/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTCSearchResultFilterModel.h"

@class KTCSearchAreaFilterView;

@protocol KTCSearchAreaFilterViewDelegate <NSObject>

- (void)searchAreaFilterView:(KTCSearchAreaFilterView *)filterView didSelectedAtIndex:(NSUInteger)index;

- (void)searchAreaFilterViewNeedDismiss:(KTCSearchAreaFilterView *)filterView;

@end

@interface KTCSearchAreaFilterView : UIView

@property (nonatomic, assign) id<KTCSearchAreaFilterViewDelegate> delegate;

@property (nonatomic, strong) KTCSearchResultFilterModel *filterModel;

@property (nonatomic, readonly) NSUInteger currentSelectedIndex;

//-1 no selected
- (CGFloat)showWithSelectedIndex:(NSInteger)index maxHeight:(CGFloat)maxHeight;

@end
