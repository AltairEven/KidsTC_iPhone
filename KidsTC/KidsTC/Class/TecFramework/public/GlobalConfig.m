//
//  GlobalConfig.m
//  iPhone51Buy
//
//  Created by alex tao on 2/18/13.
//  Copyright (c) 2013 icson. All rights reserved.
//

#import "GlobalConfig.h"
#import "OneConfig.h"

@interface GlobalConfig ()

- (void) loadDefaultForKey:(NSDictionary*)key;
- (void) loadDefaultConfig;

@end

////////////////////////////////////////////////////////////////////////////////

@implementation GlobalConfig

static GlobalConfig *sharedInstance = nil;

+ (GlobalConfig*) sharedInstance
{
    if (nil == sharedInstance) {
        sharedInstance = [[GlobalConfig alloc] init];
    }
	return sharedInstance;
}

- (id) init
{
    self = [super init];
    if (self) {
        _allConfig = [[NSMutableDictionary alloc] initWithCapacity:8];
        [self loadDefaultConfig];
    }
    return self;
}


- (void) loadDefaultConfig
{
    NSMutableDictionary * defaultConfig = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"globalDefault" ofType:@"plist"]];
    
    [_allConfig removeAllObjects];
    
    [defaultConfig enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        OneConfig * oneConfig = [[OneConfig alloc] initWithName:key andConfig:obj];
        [_allConfig setObject:oneConfig forKey:key];
    }];
    //NSLog(@"asdf = %@", _allConfig);
}

- (id) configForKey:(NSString*)key andSubkey:(NSString*)subkey
{
    OneConfig * config = [_allConfig objectForKey:key];
    return [config configForKey:subkey];
}

- (void) loadDefaultForKey:(NSDictionary*)key
{
    
}

@end
