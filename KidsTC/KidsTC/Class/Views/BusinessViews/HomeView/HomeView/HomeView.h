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

- (HomeModel *)homeModelForHomeView:(HomeView *)homeView;

- (HomeModel *)customerRecommendModelForHomeView:(HomeView *)homeView;

@end

@protocol HomeViewDelegate <NSObject>

- (void)didClickedCategoryButtonOnHomeView:(HomeView *)homeView;

- (void)didClickedInputFieldOnHomeView:(HomeView *)homeView;

- (void)didClickedRoleButtonOnHomeView:(HomeView *)homeView;

- (void)homeViewDidPulledDownToRefresh:(HomeView *)homeView;

- (void)homeViewDidPulledUpToloadMore:(HomeView *)homeView;

- (void)homeView:(HomeView *)homeView didClickedAtCoordinate:(HomeClickCoordinate)coordinate;

@optional

- (void)homeView:(HomeView *)homeView didScrolled:(CGPoint)offset;

- (void)homeView:(HomeView *)homeView didScrolledIntoVisionWithFloorIndex:(NSUInteger)index;

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

- (void)scrollHomeViewToFloorIndex:(NSUInteger)index;

- (void)resetTopRoleWithImage:(UIImage *)image;

@end
