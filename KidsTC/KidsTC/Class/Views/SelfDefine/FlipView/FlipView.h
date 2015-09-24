/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：FlipView.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：12-11-5
 */

#import <QuartzCore/QuartzCore.h>

typedef enum
{
    eFlipStateNone,
	eFlipStateFirstHalf,
	eFlipStateSecondHalf
} eFlipState;

typedef enum
{
	eFlipDirectionUp,
	eFlipDirectionDown
} eFlipDirection;

@protocol FlipViewDelegate;

@interface FlipView : UIView {
    
	UIImageView*    _imageViewTop;
	UIImageView*    _imageViewBottom;
	UIImageView*    _imageViewFlip;
	
	eFlipState      _curState;
    eFlipState      _lastState;
    
    UIView *        _curView;
    UIView *        _nextView;
    
}

@property (nonatomic, weak) id<FlipViewDelegate> delegate;
@property (nonatomic, readonly) eFlipDirection currentDirection;    // not work right know
@property (nonatomic, readonly) CGFloat currentAnimationDuration;

- (void) initCurView:(UIView*)view;

- (void) setZDistance: (NSUInteger) zDistance;

// basic animation
- (void) animateToView:(UIView*)view;
- (void) animateToView:(UIView*)view withDuration:(CGFloat)duration;

// cancel all animations
- (void) stopAnimation;

@end


#pragma mark -
#pragma mark delegate


@protocol FlipViewDelegate <NSObject>

@optional
- (void) flipView:(FlipView*)flipView willChangeToView:(UIView*)view;
- (void) flipView:(FlipView*)flipView didChangeToView:(UIView*)view animated: (BOOL) animated;

@end;