//
//  ServiceDetailBottomView.h
//  KidsTC
//
//  Created by 钱烨 on 7/16/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServiceDetailBottomView;

@protocol ServiceDetailBottomViewDelegate <NSObject>

- (void)didClickedCustomerServiceButtonOnServiceDetailBottomView:(ServiceDetailBottomView *)bottomView;

- (void)didClickedPhoneButtonOnServiceDetailBottomView:(ServiceDetailBottomView *)bottomView;

- (void)didClickedFavourateButtonOnServiceDetailBottomView:(ServiceDetailBottomView *)bottomView;

- (void)didClickedBuyButtonOnServiceDetailBottomView:(ServiceDetailBottomView *)bottomView;

@end

@interface ServiceDetailBottomView : UIView

@property (nonatomic, assign) id<ServiceDetailBottomViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *favourateButton;
@property (weak, nonatomic) IBOutlet UIButton *csButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

- (void)setFavourite:(BOOL)isFavourite;

- (void)setCustomerServiceButtonHidden:(BOOL)hidden;

- (void)setPhoneButtonHidden:(BOOL)hidden;

@end
