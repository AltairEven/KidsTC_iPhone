/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GBigADView.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：12/24/12
 */


/*
 巨无霸广告
 */

#import "GScrollPageView.h"


@interface GBigADView : GScrollPageView
{
    NSArray *_adData;
    NSTimer *_scrollTimer;
    BOOL _asc;
    BOOL _scrollLock;
    BOOL _touchLock;
    BOOL _animatedLock;
}
@property (strong, nonatomic)UIImageView * bgImgView;
- (void)startAutoScorll;
- (void)stopAutoScorll;
@end

