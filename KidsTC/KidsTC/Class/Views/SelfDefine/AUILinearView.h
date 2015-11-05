//
//  AUILinearView.h
//  KidsTC
//
//  Created by 钱烨 on 9/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AUILinearView;

@protocol AUILinearViewDataSource <NSObject>

- (NSInteger)numberOfCellsInAUIlinearView:(AUILinearView *)linearView;

- (UIView *)auilinearView:(AUILinearView *)linearView viewForCellAtIndex:(NSUInteger)index withMaxHeight:(CGFloat)height;

@end

@protocol AUILinearViewDelegate <NSObject>

- (void)auilinearViewDidScrolled:(AUILinearView *)linearView;

- (void)auilinearView:(AUILinearView *)linearView didSelectedCellAtIndex:(NSUInteger)index;

- (void)auilinearView:(AUILinearView *)linearView didDeselectCellAtIndex:(NSUInteger)index;

@end

@interface AUILinearView : UIView

@property (nonatomic, assign) id<AUILinearViewDataSource> dataSource;
@property (nonatomic, assign) id<AUILinearViewDelegate> delegate;

@property (nonatomic, readonly) NSUInteger cellNumber;

@property (nonatomic, strong, readonly) NSArray *viewsForLinearView;

@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, assign) CGFloat selectedCellScale; //未选中状态CELL的比例，默认

@property (nonatomic, assign) CGFloat horizontalGap;

@property (nonatomic, assign) BOOL pageingEnabled;

- (void)reloadData;

- (void)resetLayout;

@end
