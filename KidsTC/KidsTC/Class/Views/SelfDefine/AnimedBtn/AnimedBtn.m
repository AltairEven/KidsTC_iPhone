/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：AnimedBtn.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：12-11-5
 */

#import "AnimedBtn.h"

@implementation AnimedBtn
@synthesize touchDownImgArr = _touchDownImgArr;
@synthesize touchUpImgArr = _touchUpImgArr;
@synthesize animImgArr = _animImgArr;


- (void)internalInit
{
    _animImg = [[UIImageView alloc] initWithFrame:self.bounds];
    _animImg.animationDuration = .5;
    _animImg.animationRepeatCount = 1;
    [self addSubview:_animImg];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        // Initialization code
        [self internalInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        // Initialization code
        [self internalInit];
    }
    return self;
}


- (void)setTouchDownImgArr:(NSArray *)touchDownImgArr
{
    if(_touchDownImgArr != touchDownImgArr)
    {
        _touchDownImgArr = touchDownImgArr;
        
        UIImage * img = [_touchDownImgArr objectAtIndex:0];
        if (img && [img isKindOfClass:[UIImage class]]) {
            _animImg.image = img;
        }
    }
}

- (void)setTouchUpImgArr:(NSArray *)touchUpImgArr
{
    if(_touchUpImgArr != touchUpImgArr)
    {
        _touchUpImgArr = touchUpImgArr;
    }
}

- (void)setAnimImgArr:(NSArray *)aminImgArr
{
    if(_animImgArr != aminImgArr)
    {
        _animImgArr = aminImgArr;
    }
}


- (void) setAnimDuration:(NSTimeInterval)duration
{
     _animImg.animationDuration = duration;
}

- (void) playTouchDown
{
    if (_touchDownImgArr) {
        _animImg.animationImages = _touchDownImgArr;
        [_animImg startAnimating];
    }
}

- (void) playTouchUp
{
    NSArray * animArr = _touchUpImgArr;
    if (nil == animArr && _touchDownImgArr) {
        animArr = [[_touchDownImgArr reverseObjectEnumerator] allObjects];
    }
    if (animArr) {
        _animImg.animationImages = animArr;
        [_animImg startAnimating];
    }
}

- (void) playTouchDownAndUp
{
    [_animImg setAnimationDuration:.7f];
    if (_animImgArr) {
        _animImg.animationImages = _animImgArr;
        [_animImg startAnimating];
    } else if (_touchDownImgArr) {
        NSMutableArray * animArr = [NSMutableArray arrayWithArray:_touchDownImgArr];
        if (_touchUpImgArr) {
            [animArr addObjectsFromArray:_touchUpImgArr];
        } else {
            [animArr addObjectsFromArray:[[_touchDownImgArr reverseObjectEnumerator] allObjects]];
        }
        _animImg.animationImages = animArr;
        [_animImg startAnimating];
    }
}

@end
