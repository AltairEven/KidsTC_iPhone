//
//  KTCStoreMapViewController.h
//  KidsTC
//
//  Created by Altair on 1/11/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "GViewController.h"

@class StoreListItemModel;

@interface KTCStoreMapViewController : GViewController

@property (nonatomic, strong) StoreListItemModel *selectedStore;

- (instancetype)initWithStoreItems:(NSArray<StoreListItemModel *> *)storeItems;

@end
