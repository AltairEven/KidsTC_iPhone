//
//  HomeRecommendView.h
//  KidsTC
//
//  Created by Altair on 12/31/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeRecommendCellModel.h"

@class HomeRecommendView;

@protocol HomeRecommendViewDataSource <NSObject>

@required

- (NSInteger)recommendView:(HomeRecommendView *)view numberOfItemsInSection:(NSInteger)section;

- (HomeRecommendElement *)elementOfCellAtIndexPath:(NSIndexPath *)indexPath onRecommendView:(HomeRecommendView *)view;

@optional

- (NSInteger)numberOfSectionsInRecommendView:(HomeRecommendView *)view;

@end

@protocol HomeRecommendViewDelegate <NSObject>

- (void)recommendView:(HomeRecommendView *)view didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface HomeRecommendView : UIView

@property (nonatomic, assign) id<HomeRecommendViewDataSource> dataSource;
@property (nonatomic, assign) id<HomeRecommendViewDelegate> delegate;

@property (nonatomic, readonly) CGFloat viewHeight;

- (void)reloadData;

@end
