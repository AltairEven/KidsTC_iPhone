//
//  HomeViewThreeImageNewsCell.h
//  KidsTC
//
//  Created by 钱烨 on 9/21/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeThreeImageNewsCellModel.h"

@class HomeViewThreeImageNewsCell;

@protocol HomeViewThreeImageNewsCellDelegate <NSObject>

- (void)homeViewThreeImageNewsCell:(HomeViewThreeImageNewsCell *)cell didClickedAtIndex:(NSUInteger)index;

@end

@interface HomeViewThreeImageNewsCell : UITableViewCell

@property (nonatomic, assign) id<HomeViewThreeImageNewsCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithModel:(HomeThreeImageNewsCellModel *)model;

@end
