/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GKeyboardDelegate.h
 * 文件标识：
 * 摘 要：在键盘出现，或者消失的时候，需要进行处理，tom于12年12月24号做review。
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：2012年12月24日
 */

#import <Foundation/Foundation.h>

@protocol GKeyboardDelegate <NSObject>
- (void)gKeyboardRect:(CGRect)rect animationDuration:(CGFloat)animationDuration;
@end
