/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：ICPopTipView.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：5/28/13
 */

#import <UIKit/UIKit.h>

typedef enum {
	PointDirectionUp = 0,
	PointDirectionDown
} PointDirection;

typedef enum {
    ICPopTipAnimationSlide = 0,
    ICPopTipAnimationPop
} ICPopTipAnimation;


@protocol ICPopTipViewDelegate;


@interface ICPopTipView : UIView {
	UIColor					*backgroundColor;
	id<ICPopTipViewDelegate>	__weak delegate;
	NSString				*message;
	id						targetObject;
	UIColor					*textColor;
	UIFont					*textFont;
    ICPopTipAnimation       animation;

	@private
	CGSize					bubbleSize;
	CGFloat					cornerRadius;
	BOOL					highlight;
	CGFloat					sidePadding;
	CGFloat					topMargin;
	PointDirection			pointDirection;
	CGFloat					pointerSize;
	CGPoint					targetPoint;
}

@property (nonatomic, strong)			UIColor					*backgroundColor;
@property (nonatomic, weak)		id<ICPopTipViewDelegate>	delegate;
@property (nonatomic, assign)			BOOL					disableTapToDismiss;
@property (nonatomic, strong)			NSString				*message;
@property (nonatomic, strong)           UIView	                *customView;
@property (nonatomic, strong, readonly)	id						targetObject;
@property (nonatomic, strong)			UIColor					*textColor;
@property (nonatomic, strong)			UIFont					*textFont;
@property (nonatomic, assign)			UITextAlignment			textAlignment;
@property (nonatomic, assign)           ICPopTipAnimation       animation;
@property (nonatomic, assign)           CGFloat                 maxWidth;
@property (nonatomic, assign)           float                   hideDuration;
/* Contents can be either a message or a UIView */
- (id)initWithMessage:(NSString *)messageToShow;
- (id)initWithCustomView:(UIView *)aView;

- (void)presentPointingAtView:(UIView *)targetView inView:(UIView *)containerView animated:(BOOL)animated;
- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;

- (PointDirection) getPointDirection;

@end


@protocol ICPopTipViewDelegate <NSObject>
- (void)popTipViewWasDismissedByUser:(ICPopTipView *)popTipView;
@end
