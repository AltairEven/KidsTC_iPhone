/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GBannersView.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：12/24/12
 */


#import <UIKit/UIKit.h>
#import "IcsonImageView.h"

@interface GBannersView : UIView

@property (nonatomic, strong)IcsonImageView *bannersImg;

- (id)duplicateView;

@end
