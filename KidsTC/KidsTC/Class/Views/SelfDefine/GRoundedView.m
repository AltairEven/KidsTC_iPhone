/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GRoundedView.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：3/26/13
 */

#import "GRoundedView.h"

@implementation GRoundedView

- (void)initAction
{
    _cornerColor = [UIColor clearColor];
    _contentColor = [UIColor whiteColor];
    _strokeColor = [UIColor whiteColor];
    self.backgroundColor = _contentColor;
    _radius = 4.0;
    _strockWidth = 1.0;
    _viewType = 0;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initAction];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Initialization code
        [self initAction];
    }
    
    return self;
}


- (void)setViewType:(GRoundedViewType)newType
{
    if (_viewType != newType)
    {
        _viewType = newType;
        
        if (_viewType !=0)
        {
            self.backgroundColor = _cornerColor;
        }
        else
        {
            self.backgroundColor = _contentColor;
        }
        
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    if (_viewType != 0)
    {
        rect= CGRectInset(rect, _strockWidth/2.0, _strockWidth/2.0);
        // Drawing code
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //设置配色方案
        
        CGContextSetStrokeColorWithColor(context, _strokeColor.CGColor);
        CGContextSetFillColorWithColor(context, _contentColor.CGColor);
        CGContextSetLineWidth(context, self.strockWidth);
        
        CGFloat radius = _radius;
        
        CGFloat minx = CGRectGetMinX(rect), maxx = CGRectGetMaxX(rect);
        CGFloat miny = CGRectGetMinY(rect), maxy = CGRectGetMaxY(rect);
        
#if 1
        float conner = _radius;
        
//        CGFloat midx1 = minx + CGRectGetWidth(rect)/conner;
//        CGFloat midx2 = maxx - CGRectGetWidth(rect)/conner;
//        CGFloat midy1 = miny + CGRectGetHeight(rect)/conner;
//        CGFloat midy2 = maxy - CGRectGetHeight(rect)/conner;
        CGFloat midx1 = minx + conner;
        CGFloat midx2 = maxx - conner;
        CGFloat midy1 = miny + conner;
        CGFloat midy2 = maxy - conner;
        
        //       minx    midx1    midx2    maxx
        // miny    2       3         4        5
        // midy1   1                          6
        // midy2   12                          7
        // maxy    11       10        9        8
        
        // Start at 1
        CGContextMoveToPoint(context, minx, midy1);
        if (_viewType & GRoundedViewConnerLeftTop)
        {
            // Add an arc through 2 to 3
            CGContextAddArcToPoint(context, minx, miny, midx1, miny, radius);
        }
        else
        {
            // Add an line to 2
            CGContextAddLineToPoint(context, minx, miny);
        }
        
        if (_viewType & GRoundedViewConnerRightTop)
        {
            // Add an line to 4
            CGContextAddLineToPoint(context, midx2, miny);
            // Add an arc through 5 to 6
            CGContextAddArcToPoint(context, maxx, miny, maxx, midy1, radius);
        }
        else
        {
            // Add an line to 5
            CGContextAddLineToPoint(context, maxx, miny);
        }
        
        if (_viewType & GRoundedViewConnerRightBottom)
        {
            // Add an line to 7
            CGContextAddLineToPoint(context, maxx, midy2);
            // Add an arc through 8 to 9
            CGContextAddArcToPoint(context, maxx, maxy, midx2, maxy, radius);
        }
        else
        {
            // Add an line to 8
            CGContextAddLineToPoint(context, maxx, maxy);
        }
        
        if (_viewType & GRoundedViewConnerLeftBottom)
        {
            // Add an line to 10
            CGContextAddLineToPoint(context, midx1, maxy);
            // Add an arc through 11 to 12
            CGContextAddArcToPoint(context, minx, maxy, minx, midy2, radius);
        }
        else
        {
            // Add an line to 11
            CGContextAddLineToPoint(context, minx, maxy);
        }
        
        // Add an line to 1
        CGContextAddLineToPoint(context, minx, midy1);
        
#else
        
        CGFloat midx = CGRectGetMidX(rect);
        CGFloat midy = CGRectGetMidY(rect);
        // Start at 1
        CGContextMoveToPoint(context, minx, midy);
        // Add an arc through 2 to 3
        CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
        // Add an arc through 4 to 5
        CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
        // Add an arc through 6 to 7
        CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
        // Add an arc through 8 to 9
        CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
#endif//
        
        // Close the path
        CGContextClosePath(context);
        // Fill & stroke the path
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

@end
