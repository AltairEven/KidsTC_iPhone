//
//  HomeViewHorizontalListCell.h
//  KidsTC
//
//  Created by 钱烨 on 8/14/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewHorizontalListCell;

@protocol HomeViewHorizontalListCellDelegate <NSObject>

- (void)homeViewHorizontalListCell:(HomeViewHorizontalListCell *)listCell didSelectedItemAtIndex:(NSUInteger)index;

@end

@interface HomeViewHorizontalListCell : UITableViewCell

@property (nonatomic, assign) id<HomeViewHorizontalListCellDelegate> delegate;

@property (nonatomic, strong) NSArray *timeQiangElementsArray;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
