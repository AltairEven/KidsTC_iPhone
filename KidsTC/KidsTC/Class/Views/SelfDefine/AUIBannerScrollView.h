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

- (void)reloadData;

@end
