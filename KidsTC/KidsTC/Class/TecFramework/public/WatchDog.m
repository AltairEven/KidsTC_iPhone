//
//  WatchDog.m
//  iPhone51Buy
//
//  Created by alex tao on 1/15/14.
//  Copyright (c) 2014 icson. All rights reserved.
//

#import "WatchDog.h"
#import "Shortcut.h"

#define KEY_WATCH_DOG_LAUNCH_SUCCESS            @"keyWatchDogLaunchSucc"

@interface WatchDog ()

@property (nonatomic, strong) NSString *    watchFolder;
@property (nonatomic, strong) NSTimer *     timer;

@end


@implementation WatchDog

static WatchDog *sharedInstance = nil;

+ (WatchDog*) sharedInstance
{
    if (nil == sharedInstance) {
        sharedInstance = [[WatchDog alloc] init];
    }
	return sharedInstance;
}

- (id) init
{
    self = [super init];
    if (self) {
        [self startWatch];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) startWatch
{
    NSNumber * successFlag = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_WATCH_DOG_LAUNCH_SUCCESS];
    if (nil == successFlag || [successFlag boolValue]) {
        _isLaunchSuccessLastTime = YES;
    } else {
        _isLaunchSuccessLastTime = NO;
        [self cleanWatchFolder];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@false forKey:KEY_WATCH_DOG_LAUNCH_SUCCESS];
    
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(launchSuccessed) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void) appEnterForeground
{
    [self startWatch];
}

- (void) appEnterBackground
{
    [self launchSuccessed];
}

- (void) launchSuccessed
{
    [self.timer invalidate];
    self.timer = nil;
    
    [[NSUserDefaults standardUserDefaults] setObject:@true forKey:KEY_WATCH_DOG_LAUNCH_SUCCESS];
}

- (NSString*) clearWhenCrashFolder
{
    if (nil == _watchFolder) {
        //_watchFolder = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0] stringByAppendingPathComponent:@"wg/"];
        //edit by Altair 20141112, move to Library/Caches
        _watchFolder = FILE_CACHE_PATH(@"wg/");
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:_watchFolder])
	{
		NSError *err = nil;
		if (![[NSFileManager defaultManager] createDirectoryAtPath:_watchFolder
		                               withIntermediateDirectories:YES attributes:nil error:&err])
		{
			NSLog(@"Watch Dog: Error creating logsDirectory: %@", err);
            return nil;
		}
	}
    
    return _watchFolder;
}

- (void) cleanWatchFolder
{
    NSDirectoryEnumerator * dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:[self clearWhenCrashFolder]];
    NSString * path = nil;
    while ((path = [dirEnum nextObject]) != nil) {
        NSString * fullPath = [[self clearWhenCrashFolder] stringByAppendingPathComponent:path];
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
    }
}

- (NSString*) pathForClearWhenCrashFolder:(NSString*)name {
    return [[self clearWhenCrashFolder] stringByAppendingPathComponent:name];
}


@end
