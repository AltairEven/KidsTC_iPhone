//
//  StoreDetailHotRecommendCell.h
//  KidsTC
//
//  Created by 钱烨 on 10/26/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDetailHotRecommendModel.h"

@interface StoreDetailHotRecommendCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithModel:(StoreDetailHotRecommendModel *)model;

+ (CGFloat)cellHeight;

@end
