//
//  HeaderRefreshView.m
//  ICSON
//
//  Created by 钱烨 on 4/23/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "HeaderRefreshView.h"

#define HEAD_MOST_TOP (22)

@interface HeaderRefreshView ()

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UIImageView *shadowImageView;
@property (assign, nonatomic) CGFloat headMostBottom;
@property (assign, nonatomic) CGFloat animationAreaHeight;

@property (nonatomic, strong) dispatch_source_t countdownTimer;


- (void)initSubViews;

- (void)resetFrames;

@end

@implementation HeaderRefreshView

- (instancetype)init {
    self = [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    if (self) {
        self.duration = 1.5;//默认
        [self initSubViews];
    }
    return self;
}


- (void)initSubViews {
    CGFloat centerX = self.frame.size.width / 2;
    CGSize headSize = CGSizeMake(40, 40);
    CGSize shadowSize = CGSizeMake(8, 8);
    CGFloat headYOrigin = HEAD_MOST_TOP;
    CGFloat shadowYOrigin = self.frame.size.height - 2 - shadowSize.height;
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(centerX - headSize.width / 2, headYOrigin, headSize.width, headSize.height)];
    [self.headImageView setImage:[UIImage imageNamed:@"pull_down_activity_0"]];
    self.shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(centerX - shadowSize.width / 2, shadowYOrigin, shadowSize.width, shadowSize.height)];
    [self.shadowImageView setImage:[UIImage imageNamed:@"pull_down_shadow"]];
    
    self.headMostBottom = shadowYOrigin - 5;
    self.animationAreaHeight = self.headMostBottom - self.headImageView.center.y;
    
    [self addSubview:self.headImageView];
    [self addSubview:self.shadowImageView];
}


- (void)resetFrames {
    self.headImageView.center = CGPointMake(CGRectGetMidX(self.bounds), HEAD_MOST_TOP);
    CGFloat centerX = self.frame.size.width / 2;
    CGSize shadowSize = CGSizeMake(8, 8);
    CGFloat shadowYOrigin = self.frame.size.height - 2 - shadowSize.height;
    [self.shadowImageView setFrame:CGRectMake(centerX - shadowSize.width / 2, shadowYOrigin, shadowSize.width, shadowSize.height)];
}

- (void)startAnimation {
    [self resetFrames];
    //头部动画
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.countdownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(self.countdownTimer, DISPATCH_TIME_NOW, self.duration * 50 * NSEC_PER_MSEC, 0 * NSEC_PER_SEC);
    
    __weak HeaderRefreshView *weakSelf = self;
    __block CGFloat centerY = HEAD_MOST_TOP;
    CGFloat centerX = CGRectGetMidX(self.bounds);
    __block CGFloat moveStep = 1;
    __block CGFloat offset = 0;
    __block BOOL isDown = YES;
    __block CGFloat shadowXOrigin = self.shadowImageView.frame.origin.x;
    __block CGFloat shadowWidth = 8;
    dispatch_source_set_event_handler(self.countdownTimer, ^{
        if (isDown) {
            centerY += moveStep;
            moveStep += 0.098;
            dispatch_async(dispatch_get_main_queue(), ^{
                shadowXOrigin -= moveStep / 3;
                if (shadowXOrigin <= (centerX - 20)) {
                    shadowXOrigin = centerX - 20;
                }
                shadowWidth = (centerX - shadowXOrigin) * 2;
                [weakSelf.shadowImageView setFrame:CGRectMake(shadowXOrigin, self.shadowImageView.frame.origin.y, shadowWidth, 8)];
            });
        } else {
            centerY -= moveStep;
            moveStep -= 0.098;
            dispatch_async(dispatch_get_main_queue(), ^{
                shadowXOrigin += moveStep / 3;
                if (shadowXOrigin >= (centerX - 4)) {
                    shadowXOrigin = centerX - 4;
                }
                shadowWidth = (centerX - shadowXOrigin) * 2;
                [weakSelf.shadowImageView setFrame:CGRectMake(shadowXOrigin, self.shadowImageView.frame.origin.y, shadowWidth, 8)];
            });
        }
        offset = centerY - HEAD_MOST_TOP;
        if (offset >= weakSelf.animationAreaHeight) {
            isDown = NO;
            
        }
        if (offset <= 0) {
            isDown = YES;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.headImageView.center = CGPointMake(centerX, centerY);
            if (isDown) {
                [weakSelf.headImageView setImage:[UIImage imageNamed:@"pull_down_activity_0"]];
            } else {
                [weakSelf.headImageView setImage:[UIImage imageNamed:@"pull_down_activity_1"]];
            }
        });
    });
    dispatch_resume(self.countdownTimer);
}


- (void)stopAnimation {
    if (self.countdownTimer) {
        if (!dispatch_source_testcancel(self.countdownTimer)) {
            //尚未取消，先关闭定时器
            dispatch_source_cancel(self.countdownTimer);
        }
        self.countdownTimer = nil;
    }
    [self resetFrames];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
