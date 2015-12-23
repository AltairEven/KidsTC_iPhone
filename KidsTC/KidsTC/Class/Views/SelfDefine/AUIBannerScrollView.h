//
//  AUIBannerScrollView.h
//  KidsTC
//
//  Created by 钱烨 on 7/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AUIBannerScrollView;

@protocol AUIBannerScrollViewDataSource <NSObject>

- (NSUInteger)numberOfBannersOnScrollView:(AUIBannerScrollView *)scrollView;

- (UIImageView *)bannerImageViewOnScrollView:(AUIBannerScrollView *)scrollView withViewFrame:(CGRect)frame atIndex:(NSUInteger)index;

- (CGFloat)heightForBannerScrollView:(AUIBannerScrollView *)scrollView;

@optional

//for recyclable
- (UIImage *)bannerImageForScrollView:(AUIBannerScrollView *)scrollView atIndex:(NSUInteger)index;

//for recyclable
- (NSURL *)bannerImageUrlForScrollView:(AUIBannerScrollView *)scrollView atIndex:(NSUInteger)index;

@end

@protocol AUIBannerScrollViewDelegate <NSObject>

@optional

- (void)auiBannerScrollView:(AUIBannerScrollView *)scrollView didScrolledToIndex:(NSUInteger)index;

- (void)auiBannerScrollView:(AUIBannerScrollView *)scrollView didClickedAtIndex:(NSUInteger)index;

@end

@interface AUIBannerScrollView : UIView

@property (nonatomic, assign) id<AUIBannerScrollViewDataSource> dataSource;

@property (nonatomic, assign) id<AUIBannerScrollViewDelegate> delegate;

@property (nonatomic, assign) BOOL enableClicking;

@property (nonatomic, assign) BOOL showPageIndex; //default YES

@property (nonatomic, assign) NSUInteger autoPlayDuration; //0 means no auto play, default is 0

@property (nonatomic, assign) BOOL recyclable;

- (void)reloadData;

@end
