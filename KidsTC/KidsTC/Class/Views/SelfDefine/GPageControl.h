/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GPageControl.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：haoquanbai
 * 完成日期：12-12-6
 */

#import <UIKit/UIKit.h>

@interface GPageControl : UIPageControl

@property (nonatomic, strong) UIImage *activeImage;
@property (nonatomic, strong) UIImage *inactiveImage;

- (id)initWithFrame:(CGRect)frame activeImg:(UIImage *)acticeImg andInacticeImg:(UIImage *)inactiveImg;

@end
