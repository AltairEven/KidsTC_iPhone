//
//  HomeViewTwinklingElfCell.h
//  KidsTC
//
//  Created by 钱烨 on 7/22/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewTwinklingElfCell;

@protocol HomeViewTwinklingElfCellDelegate <NSObject>

- (void)twinklingElfCell:(HomeViewTwinklingElfCell *)twinklingElfCell didClickedAtIndex:(NSUInteger)index;

@end

@interface HomeViewTwinklingElfCell : UITableViewCell

@property (nonatomic, assign) id<HomeViewTwinklingElfCellDelegate> delegate;

@property (nonatomic, strong) NSArray *twinklingElfModels;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
