//
//  GCountDown.h
//  iphone51buy
//
//  Created by icson apple on 12-7-3.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCountDown;
@protocol GCountDownDelegate <NSObject>
- (void)gCountDown:(GCountDown *)_countDown componentsUpdated:(NSDateComponents *)_dateComponents;
- (void)gCountDown:(GCountDown *)_countDown timeIsOut:(NSDateComponents *)_dateComponents;
@end

@interface GCountDownProxy : NSObject {
	NSTimer *timer;
}

@property (weak, nonatomic) id delegate;
@end

@interface GCountDown : NSObject {
	NSTimeInterval timeOffset;
	NSDate *toDate;
	GCountDownProxy *proxy;
}

@property (nonatomic) NSUInteger calendarUnitFlag;
@property (weak, nonatomic) id<GCountDownDelegate> delegate;

- (void)setCurrentTime:(NSInteger)curTime;
- (void)countDownToDate:(NSDate *)date;
- (void)stop;
@end
