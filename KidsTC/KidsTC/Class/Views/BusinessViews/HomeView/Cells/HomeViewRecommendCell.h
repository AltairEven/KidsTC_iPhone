//
//  HomeViewRecommendCell.h
//  KidsTC
//
//  Created by Altair on 12/31/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeRecommendView.h"

@class HomeViewRecommendCell;

@protocol HomeViewRecommendCellDelegate <NSObject>

- (void)homeViewRecommendCell:(HomeViewRecommendCell *)recommendCell didSelectedItemAtIndex:(NSUInteger)index;

@end

@interface HomeViewRecommendCell : UITableViewCell

@property (nonatomic, assign) id<HomeViewRecommendCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithModel:(HomeRecommendCellModel *)model;

@end
