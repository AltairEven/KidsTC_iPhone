//
//  CategoryView.h
//  KidsTC
//
//  Created by 钱烨 on 7/27/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryView;

@protocol CategoryViewDataSource <NSObject>

- (NSArray *)categoriesOfCategoryView:(CategoryView *)view;

@end

@protocol CategoryViewDelegate <NSObject>

- (void)CategoryView:(CategoryView *)view didClickedAtLevel1Index:(NSUInteger)level1Index subIndex:(NSUInteger)subIndex;

@end

@interface CategoryView : UIView

@property (nonatomic, assign) id<CategoryViewDataSource> dataSource;

@property (nonatomic, assign) id<CategoryViewDelegate> delegate;

- (void)reloadData;

@end
