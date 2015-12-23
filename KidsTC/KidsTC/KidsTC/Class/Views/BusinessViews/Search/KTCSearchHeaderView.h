//
//  KTCSearchHeaderView.h
//  KidsTC
//
//  Created by 钱烨 on 7/20/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTCSearchHeaderView;

@protocol KTCSearchHeaderViewDelegate <NSObject>

- (void)didClickedCategoryButtonOnKTCSearchHeaderView:(KTCSearchHeaderView *)headerView;

- (void)didClickedCancelButtonOnKTCSearchHeaderView:(KTCSearchHeaderView *)headerView;

- (void)didClickedSearchButtonOnKTCSearchHeaderView:(KTCSearchHeaderView *)headerView;

- (void)didStartEditingOnKTCSearchHeaderView:(KTCSearchHeaderView *)headerView;

@end

@interface KTCSearchHeaderView : UIView

@property (nonatomic, assign) id<KTCSearchHeaderViewDelegate> delegate;

@property (nonatomic, readonly) NSString *keywords;

- (void)setCategoryName:(NSString *)categoryName withPlaceholder:(NSString *)placeholder;

- (void)startEditing;

- (void)endEditing;

@end
