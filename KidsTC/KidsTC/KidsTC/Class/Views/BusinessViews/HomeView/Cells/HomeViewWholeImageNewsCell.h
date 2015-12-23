//
//  HomeViewWholeImageNewsCell.h
//  KidsTC
//
//  Created by 钱烨 on 9/21/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeWholeImageNewsCellModel.h"

@class HomeViewWholeImageNewsCell;

@protocol HomeViewWholeImageNewsCellDelegate <NSObject>

- (void)homeViewWholeImageNewsCell:(HomeViewWholeImageNewsCell *)newsCell didClickedAtIndex:(NSUInteger)index;

@end

@interface HomeViewWholeImageNewsCell : UITableViewCell

@property (nonatomic, assign) id<HomeViewWholeImageNewsCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithModel:(HomeWholeImageNewsCellModel *)model;

@end
