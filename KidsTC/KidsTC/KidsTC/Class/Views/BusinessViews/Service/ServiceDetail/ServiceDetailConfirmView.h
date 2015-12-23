//
//  ServiceDetailConfirmView.h
//  KidsTC
//
//  Created by 钱烨 on 7/30/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreListItemModel.h"

@class ServiceDetailConfirmView;

@protocol ServiceDetailConfirmViewDelegate <NSObject>

- (void)didClickedSubmitButtonWithBuyNumber:(NSUInteger)number selectedStore:(StoreListItemModel *)store;

@end

@interface ServiceDetailConfirmView : UIView

@property (nonatomic, assign) id<ServiceDetailConfirmViewDelegate> delegate;

@property (nonatomic, assign) NSUInteger stockNumber;

@property (nonatomic, strong) NSArray *storeItemsArray;

@property (nonatomic, assign) CGFloat unitPrice;

- (void)setMinBuyCount:(NSUInteger)min maxBuyCount:(NSUInteger)max;

- (void)show;

- (void)dismiss;

@end