/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：NSTimer+Blocks.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年10月19日
 */


#import "NSTimer+Blocks.h"


@implementation NSTimer (Blocks)


+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void (^)())block repeats:(BOOL)repeats
{
    void (^cpblock)() = [block copy];
    id ret = [self scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(executeSimpleBlock:) userInfo:cpblock repeats:repeats];
    return ret;
}

+(id)timerWithTimeInterval:(NSTimeInterval)timeInterval block:(void (^)())block repeats:(BOOL)repeats
{
    void (^cpblock)() = [block copy];
    id ret = [self timerWithTimeInterval:timeInterval target:self selector:@selector(executeSimpleBlock:) userInfo:cpblock repeats:repeats];
    return ret;
}

+(void)executeSimpleBlock:(NSTimer *)timer;
{
    if([timer userInfo])
    {
        void (^block)() = (void (^)())[timer userInfo];
        block();
    }
}

@end


