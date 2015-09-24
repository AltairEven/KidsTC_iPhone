/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：ShakingView.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年12月26日
 */

#import "ShakingView.h"

@implementation ShakingView

@synthesize shakeBlock = _shakeBlock;

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake) 
    {
        // handle shake
        if (_shakeBlock) {
            _shakeBlock();
        }
    }
    
    if ([super respondsToSelector:@selector(motionEnded:withEvent:)]) {
        [super motionEnded:motion withEvent:event];
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
