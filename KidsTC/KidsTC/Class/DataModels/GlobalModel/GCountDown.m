//
//  GCountDown.m
//  iphone51buy
//
//  Created by icson apple on 12-7-3.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GCountDown.h"

@implementation GCountDownProxy
@synthesize delegate;

- (void)startTimer
{
	if (!delegate || ![delegate respondsToSelector:@selector(timeOnAndOn)]) {
		return;
	}
	
	[self invalidate];
	timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: delegate selector: @selector(timeOnAndOn) userInfo: nil repeats: YES];
}

- (void)invalidate
{
	if (timer) {
		[timer invalidate];
		 timer = nil;
	}
}

- (void)dealloc
{
	[self invalidate];
}

@end

@implementation GCountDown
@synthesize calendarUnitFlag, delegate;

- (id)init
{
	if (self = [super init]) {
		proxy = [[GCountDownProxy alloc] init];
		[proxy setDelegate: self];
		
		//default
		calendarUnitFlag = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	}

	return self;
}

- (void)timeOnAndOn
{
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDate *now = [NSDate date];
	now = [now dateByAddingTimeInterval:timeOffset];
	
	NSDateComponents *components = [cal components:calendarUnitFlag fromDate: now toDate: toDate options:0];
	
	if (delegate) {
		if ( [now compare:toDate] == NSOrderedAscending ) {
            if ([delegate respondsToSelector:@selector(gCountDown:componentsUpdated:)]) {
                [delegate gCountDown: self componentsUpdated: components];
            }
		} else {
            if ([delegate respondsToSelector:@selector(gCountDown:timeIsOut:)]) {
                [delegate gCountDown: self timeIsOut: components];
            }
		}
	}
}

- (void) setCurrentTime:(NSInteger)curTime {
	NSTimeInterval mobileNow = [[NSDate date] timeIntervalSince1970];
	timeOffset = curTime - mobileNow;
}

- (void)countDownToDate:(NSDate *)date
{

	toDate = date;
	[self timeOnAndOn];
	[proxy startTimer];
}

- (void)stop
{
	[proxy invalidate];
}

- (void)dealloc
{
	 toDate = nil;
	[proxy invalidate];
	 proxy = nil;
}

@end
