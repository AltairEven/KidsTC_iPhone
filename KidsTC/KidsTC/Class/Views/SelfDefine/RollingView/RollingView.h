/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：RollingView.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：12-11-5
 */


#import <UIKit/UIKit.h>
#import "RollingCell.h"

@protocol RollingViewDelegate;

@interface RollingView : UIView <UITableViewDelegate, UITableViewDataSource> {
    
    CGFloat             _cellHeight;
    
    NSUInteger			_spinMax;
	NSUInteger			_spinCount;
    
    UIImageView *       _bgImageView;
    CGFloat             _stepDuration;
    
}

@property (nonatomic, strong) UITableView *     tableView;

@property (nonatomic, strong) NSArray *         rollInfos;
@property NSUInteger                            selectedIdx;

@property BOOL isSpinning;
@property BOOL isAnimating;

@property (nonatomic, weak) id<RollingViewDelegate>   delegate;

- (id)initWithFrame:(CGRect)frame andInfos:(NSArray *)infos;
- (void)spinToRandom;
- (void)spinToId:(NSInteger)idx repeatCnt:(NSUInteger)repeat;
- (void)keepSpinning;
- (void)keepSpinningWithStepDuration:(NSTimeInterval)duration;

- (void)setBgImage:(UIImage*)img;
- (NSInteger)getRamdonId;

@end


@protocol RollingViewDelegate <NSObject>

- (void)rollingViewDidSpin:(RollingView *)controller;

@required
- (void)rollingView:(RollingView *)dial didSnapToIdx:(NSInteger)idx;

@end