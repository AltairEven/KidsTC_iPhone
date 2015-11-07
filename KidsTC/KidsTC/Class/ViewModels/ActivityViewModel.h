//
//  ActivityViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/12/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "ActivityView.h"

@interface ActivityViewModel : BaseViewModel

@property (nonatomic, strong) ActivityFiltItem *currentCategoryItem;

@property (nonatomic, strong) ActivityFiltItem *currentAreaItem;

- (void)getCategoryDataWithSucceed:(void (^)(NSDictionary *data))succeed failure:(void (^)(NSError *error))failure;

- (NSArray *)resultArray;

- (void)getMoreDataWithSucceed:(void (^)(NSDictionary *data))succeed failure:(void (^)(NSError *error))failure;

@end
