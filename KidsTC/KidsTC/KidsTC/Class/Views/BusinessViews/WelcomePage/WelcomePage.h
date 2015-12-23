/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：WelcomePage.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：5/28/13
 */

#import <UIKit/UIKit.h>

@interface WelcomePage : UIView
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *textLab;
@property (nonatomic, strong)UIButton *actionBtn;

- (void)setContentImage:(UIImage *)img;
- (void)setContentText:(NSString *)text;
- (void)showActionBtn:(BOOL)show;
@end
