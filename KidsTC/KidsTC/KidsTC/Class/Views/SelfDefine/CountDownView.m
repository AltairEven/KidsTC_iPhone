/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：CountDownView.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：haoquanbai
 * 完成日期：12-11-12
 */

#import "CountDownView.h"

static const CGFloat kWidthOfDigit = 9.0f;
static const CGFloat kHeightOfDigit = 11.0f;
static const CGFloat kWidthOfPadding = 1.0f;
static const CGFloat kWidthOfColon = 2.0f;
static const CGFloat kHeightOfColon = 5.0f;

@implementation CountDownView
@synthesize digitLabelArr = _digitLabelArr;
@synthesize countdown = _countdown;

- (id)init
{
    int numOfDigitGroup = 3;
    self = [super initWithFrame:CGRectMake(0, 0, 2*numOfDigitGroup*kWidthOfDigit+numOfDigitGroup/2*kWidthOfPadding+numOfDigitGroup/2*(kWidthOfColon+2*kWidthOfPadding), kHeightOfDigit)];
    if (self != nil) {
        self.userInteractionEnabled = NO;
        _digitLabelArr = [[NSMutableArray alloc] init];
        _countdown = [[GCountDown alloc] init];
        _countdown.delegate = self;
        
        for (int i=0; i<numOfDigitGroup*2; i++)
        {
            UILabel *digitLabel = [[UILabel alloc] initWithFrame:CGRectMake((i+1)/2*kWidthOfPadding+i/2*(2*kWidthOfPadding+kWidthOfColon)+i*kWidthOfDigit, 0, kWidthOfDigit, kHeightOfDigit)];
            digitLabel.textColor = [UIColor whiteColor];
            digitLabel.font = [UIFont systemFontOfSize:12.0f];
            [digitLabel setBackgroundColor:COLOR_COUNTDOWN_BG];
            [digitLabel setTextAlignment:NSTextAlignmentCenter];
            digitLabel.layer.cornerRadius = 1.0f;
            [self.digitLabelArr addObject:digitLabel];
            [self addSubview:digitLabel];
            if (i != 0 && i%2 == 0)
            {
                UIImageView *colonImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(digitLabel.frame)-kWidthOfPadding-kWidthOfColon, (kHeightOfDigit-kHeightOfColon)/2, kWidthOfColon, kHeightOfColon)];
                colonImgView.image = LOADIMAGE(@"countdown_sem", @"png");
                [self addSubview:colonImgView];
            }
            
        }
	}
	
	return self;
}

- (void)dealloc
{
    _countdown.delegate = nil;
    [_countdown stop];
}

- (void)setCurrentServerTime:(NSTimeInterval)curTime
{
    [self.countdown setCurrentTime:curTime];
}

- (void)setCountdownToDate:(NSDate *)date
{
    [self.countdown countDownToDate:date];
}

- (void)setDateComponents:(NSDateComponents *)dateComponents
{
    for (int i=0; i<[self.digitLabelArr count]; i++)
    {
        UILabel *digitLabel = [self.digitLabelArr objectAtIndex:i];
        NSInteger digitValue = 0;
        switch (i/2) {
            case 0: // hours
                digitValue = [dateComponents hour];
                break;
            case 1: // minutes
                digitValue = [dateComponents minute];
                break;
            case 2: // seconds
                digitValue = [dateComponents second];
                break;
            default:
                break;
        }
     
        if (i%2 == 0)
        {
            digitLabel.text = [NSString stringWithFormat:@"%ld", (long)(digitValue/10)%10];
        }
        else
        {
            digitLabel.text = [NSString stringWithFormat:@"%ld", (long)digitValue%10];
        }
    }
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
    
    for (int i=0; i<[self.digitLabelArr count]; i++)
    {
        UILabel *digitLabel = [self.digitLabelArr objectAtIndex:i];
        int digitValue = 0;
        digitLabel.text = [NSString stringWithFormat:@"%d", digitValue];
    }

    
	[self.countdown stop];
    
    if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(countDownViewTimeout:)])
    {
        [self.delegate countDownViewTimeout:self];
    }
}


@end
