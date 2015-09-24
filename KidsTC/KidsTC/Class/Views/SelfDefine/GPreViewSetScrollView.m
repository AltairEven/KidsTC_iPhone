/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GPreViewSetScrollView.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：12/24/12
 */

#import "GPreViewSetScrollView.h"

@implementation GPreViewSetScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    float touchX = [[touches anyObject] locationInView:self].x;
    float touchY = [[touches anyObject] locationInView:self].y;
    CGPoint aPoint = CGPointMake(touchX, touchY);
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollView:didTouchAtContentPoint:)]) {
        [(id)self.delegate scrollView:self didTouchAtContentPoint:aPoint];
    }
    
    [super touchesBegan:touches withEvent:event];
}
@end
