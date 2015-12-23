//
//  CategoryViewCell.h
//  KidsTC
//
//  Created by 钱烨 on 7/27/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IcsonCategoryManager.h"

@class CategoryViewCell;

@protocol CategoryViewCellDelegate <NSObject>

- (void)categoryViewCell:(CategoryViewCell *)cell didClickedSubLevelAtIndex:(NSUInteger)index;

@end

@interface CategoryViewCell : UITableViewCell

@property (nonatomic, assign) id<CategoryViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *level1NameLabel;
@property (nonatomic, strong) NSArray *subcategoryNames;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithCategory:(IcsonLevel1Category *)category;

@end
