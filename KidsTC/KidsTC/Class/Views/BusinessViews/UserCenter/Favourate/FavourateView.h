//
//  FavourateView.h
//  KidsTC
//
//  Created by 钱烨 on 7/18/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FavourateViewSegmentTagService,
    FavourateViewSegmentTagStore,
    FavourateViewSegmentTagStrategy,
    FavourateViewSegmentTagNews
}FavourateViewSegmentTag;

@class FavourateView;

@protocol FavourateViewDataSource <NSObject>

- (NSArray *)favourateView:(FavourateView *)favourateView itemModelsForSegmentTag:(FavourateViewSegmentTag)tag;

@end

@protocol FavourateViewDelegate <NSObject>

- (void)favourateView:(FavourateView *)favourateView didChangedSegmentSelectedIndexWithTag:(FavourateViewSegmentTag)tag;

- (void)favourateView:(FavourateView *)favourateView didSelectedAtIndex:(NSUInteger)index ofTag:(FavourateViewSegmentTag)tag;

- (void)favourateView:(FavourateView *)favourateView needUpdateDataForTag:(FavourateViewSegmentTag)tag;

- (void)favourateView:(FavourateView *)favourateView needLoadMoreDataForTag:(FavourateViewSegmentTag)tag;

- (void)favourateView:(FavourateView *)favourateView didDeleteIndex:(NSUInteger)index ofTag:(FavourateViewSegmentTag)tag;

@end

@interface FavourateView : UIView

@property (nonatomic, assign) id<FavourateViewDataSource> dataSource;
@property (nonatomic, assign) id<FavourateViewDelegate> delegate;

@property (nonatomic, readonly) NSUInteger serviceListPageSize;
@property (nonatomic, readonly) NSUInteger storeListPageSize;
@property (nonatomic, readonly) NSUInteger strategyListPageSize;
@property (nonatomic, readonly) NSUInteger newsListPageSize;

@property (nonatomic, readonly) FavourateViewSegmentTag currentTag;

- (void)reloadDataForTag:(FavourateViewSegmentTag)tag;

- (void)endRefresh;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore forTag:(FavourateViewSegmentTag)tag;

- (void)hideLoadMoreFooter:(BOOL)hidden ForTag:(FavourateViewSegmentTag)tag;

@end
