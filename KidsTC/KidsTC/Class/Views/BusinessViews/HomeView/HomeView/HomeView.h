//
//  HomeView.h
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@class HomeView;

@protocol HomeViewDataSource <NSObject>

- (NSArray *)homeSectionModesArrayForHomeView:(HomeView *)homeView;

- (NSArray *)customerRecommendModesArrayForHomeView:(HomeView *)homeView;

@end

@protocol HomeViewDelegate <NSObject>

- (void)didClickedCategoryButtonOnHomeView:(HomeView *)homeView;

- (void)didClickedInputFieldOnHomeView:(HomeView *)homeView;

- (void)didClickedMessageButtonOnHomeView:(HomeView *)homeView;

- (void)homeViewDidPulledDownToRefresh:(HomeView *)homeView;

- (void)homeViewDidPulledUpToloadMore:(HomeView *)homeView;

- (void)homeView:(HomeView *)homeView didSelectedAtIndexPath:(NSIndexPath *)indexPath;

- (void)homeView:(HomeView *)homeView didSelectedAtIndexPath:(NSIndexPath *)indexPath subIndex:(NSUInteger)subIndex;

@optional

- (void)homeView:(HomeView *)homeView didScrolled:(CGPoint)offset;

- (void)homeView:(HomeView *)homeView didScrolledIntoVisionWithSectionGroupIndex:(NSUInteger)index;

- (void)homeView:(HomeView *)homeView didEndDeDidEndDecelerating:(BOOL)downDirection;

@end

@interface HomeView : UIView

@property (nonatomic, assign) id<HomeViewDataSource> dataSource;
@property (nonatomic, assign) id<HomeViewDelegate> delegate;

- (void)reloadData;

- (void)startRefresh;

- (void)endRefresh;

- (void)startLoadMore;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore;

- (void)hideLoadMoreFooter:(BOOL)hidden;

- (void)scrollHomeViewToSectionGroupIndex:(NSUInteger)index;

@end
