/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：NoResultHintView.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：benxi
 * 完成日期：12-11-5
 */

#import <UIKit/UIKit.h>
#import "GButton.h"


typedef enum {
	NoSearchResult = 1,
	NoCart,
	NoDelivery,
    NoVirtual,
} NoRetHintType;

@protocol NoResultHintViewDelegate <NSObject>
- (void) goHome;
@end

@interface NoResultHintView : UIView

@property (nonatomic, strong) UIImageView *hintImageView;

@property (nonatomic, strong) UILabel *hintTextLabel;

@property (nonatomic, strong) UIButton *hintEnterButton;

@property (nonatomic, unsafe_unretained) id<NoResultHintViewDelegate> noResultHintDelegate;

- (void)setType:(NoRetHintType)type andFrame:(CGRect) frame;

@end
