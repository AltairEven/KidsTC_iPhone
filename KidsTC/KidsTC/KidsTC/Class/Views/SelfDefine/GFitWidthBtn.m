/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GFitWidthBtn.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：5/20/13
 */

#import "GFitWidthBtn.h"

@implementation GFitWidthBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.minWidth = 20.0;
        self.maxWidth = NSIntegerMax;
    }
    return self;
}


- (void)setBackgroundImage:(UIImage *)img
{
    img = [img stretchableImageWithLeftCapWidth: floorf(img.size.width/2) topCapHeight: floorf(img.size.height/2)];
    [self setBackgroundImage: img forState: UIControlStateNormal];
}
- (void)setSelectedBGImgage:(UIImage *)imgSelected
{
    imgSelected = [imgSelected stretchableImageWithLeftCapWidth:floorf(imgSelected.size.width/2) topCapHeight: floorf(imgSelected.size.height/2)];
    
    
    [self setBackgroundImage: imgSelected forState: UIControlStateSelected];
}
- (void)setTitle:(NSString *)titleStr
{
    [self setTitle:titleStr forState:UIControlStateNormal];
    
    CGSize size = self.bounds.size;
    size.width = NSIntegerMax;
    float needWidth = self.minWidth;
    if ([titleStr length]>0)
    {
        
        CGSize sz = [titleStr sizeWithFont:self.titleLabel.font constrainedToSize:size];
        needWidth = sz.width + 2*10.0;
    }
    
    if (needWidth < self.minWidth)
    {
        needWidth = self.minWidth;
    }
    else if(needWidth > self.maxWidth)
    {
        needWidth = self.maxWidth;
    }

    CGRect rect = self.frame;
    rect.size.width = needWidth;
    self.frame = rect;
}
@end
