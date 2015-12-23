/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GFitTextBtn.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：3/29/13
 */

#import <UIKit/UIKit.h>

@interface GFitTextBtn : UIButton
//@property (retain,nonatomic) UIButton *button;
@property (strong,nonatomic) UILabel *textLab;

- (void)setTitle:(NSString *)titleStr;

@end
