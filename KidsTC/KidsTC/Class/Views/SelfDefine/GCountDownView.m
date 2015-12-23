/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GCountDownView.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：4/2/13
 */

#import "GCountDownView.h"

@implementation GCountDownView

- (void)internalInit
{
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    _contentView.frame = self.bounds;
    [self addSubview:_contentView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self internalInit];
        
        _countDown = [[GCountDown alloc] init];
        _countDown.delegate = self;
    }
    return self;
}


- (void)setCurrentServerTime:(NSTimeInterval)curTime
{
    [self.countDown setCurrentTime:curTime];
}

- (void)setCountdownToDate:(NSDate *)date
{
    [self.countDown countDownToDate:date];
}

- (UIImage *)timerImageOfValue:(int)value
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"time_%d.png",value]];
}

- (void)setDateComponents:(NSDateComponents *)dateComponents
{
    self.hourImg1.image = [self timerImageOfValue:([dateComponents hour]/10)%10];
    self.hourImg2.image = [self timerImageOfValue:[dateComponents hour]%10];
    self.minImg1.image = [self timerImageOfValue:([dateComponents minute]/10)%10];
    self.minImg2.image = [self timerImageOfValue:[dateComponents minute]%10];;
    self.secImg1.image = [self timerImageOfValue:([dateComponents second]/10)%10];
    self.secImg2.image = [self timerImageOfValue:[dateComponents second]%10];;
}

#pragma mark - GCountDownDelegate
- (void)gCountDown:(GCountDown *)_countDown componentsUpdated:(NSDateComponents *)_dateComponents {
    [self setDateComponents:_dateComponents];
}

- (void)gCountDown:(GCountDown *)_countDown timeIsOut:(NSDateComponents *)dateComponents {
	//reset title here
    [dateComponents setDay:0];
	[dateComponents setHour:0];
	[dateComponents setMinute:0];
	[dateComponents setSecond:0];
    
    [self setDateComponents:dateComponents];
    
    
	[self.countDown stop];
    
    if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(coutDownViewDidTimeOut:)])
    {
        [self.delegate coutDownViewDidTimeOut:self];
    }
}
@end
