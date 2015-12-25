//
//  MJRefreshBackGifFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshBackGifFooter.h"

@interface MJRefreshBackGifFooter()
{
    __unsafe_unretained UIImageView *_gifView;
}
/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;

@property (nonatomic, assign) BOOL isSingleImage;

@property (nonatomic, strong) UIImage *singleRefreshImage;

@end

@implementation MJRefreshBackGifFooter
#pragma mark - 懒加载
- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        [self addSubview:_gifView = gifView];
    }
    return _gifView;
}

- (NSMutableDictionary *)stateImages
{
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations
{
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

#pragma mark - 公共方法
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state
{
    if (images == nil) return;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (image.size.height > self.mj_h) {
        self.mj_h = image.size.height;
    }
}

- (void)setImages:(NSArray *)images forState:(MJRefreshState)state
{
    [self setImages:images duration:images.count * 0.1 forState:state];
}


- (void)setSingleRotateImage:(UIImage *)image {
    _singleRefreshImage = image;
    [self.gifView setImage:_singleRefreshImage];
    self.isSingleImage = YES;
}

#pragma mark - 实现父类的方法
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.stateImages[@(MJRefreshStateIdle)];
    if (self.state != MJRefreshStateIdle || images.count == 0) return;
    [self.gifView stopAnimating];
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.gifView.image = images[index];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.gifView.constraints.count) return;
    
    self.gifView.frame = self.bounds;
    
//    if (self.stateLabel.hidden) {
//        self.gifView.contentMode = UIViewContentModeCenter;
//    } else {
//        self.gifView.contentMode = UIViewContentModeRight;
//        self.gifView.mj_w = self.mj_w * 0.5 - 90;
//    }
    
    if (self.stateLabel.hidden) {
        self.gifView.contentMode = UIViewContentModeCenter;
    } else {
        if (self.isSingleImage) {
            self.gifView.contentMode = UIViewContentModeCenter;
            self.gifView.frame = CGRectMake(self.bounds.size.width / 8, 15, 10, 10);
        } else {
            self.gifView.contentMode = UIViewContentModeRight;
        }
        self.gifView.mj_w = self.mj_w * 0.5 - 90;
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        if (self.isSingleImage) {
            [self startAnimation];
        } else {
            NSArray *images = self.stateImages[@(state)];
            if (images.count == 0) return;
            
            self.gifView.hidden = NO;
            [self.gifView stopAnimating];
            if (images.count == 1) { // 单张图片
                self.gifView.image = [images lastObject];
            } else { // 多张图片
                self.gifView.animationImages = images;
                self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
                [self.gifView startAnimating];
            }
        }
    } else if (state == MJRefreshStateIdle) {
        if (self.isSingleImage) {
            [self stopAnimaton];
        }
        self.gifView.hidden = NO;
    } else if (state == MJRefreshStateNoMoreData) {
        self.gifView.hidden = YES;
        if (self.isSingleImage) {
            [self stopAnimaton];
        }
    }
}

#pragma mark Single Image

- (void)startAnimation
{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,0,1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.13, 0,0,1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(6.26, 0,0,1)],
                           nil];
    theAnimation.cumulative = YES;
    theAnimation.duration = 0.5;
    theAnimation.repeatCount = INTMAX_MAX;
    theAnimation.removedOnCompletion = YES;
    
    [self.gifView.layer addAnimation:theAnimation forKey:@"transform"];
    
}


- (void)stopAnimaton{
    [self.gifView.layer removeAnimationForKey:@"transform"];
}

@end
