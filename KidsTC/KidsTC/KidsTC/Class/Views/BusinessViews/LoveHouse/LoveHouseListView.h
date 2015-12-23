//
//  LoveHouseListView.h
//  KidsTC
//
//  Created by 钱烨 on 10/13/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoveHouseListView;

@protocol LoveHouseListViewDataSource <NSObject>

- (NSArray *)itemModelsOfLoveHouseListView:(LoveHouseListView *)listView;

@end

@protocol LoveHouseListViewDelegate <NSObject>

- (void)didPullUpToLoadMoreForLoveHouseListView:(LoveHouseListView *)listView;

- (void)loveHouseListView:(LoveHouseListView *)listView didClickedGotoButtonAtIndex:(NSUInteger)index;

- (void)loveHouseListView:(LoveHouseListView *)listView didClickedNearbyButtonAtIndex:(NSUInteger)index;

@end

@interface LoveHouseListView : UIView

@property (nonatomic, assign) id<LoveHouseListViewDataSource> dataSource;

@property (nonatomic, assign) id<LoveHouseListViewDelegate> delegate;

- (void)reloadData;

- (void)startLoadMore;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore;

- (void)hideLoadMoreFooter:(BOOL)hidden;

@end
