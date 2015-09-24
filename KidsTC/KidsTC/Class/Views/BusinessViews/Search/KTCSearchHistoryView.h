//
//  KTCSearchHistoryView.h
//  KidsTC
//
//  Created by 钱烨 on 7/20/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTCSearchHistoryView;

@protocol KTCSearchHistoryViewDataSource <NSObject>

- (NSArray *)hotKeysArrayForKTCSearchHistoryView:(KTCSearchHistoryView *)historyView;

- (NSArray *)historiesArrayForKTCSearchHistoryView:(KTCSearchHistoryView *)historyView;

@end

@protocol KTCSearchHistoryViewDelegate <NSObject>

- (void)searchHistoryView:(KTCSearchHistoryView *)historyView didSelectedHotKeyAtIndex:(NSUInteger)index;

- (void)searchHistoryView:(KTCSearchHistoryView *)historyView didSelectedHistoryAtIndex:(NSUInteger)index;

- (void)didClickedClearHistoryButton;

- (void)searchHistoryViewDidScroll:(KTCSearchHistoryView *)historyView;

@end

@interface KTCSearchHistoryView : UIView

@property (nonatomic, assign) id<KTCSearchHistoryViewDataSource> dataSource;
@property (nonatomic, assign) id<KTCSearchHistoryViewDelegate> delegate;

- (void)clearContent;

- (void)reloadData;

@end
