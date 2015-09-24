/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：MaskWindow.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年10月09日
 */

#import "MaskWindow.h"


@implementation MaskWindow

- (void) drawRect:(CGRect) rect
{
    // Render the radial gradient behind the alertview
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat locations[3] = { 0.0f, 0.5f, 1.0f };
    CGFloat components[12] = { 1.0f, 1.0f, 1.0f, 0.5f, 0.0f, 0.0f, 0.0f, 0.5f, 0.0f, 0.0f, 0.0f, 1.0f };
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef backgroundGradient = CGGradientCreateWithColorComponents(colorspace, components, locations, sizeof(components)/(sizeof(components[0])*4));
    CGColorSpaceRelease(colorspace);
    
    CGContextDrawRadialGradient(UIGraphicsGetCurrentContext(), 
                                backgroundGradient, 
                                CGPointMake(width * 0.5f, height * 0.5f),
                                0,
                                CGPointMake(width * 0.5f, height * 0.5f),
                                MIN(width, height),
                                0);
    
    CGGradientRelease(backgroundGradient);
}

@end
