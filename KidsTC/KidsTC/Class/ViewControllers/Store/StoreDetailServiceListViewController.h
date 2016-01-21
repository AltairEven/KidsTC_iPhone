//
//  StoreDetailServiceListViewController.h
//  KidsTC
//
//  Created by Altair on 1/21/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "GViewController.h"

@class StoreOwnedServiceModel;

@interface StoreDetailServiceListViewController : GViewController

- (instancetype)initWithListItemModels:(NSArray<StoreOwnedServiceModel *> *)models;

@end
