/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：CountDownView.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：haoquanbai
 * 完成日期：12-11-12
 */

#import <UIKit/UIKit.h>
#import "GCountDown.h"
@protocol CountDownViewDelegate;

@interface CountDownView : UIView <GCountDownDelegate>
@property (nonatomic, strong) NSMutableArray *digitLabelArr;
@property (nonatomic, strong) GCountDown *countdown;
@property (nonatomic, weak) id<CountDownViewDelegate> delegate;

- (void)setCurrentServerTime:(NSTimeInterval)curTime;
- (void)setCountdownToDate:(NSDate *)date;
- (void)setDateComponents:(NSDateComponents *)dateComponents;

@end

@protocol CountDownViewDelegate <NSObject>
- (void)countDownViewTimeout:(CountDownView *)countDownView;

@end