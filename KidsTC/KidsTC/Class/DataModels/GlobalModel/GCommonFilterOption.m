//
//  GCommonFilterOption.m
//  iphone51buy
//
//  Created by CGS on 12-5-24.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GCommonFilterOption.h"

@implementation GCommonFilterOption
@synthesize optionId, optionName, selected;

- (id)initWithOptionId:(NSInteger)_optionId optionName:(NSString *)_optionName
{
    if (self = [super init]) {
        optionId = _optionId;
        optionName = _optionName;
        selected = NO;
    }

    return self;
}

- (id)initWithOptionId:(NSInteger)_optionId optionName:(NSString *)_optionName selected:(BOOL)_selected
{
    if (self = [super init]) {
        optionId = _optionId;
        optionName = _optionName;
        selected = _selected;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	GCommonFilterOption *copy = [[[self class] allocWithZone: zone] init];
	copy.optionId = self.optionId;
	copy.optionName = [self.optionName copy];
	copy.selected = self.selected;
    return copy;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeInteger:self.optionId forKey:@"optionId"];
	[aCoder encodeObject:self.optionName forKey:@"optionName"];
	[aCoder encodeBool:self.selected forKey:@"selected"];
}

- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super init];
    if ( nil != self )
    {
        self.optionId = [decoder decodeIntegerForKey:@"optionId"];
		self.optionName = [decoder decodeObjectForKey:@"optionName"];
		self.selected = [decoder decodeBoolForKey:@"selected"];
    }
    return self;
}

@end
