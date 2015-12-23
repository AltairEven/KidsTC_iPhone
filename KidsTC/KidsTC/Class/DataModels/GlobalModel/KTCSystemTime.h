//
//  KTCSystemTime.h
//  KidsTC
//
//  Created by 钱烨 on 8/5/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTCSystemTime : NSObject

+ (instancetype)sharedTime;

- (void)updateSystemTime;

@end
