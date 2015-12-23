//
//  StoreListViewController.h
//  KidsTC
//
//  Created by 钱烨 on 8/18/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreListViewController : GViewController

- (instancetype)initWithStoreListItemModels:(NSArray *)models;

- (instancetype)initWithSearchCondition:(KTCSearchStoreCondition *)condition;

@end
