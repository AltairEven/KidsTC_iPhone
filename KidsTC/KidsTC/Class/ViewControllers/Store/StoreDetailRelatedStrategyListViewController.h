//
//  StoreDetailRelatedStrategyListViewController.h
//  KidsTC
//
//  Created by Altair on 1/21/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "GViewController.h"

@class StoreRelatedStrategyModel;

@interface StoreDetailRelatedStrategyListViewController : GViewController

- (instancetype)initWithListItemModels:(NSArray<StoreRelatedStrategyModel *> *)models;

@end
