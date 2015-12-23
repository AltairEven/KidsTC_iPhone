/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GCountDownView.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：4/2/13
 */

#import <UIKit/UIKit.h>
#import "GCountDown.h"

@protocol GCountDownViewDelegate;
@interface GCountDownView : UIView<GCountDownDelegate>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *hourImg1;
@property (strong, nonatomic) IBOutlet UIImageView *hourImg2;
@property (strong, nonatomic) IBOutlet UIImageView *minImg1;
@property (strong, nonatomic) IBOutlet UIImageView *minImg2;
@property (strong, nonatomic) IBOutlet UIImageView *secImg1;
@property (strong, nonatomic) IBOutlet UIImageView *secImg2;

@property (strong, nonatomic) GCountDown *countDown;
@property (weak, nonatomic) id<GCountDownViewDelegate> delegate;

- (void)setCurrentServerTime:(NSTimeInterval)curTime;

- (void)setCountdownToDate:(NSDate *)date;
@end

@protocol GCountDownViewDelegate <NSObject>

- (void)coutDownViewDidTimeOut:(GCountDownView *)countDownView;

@end
