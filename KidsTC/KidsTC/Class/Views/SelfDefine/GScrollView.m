//
//  GScrollView.m
//  iphone51buy
//
//  Created by gene chu on 10/26/12.
//  Copyright (c) 2012 icson. All rights reserved.
//

#import "GScrollView.h"

@implementation GScrollView

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
