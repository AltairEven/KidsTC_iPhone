//
//  OrderListViewCell.h
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichPriceView.h"
#import "OrderListModel.h"

@class OrderListViewCell;

@protocol OrderListCellDelegate <NSObject>

- (void)didClickedPayButtonOnOrderListViewCell:(OrderListViewCell *)cell;

- (void)didClickedCommentButtonOnOrderListViewCell:(OrderListViewCell *)cell;

- (void)didClickedReturnButtonOnOrderListViewCell:(OrderListViewCell *)cell;

@end


@interface OrderListViewCell : UITableViewCell

@property (nonatomic, assign) id<OrderListCellDelegate> delegate;

@property (nonatomic, assign) OrderStatus orderStatus;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithOrderListModel:(OrderListModel *)model atIndexPath:(NSIndexPath *)indexPath;


@end
