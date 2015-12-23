/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：PayTypeItem.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：haoquanbai
 * 完成日期：13-2-28
 */

#import "PayTypeItem.h"

@implementation PayTypeItem

- (id)initWithRawData:(NSDictionary *)rawData
{
    if (self = [super init])
    {
        self.payTypeID = [[rawData objectForKey:@"pay_type"] intValue];
        self.payTypeName = [rawData objectForKey:@"PayTypeName"];
        self.sortID = [[rawData objectForKey:@"sortId"] intValue];
    }
    
    return self;
}


- (NSString *)description
{
    NSMutableString * description = [NSMutableString string];
    NSString *className = NSStringFromClass([self class]);
    [description appendFormat:@"%@ = {\n", className];
	[description appendFormat:@"\tpayTypeID=%d\n", self.payTypeID];
    [description appendFormat:@"\tpayTypeName=%@\n", self.payTypeName];
    [description appendFormat:@"\tsortID=%d\n", self.sortID];
	[description appendString:@"}\n"];
	return description;
}

@end
