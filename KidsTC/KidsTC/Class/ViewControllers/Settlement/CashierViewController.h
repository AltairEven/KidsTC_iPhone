//
//  CashierViewController.h
//  KidsTC
//
//  Created by Altair on 1/19/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "GViewController.h"

@protocol CashierViewControllerDelegate <NSObject>

- (void)needRefreshStatusForOrderWithIdentifier:(NSString *)orderId;

@end

@interface CashierViewController : GViewController

@property (nonatomic, assign) id<CashierViewControllerDelegate> delegate;

- (instancetype)initWithOrderIdentifier:(NSString *)orderId;

@end
