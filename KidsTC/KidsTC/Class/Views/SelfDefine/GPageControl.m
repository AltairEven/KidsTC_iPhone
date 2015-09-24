/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GPageControl.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：haoquanbai
 * 完成日期：12-12-6
 */

#import "GPageControl.h"

@implementation GPageControl

- (id)initWithFrame:(CGRect)frame activeImg:(UIImage *)acticeImg andInacticeImg:(UIImage *)inactiveImg
{
    if (self = [super initWithFrame:frame])
    {
        self.activeImage = acticeImg;
        self.inactiveImage = inactiveImg;
    }

    return self;
}

- (void)updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if ([dot isKindOfClass:[UIImageView class]]) {
            if (i == self.currentPage)
            {
                dot.image = self.activeImage;
            }
            else
            {
                dot.image = self.inactiveImage;
            }
        }
        
    }
}

- (void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}


@end
