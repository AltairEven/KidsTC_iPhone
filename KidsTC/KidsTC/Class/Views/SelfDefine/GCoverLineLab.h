/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GCoverLineLab.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：1/7/13
 */

#import <UIKit/UIKit.h>

@interface GCoverLineLab : UILabel
{
    BOOL _isShowLine;
}
@property (strong, nonatomic, readonly)CALayer * lineLayer;

- (void)showLine:(BOOL)show;
@end
