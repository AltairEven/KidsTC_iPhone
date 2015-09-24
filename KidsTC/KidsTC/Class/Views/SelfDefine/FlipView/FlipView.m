/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：FlipView.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：12-11-5
 */

#import "FlipView.h"

static NSString* kFlipAnimationKey = @"kFlipAnimationKey";


@interface FlipView ()

- (CGFloat) defaultAnimationDuration;
- (void) animateIntoCurrentDirectionWithDuration: (CGFloat) duration;
- (void) nextValueWithoutAnimation;
- (void) updateFlipViewFrame;
- (void) flipHidden:(BOOL)hidden;

@end


@implementation FlipView
@synthesize currentDirection = _currentDirection;
@synthesize currentAnimationDuration = _currentAnimationDuration;
@synthesize delegate = _delegate;

- (void) internalInit
{
    self.backgroundColor = [UIColor clearColor];

    _curState = eFlipStateNone;
    _curState = eFlipStateNone;
    _lastState = eFlipStateNone;
    _currentDirection = eFlipDirectionDown;
    _currentAnimationDuration = 0.35;
    
    _imageViewTop = [[UIImageView alloc] init];
    [self addSubview: _imageViewTop];
    _imageViewTop.hidden = YES;
    
    _imageViewBottom = [[UIImageView alloc] init];
    [self addSubview: _imageViewBottom];
    _imageViewBottom.hidden = YES;
    
    _imageViewFlip = [[UIImageView alloc] init];
    [self addSubview: _imageViewFlip];
    _imageViewFlip.hidden = YES;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self internalInit];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self internalInit];
    }
    return self;
}

// needed to release view properly
- (void) removeFromSuperview
{
	[self stopAnimation];
	[super removeFromSuperview];
}


+ (UIImage*) imageByRenderView:(UIView*)view topHalf:(BOOL)isTopHalf
{
    CGSize size = CGSizeMake(view.bounds.size.width, view.bounds.size.height/2.0);
    CGFloat offset = 0;
    if (!isTopHalf) {
        offset = -size.height;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, offset);
    [view.layer renderInContext:context];
    CGContextTranslateCTM(context, 0, -offset);
    
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return resultingImage;
}

- (void) initCurView:(UIView*)view
{
    CGRect bounds = self.bounds;
    if (_curView != view) {
        [_curView removeFromSuperview];
        _curView = view;
    }
    if (nil == _curView) {
        _curView = [[UIView alloc] initWithFrame:bounds];
    }
    _curView.frame = bounds;
    [self addSubview:_curView];
    [self sendSubviewToBack:_curView];
    
	// setup image views

    _imageViewTop.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height/2.0);
    _imageViewBottom.frame = CGRectMake(0, bounds.size.height/2.0, bounds.size.width, bounds.size.height/2.0);
    [self flipHidden:YES];
	
	// setup default 3d transform
	[self setZDistance: bounds.size.height*3];
}


#pragma mark -
#pragma mark external access

- (void) setZDistance: (NSUInteger) zDistance
{
	// setup 3d transform
	CATransform3D aTransform = CATransform3DIdentity;
	aTransform.m34 = -1.0 / zDistance;	
	self.layer.sublayerTransform = aTransform;
}


#pragma mark -
#pragma mark animation

- (CGFloat) defaultAnimationDuration {
	return 0.35;
}

- (void) animateToView:(UIView*)view
{
	[self animateToView:view withDuration:[self defaultAnimationDuration]];
}

- (void) animateToView:(UIView*)view withDuration:(CGFloat)duration
{
    CGRect bounds = self.bounds;
    if (_nextView != view) {
        _nextView = view;
    }
    
    if (nil == _nextView) {
        _nextView = [[UIView alloc] initWithFrame:self.bounds];
    }
    _nextView.frame = bounds;
    _lastState = eFlipStateNone;
    _curState = eFlipStateFirstHalf;
    [self flipHidden:NO];
    
    [self animateIntoCurrentDirectionWithDuration:duration];
}

- (void) animateIntoCurrentDirectionWithDuration: (CGFloat)duration
{
	_currentAnimationDuration = duration;
	
	// if duration is less than 0.05, don't animate
	if (duration < 0.05) {
		// inform delegate
		if ([_delegate respondsToSelector: @selector(flipView:willChangeToView:)]) {
			[_delegate flipView: self willChangeToView:_nextView];
		}
		[NSTimer scheduledTimerWithTimeInterval: duration
										 target: self
									   selector: @selector(nextValueWithoutAnimation)
									   userInfo: nil
										repeats: NO];
		return;
	}
	
	[self updateFlipViewFrame];
	
	// setup animation
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
	animation.duration	= _currentAnimationDuration;
	animation.delegate	= self;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
    
	// exchange images & setup animation
	if (_curState == eFlipStateFirstHalf)
	{
		// setup first animation half
        if (_lastState != _curState) {
            _lastState = _curState;
            _imageViewTop.image = [FlipView imageByRenderView:_nextView topHalf:YES];
            _imageViewBottom.image = [FlipView imageByRenderView:_curView topHalf:NO];
            _imageViewFlip.image = [FlipView imageByRenderView:_curView topHalf:YES];
        }
        
		// inform delegate
		if ([_delegate respondsToSelector: @selector(flipView:willChangeToView:)]) {
			[_delegate flipView: self willChangeToView:_nextView];
		}
		
		animation.fromValue	= [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0, 1, 0, 0)];
		animation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI_2, 1, 0, 0)];
		animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
	}
	else
	{
		// setup second animation half
		_imageViewFlip.image = [FlipView imageByRenderView:_nextView topHalf:NO];
        
		animation.fromValue	= [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 1, 0, 0)];
		animation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0, 1, 0, 0)];
		animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
	}
	
	// add/start animation
	[_imageViewFlip.layer addAnimation: animation forKey: kFlipAnimationKey];
	 
	// show animated view
	_imageViewFlip.hidden = NO;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	if (!flag) {
		return;
	}
	
	if (_curState == eFlipStateFirstHalf)
	{		
		// do second animation step
        _lastState = _curState;
		_curState = eFlipStateSecondHalf;
		[self animateIntoCurrentDirectionWithDuration:_currentAnimationDuration];
	}
	else
	{
		// reset state
        _lastState = eFlipStateNone;
		_curState = eFlipStateFirstHalf;
        
		// remove old animation
		[_imageViewFlip.layer removeAnimationForKey: kFlipAnimationKey];
		
		[self nextValueWithoutAnimation];
	}
}

- (void) nextValueWithoutAnimation
{
	[self initCurView:_nextView];
	
    if ([_delegate respondsToSelector: @selector(flipView:didChangeToView:animated:)]) {
        [_delegate flipView: self didChangeToView:_nextView animated: YES];
    }
    
    _nextView = nil;
}

- (void) flipHidden:(BOOL)hidden
{
    _imageViewTop.hidden = hidden;
    _imageViewBottom.hidden = hidden;
    _imageViewFlip.hidden = hidden;
}


#pragma mark -
#pragma mark cancel animation

- (void) stopAnimation
{
	[_imageViewFlip.layer removeAllAnimations];
	[self flipHidden:YES];
}


#pragma mark -
#pragma mark helper

- (void) updateFlipViewFrame
{
	if (_curState == eFlipStateFirstHalf)
	{
		_imageViewFlip.layer.anchorPoint = CGPointMake(0.5, 1.0);
		_imageViewFlip.frame = _imageViewTop.frame;
	}
	else
	{
		_imageViewFlip.layer.anchorPoint = CGPointMake(0.5, 0.0);
		_imageViewFlip.frame = _imageViewBottom.frame;
	}
}

@end
