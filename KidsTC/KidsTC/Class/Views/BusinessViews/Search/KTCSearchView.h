//
//  KTCSearchView.h
//  KidsTC
//
//  Created by 钱烨 on 7/20/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTCSearchView;

@protocol KTCSearchViewDataSource <NSObject>

- (NSArray *)hotKeysArrayForKTCSearchView:(KTCSearchView *)searchView;

- (NSArray *)historiesArrayForKTCSearchView:(KTCSearchView *)searchView;

@end

@protocol KTCSearchViewDelegate <NSObject>

- (void)didClickedCategoryButtonOnKTCSearchView:(KTCSearchView *)searchView;

- (void)KTCSearchView:(KTCSearchView *)searchView didChangedToSearchType:(KTCSearchType)type;

- (void)didClickedCancelButtonOnKTCSearchView:(KTCSearchView *)searchView;

- (void)didClickedSearchButtonOnKTCSearchView:(KTCSearchView *)searchView;

- (void)searchView:(KTCSearchView *)searchView didSelectedHotKeyAtIndex:(NSUInteger)index;

- (void)searchView:(KTCSearchView *)searchView didSelectedHistoryAtIndex:(NSUInteger)index;

- (void)didClickedClearHistoryButtonOnKTCSearchView:(KTCSearchView *)searchView;

@end

@interface KTCSearchView : UIView

@property (nonatomic, assign) id<KTCSearchViewDataSource> dataSource;
@property (nonatomic, assign) id<KTCSearchViewDelegate> delegate;

@property (nonatomic, strong) NSArray *categoryArray;

@property (nonatomic, readonly) KTCSearchType type;

- (void)startEditing;

- (void)endEditing;

- (void)reloadData;

- (NSString *)keywords;

- (void)setCurrentSearchTypeItemIndex:(NSUInteger)index;

@end
