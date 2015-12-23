/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GRoundedView.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：3/26/13
 */


/*
 圆角的View
 */
#import <UIKit/UIKit.h>
typedef enum {
    GRoundedViewConnerNone = 0,
    GRoundedViewConnerLeftTop = 1,
    GRoundedViewConnerRightTop = 1<<1,
    GRoundedViewConnerLeftBottom = 1<<2,
    GRoundedViewConnerRightBottom = 1<<3
}GRoundedViewType;

@interface GRoundedView : UIView
@property (nonatomic, strong)UIColor *contentColor;
@property (nonatomic, strong)UIColor *cornerColor;
@property (nonatomic, strong)UIColor *strokeColor;
@property (nonatomic)float radius;
@property (nonatomic)float strockWidth;
@property (nonatomic)GRoundedViewType viewType;

@end
