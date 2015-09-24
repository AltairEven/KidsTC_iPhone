//
//  ATCountDown.h
//  ICSON
//
//  Created by 钱烨 on 3/30/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATCountDown : NSObject

@property (nonatomic, assign, readonly) NSTimeInterval leftTime;

- (instancetype)initWithLeftTimeInterval:(NSTimeInterval)timeLeft;


- (void)startCountDownWithCurrentTimeLeft:(void(^)(NSTimeInterval currentTimeLeft))currentBlock;

- (void)stopCountDown;

@end
