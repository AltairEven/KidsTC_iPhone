/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GPreViewSetScrollView.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：12/24/12
 */

#import <Foundation/Foundation.h>
@protocol GPreViewSetScrollViewDelegate;

@interface GPreViewSetScrollView : UIScrollView

@end
@protocol GPreViewSetScrollViewDelegate <UIScrollViewDelegate>
- (void)scrollView:(UIScrollView *)scrollView didTouchAtContentPoint:(CGPoint) aPoint;

@end