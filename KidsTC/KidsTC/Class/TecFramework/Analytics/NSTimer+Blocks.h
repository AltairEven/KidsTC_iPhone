/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：NSTimer+Blocks.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年10月19日
 */


#import <Foundation/Foundation.h>


@interface NSTimer (Blocks)

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void (^)())block repeats:(BOOL)repeats;
+(id)timerWithTimeInterval:(NSTimeInterval)timeInterval block:(void (^)())block repeats:(BOOL)repeats;

@end

