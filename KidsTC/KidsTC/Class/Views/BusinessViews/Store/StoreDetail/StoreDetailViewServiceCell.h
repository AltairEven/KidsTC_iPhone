//
//  StoreDetailViewServiceCell.h
//  KidsTC
//
//  Created by 钱烨 on 7/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceListItemModel.h"

@class StoreDetailViewServiceCell;

@protocol StoreDetailViewServiceCellDelegate <NSObject>

- (void)storeDetailViewServiceCell:(StoreDetailViewServiceCell *)cell didClickedServiceAtIndex:(NSUInteger)index;

@end

@interface StoreDetailViewServiceCell : UITableViewCell

@property (nonatomic, assign) id<StoreDetailViewServiceCellDelegate> delegate;

@property (nonatomic, assign) NSUInteger index;

- (void)configWithLeftModel:(ServiceListItemModel *)leftModel rightModel:(ServiceListItemModel *)rightModel;

+ (CGFloat)cellHeight;

@end
