//
//  NewsListTagFilterView.h
//  KidsTC
//
//  Created by Altair on 11/24/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsTagItemModel.h"

@class NewsListTagFilterView;

@protocol NewsListTagFilterViewDataSource <NSObject>

- (NSArray<NewsTagTypeModel *> *)modelsForFilterView:(NewsListTagFilterView *)filterView;

@end

@protocol NewsListTagFilterViewDelegate <NSObject>

- (void)newsListTagFilterView:(NewsListTagFilterView *)filterView didSelectedNewsTag:(NewsTagItemModel *)itemModel;

@end

@interface NewsListTagFilterView : UIView

@property (nonatomic, assign) id<NewsListTagFilterViewDataSource> dataSource;

@property (nonatomic, assign) id<NewsListTagFilterViewDelegate> delegate;

- (void)reloadData;

- (void)setSelectedTagIndex:(NSUInteger)index;

@end
