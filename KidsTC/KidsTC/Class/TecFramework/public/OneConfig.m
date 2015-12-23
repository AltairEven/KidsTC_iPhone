//
//  OneConfig.m
//  iPhone51Buy
//
//  Created by alex tao on 2/18/13.
//  Copyright (c) 2013 icson. All rights reserved.
//

#import "OneConfig.h"

@implementation OneConfig


- (id) initWithName:(NSString*)name andConfig:(NSMutableDictionary*)config
{
    self = [super init];
    if (self) {
        self.name = name;
        self.configDict = config;
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super init];
    if ( nil != self )
    {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.expireDate = [decoder decodeObjectForKey:@"expireDate"];
        self.latestDate = [decoder decodeObjectForKey:@"latestDate"];
        self.configDict = [decoder decodeObjectForKey:@"configDict"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_expireDate forKey:@"expireDate"];
    [encoder encodeObject:_latestDate forKey:@"latestDate"];
    [encoder encodeObject:_configDict forKey:@"configDict"];
}

- (id)copyWithZone:(NSZone *)zone
{
    OneConfig *entry = [[[self class] allocWithZone:zone] init];
    entry.name = [_name copy];
    entry.expireDate = [_expireDate copy];
    entry.latestDate = [_latestDate copy];
    entry.configDict = [_configDict copy];
    return entry;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.configDict];
}

- (id) configForKey:(NSString*)key
{
    return [_configDict objectForKey:key];
}


@end
