/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：WelcomeView.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：5/28/13
 */

#import "GScrollPageView.h"
@protocol WelcomeViewDelegate;

@interface WelcomeView : GScrollPageView
/*
 滚动背景
 */
@property (nonatomic, strong)UIScrollView *bgScrollView;
@property (nonatomic, readonly)BOOL autoScrollBG;
@property (nonatomic, weak)id<WelcomeViewDelegate> welcomeDelegate;
/*
 \brief 设置背景图片
 \param image 背景图片
            背景图片如果设置跟随页面滑动属性，需要比屏幕宽。
 */
- (void)setBgImage:(UIImage *)image;
@end


@protocol WelcomeViewDelegate <GScrollPageViewDataSource>

- (void)welcomeView:(WelcomeView *)welcomeView didShowPageIndex:(int)index;

@end