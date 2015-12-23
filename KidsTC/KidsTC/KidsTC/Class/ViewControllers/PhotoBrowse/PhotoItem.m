//
//  ZoomItem.m
//  imageZoom
//
//  ICSON
//
//  Created by 肖晓春 on 15/5/12.
//  Copyright (c) 2015年 肖晓春. All rights reserved.
//

#import "PhotoItem.h"

@implementation PhotoItem

- (instancetype)initWithImageView:(UIImageView *)thumImageView
{
    if (self = [super init])
    {
        _thumImageView = thumImageView;
    }
    return self;
}
//重写get方法 获得itemFrame
- (CGRect)itemFrame
{
    /*
     * 当在init ZoomViewController遍历的过程中 再次调用itemFframe的get方法时，statusBar会隐藏 导致有20pix误差
     */
    if (self.tag > 0 && [UIApplication sharedApplication].statusBarHidden)
    {
        CGRect frame = [self.thumImageView.superview convertRect:self.thumImageView.frame toView:[[UIApplication sharedApplication] keyWindow]];
        return CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + 20, CGRectGetWidth(frame), CGRectGetHeight(frame));
    }
    else
        return [self.thumImageView.superview convertRect:self.thumImageView.frame toView:[[UIApplication sharedApplication] keyWindow]];
}

@end
