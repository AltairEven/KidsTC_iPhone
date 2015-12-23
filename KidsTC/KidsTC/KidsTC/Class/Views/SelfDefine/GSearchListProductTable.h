//
//  GSearchListProductTable.h
//  iphone
//
//  Created by icson apple on 12-3-14.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchListViewCell.h"

@class GSearchListProductTable;
@protocol GSearchListProductTableDelegate <NSObject>

- (NSInteger)currentPageForGSearchListProductTable:(GSearchListProductTable *)gSearchListProductTable;
- (NSInteger)pageCountForGSearchListProductTable:(GSearchListProductTable *)gSearchListProductTable;
- (NSArray *)productListForGSearchListProductTable:(GSearchListProductTable *)gSearchListProductTable;
- (void)nextPageForGSearchListProductTable:(GSearchListProductTable *)gSearchListProductTable;
- (void)gSearchListProductTable: (GSearchListProductTable *)gSearchListProductTable selectedRow:(NSUInteger)row;

@end

@interface GSearchListProductTable : UITableView<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic, readonly) UITableViewCell *loadmoreCell;
@property (weak, nonatomic) id<GSearchListProductTableDelegate> controllerDelegate;

@end
