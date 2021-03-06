//
//  ServiceListViewController.h
//  KidsTC
//
//  Created by 钱烨 on 8/18/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceListViewController : GViewController

- (instancetype)initWithListItemModels:(NSArray *)models;

- (instancetype)initWithSearchCondition:(KTCSearchServiceCondition *)condition;

@end
