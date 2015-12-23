/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：MultiRollingView.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：12-11-5
 */

#import <UIKit/UIKit.h>
#import "RollingView.h"
#import "RollConfig.h"

@protocol MultiRollingViewDelegate;

@interface MultiRollingView : UIView  <UIAccelerometerDelegate, RollingViewDelegate> {
    
    BOOL                _isPreset;
    UIView *            _rollContainer;
    UIImageView *       _bgImageView;
    
}

@property (nonatomic, weak) id<MultiRollingViewDelegate> delegate;

@property (nonatomic, strong) NSArray * presetIdGroups;

- (void)spinRandom;

- (void)spinPreset:(PrizeType)prizeType;
//- (void)spinPreset:(BOOL)ifHit;


- (void)keepSpinning;

- (BOOL)isAnimating;

- (void)removeAllRollingViews;

- (void)setBackgroundImage:(UIImage*)img;
- (BOOL)isEqualToPreset:(NSArray*)ids;

@end


@protocol MultiRollingViewDelegate

- (void)multiRollingView:(MultiRollingView *)controller didSelectIds:(NSArray *)ids;
- (void)multiRollingView:(MultiRollingView *)controller didStopWithSlotIndex:(NSInteger)slotIndex andCurPresetArr:(NSArray *)presetArr;

@end