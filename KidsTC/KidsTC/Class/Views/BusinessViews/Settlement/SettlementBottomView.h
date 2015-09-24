//
//  SettlementBottomView.h
//  KidsTC
//
//  Created by 钱烨 on 7/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettlementBottomView;

@protocol SettlementBottomViewDelegate <NSObject>

- (void)didClickedConfirmButtonOnSettlementBottomView:(SettlementBottomView *)bottomView;

@end

@interface SettlementBottomView : UIView

@property (nonatomic, assign) id<SettlementBottomViewDelegate> delegate;

@property (nonatomic, assign) CGFloat price;

- (void)setSubmitEnable:(BOOL)enabled;

@end
