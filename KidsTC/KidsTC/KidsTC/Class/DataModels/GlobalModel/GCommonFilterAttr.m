//
//  GCommonFilterAttr.m
//  iphone51buy
//
//  Created by CGS on 12-5-24.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GCommonFilterAttr.h"

@implementation GCommonFilterAttr
@synthesize attrId, attrName, optionList;

-(id)initWithAttrId:(NSInteger)_attrId attrName:(NSString *) _attrName
{
    if (self = [super init]) {
        attrId = _attrId;
        attrName = _attrName;
        optionList = nil;
    }
    
    return self;
}

-(id)initWithAttrId:(NSInteger)_attrId attrName:(NSString *) _attrName optionList:(NSArray *)_optionList
{
    if (self = [super init]) {
        attrId = _attrId;
        attrName = _attrName;
        optionList = _optionList;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	GCommonFilterAttr *copy = [[[self class] allocWithZone:zone] init];
	copy.attrId = self.attrId;
	copy.attrName = [self.attrName copy];
	NSMutableArray*tempArr = [[NSMutableArray alloc] initWithArray:self.optionList copyItems:YES];
	copy.optionList = [NSArray arrayWithArray:tempArr];
    return copy;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeInteger:self.attrId forKey:@"attrId"];
	[aCoder encodeObject:self.attrName forKey:@"attrName"];
	[aCoder encodeObject:self.optionList forKey:@"optionList"];
}

- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super init];
    if ( nil != self )
    {
        self.attrId = [decoder decodeIntegerForKey:@"attrId"];
		self.attrName = [decoder decodeObjectForKey:@"attrName"];
		self.optionList = [decoder decodeObjectForKey:@"optionList"];
    }
    return self;
}

@end
