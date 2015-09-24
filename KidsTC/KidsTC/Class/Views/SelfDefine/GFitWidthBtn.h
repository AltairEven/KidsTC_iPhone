/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GFitWidthBtn.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：5/20/13
 */

#import <UIKit/UIKit.h>

@interface GFitWidthBtn : UIButton
@property (nonatomic)float minWidth;
@property (nonatomic)float maxWidth;

- (void)setTitle:(NSString *)titleStr;
- (void)setBackgroundImage:(UIImage *)img;
- (void)setSelectedBGImgage:(UIImage *)imgSelected;
@end
