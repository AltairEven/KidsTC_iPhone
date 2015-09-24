//
//  WatchDog.h
//  iPhone51Buy
//
//  Created by alex tao on 1/15/14.
//  Copyright (c) 2014 icson. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WATCH_DOG_ON                     [WatchDog sharedInstance];
#define IS_LAST_LAUNCH_SAFE              [WatchDog sharedInstance].isLaunchSuccessLastTime
#define WG_FOLDER_PATH(name)             [[WatchDog sharedInstance] pathForClearWhenCrashFolder:(name)]

@interface WatchDog : NSObject

@property (nonatomic, readonly) BOOL                  isLaunchSuccessLastTime;

+ (WatchDog*) sharedInstance;

- (NSString*) pathForClearWhenCrashFolder:(NSString*)name;         // this folder will clear when app crashed during launching (7 seconds)

@end
