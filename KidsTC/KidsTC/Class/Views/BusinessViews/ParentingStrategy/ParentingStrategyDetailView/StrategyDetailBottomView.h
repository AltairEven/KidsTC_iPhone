//
//  StrategyDetailBottomView.h
//  KidsTC
//
//  Created by Altair on 1/22/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StrategyDetailBottomView;

@protocol StrategyDetailBottomViewDelegate <NSObject>

- (void)didClickedLeftButtonOnStrategyDetailBottomView:(StrategyDetailBottomView *)bottomView;

- (void)didClickedRightButtonOnStrategyDetailBottomView:(StrategyDetailBottomView *)bottomView;

@end

@interface StrategyDetailBottomView : UIView

@property (nonatomic, assign) id<StrategyDetailBottomViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

- (void)hideLeftTag:(BOOL)hideLeft rightTag:(BOOL)hideRight;

@end
