/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：MessageItem.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：haoquanbai
 * 完成日期：13-3-12
 */

#import "MessageItem.h"

@implementation MessageItem


- (id)initWithRawData:(NSDictionary *)rawData
{
    if (self = [super init])
    {
        self.eventType = [[rawData objectForKey:@"eventType"] intValue];
        self.msgID = [[rawData objectForKey:@"msgId"] intValue];
        self.reportTime = [[rawData objectForKey:@"reportTime"] doubleValue];
        self.status = [[rawData objectForKey:@"status"] intValue];
        NSDictionary *msgContenDic = [rawData objectForKey:@"msgJson"];
        self.msgStr = [msgContenDic objectForKey:@"msg"];
        self.productID = IDTOSTRING(msgContenDic[@"productId"]);
        self.productCharID = [msgContenDic objectForKey:@"charId"];
        self.orderID = [msgContenDic objectForKey:@"orderId"];
        self.title = [msgContenDic objectForKey:@"title"];
        self.url = [msgContenDic objectForKey:@"url"];
        self.extraInfo = [msgContenDic objectForKey:@"extra"];
        self.applyId = [[msgContenDic objectForKey:@"applyId"] integerValue];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super init];
    if ( nil != self )
    {
        self.msgStr = [decoder decodeObjectForKey:@"msgStr"];
        self.productID = [decoder decodeObjectForKey:@"productId"];
        self.extraInfo = [decoder decodeObjectForKey:@"extra"];
        self.productCharID = [decoder decodeObjectForKey:@"charId"];
        self.orderID = [decoder decodeObjectForKey:@"orderId"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.url = [decoder decodeObjectForKey:@"url"];
        self.applyId = [decoder decodeIntegerForKey:@"applyId"];
        self.reportTime = [decoder decodeDoubleForKey:@"reportTime"];
        self.status = (MessageStatus)[decoder decodeIntegerForKey:@"status"];
        self.msgID = [decoder decodeIntegerForKey:@"msgId"];
        self.eventType = (BizEventType)[decoder decodeIntegerForKey:@"eventType"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:_msgStr forKey:@"msgStr"];
    [encoder encodeObject:_productID forKey:@"productId"];
    [encoder encodeObject:_extraInfo forKey:@"extra"];
    [encoder encodeObject:_productCharID forKey:@"charId"];
    [encoder encodeObject:_orderID forKey:@"orderId"];
    [encoder encodeObject:_title forKey:@"title"];
    [encoder encodeObject:_url forKey:@"url"];
    [encoder encodeInteger:_applyId forKey:@"applyId"];
    [encoder encodeDouble:_reportTime forKey:@"reportTime"];
    [encoder encodeInteger:_status forKey:@"status"];
    [encoder encodeInteger:_msgID forKey:@"msgId"];
    [encoder encodeInteger:_eventType forKey:@"eventType"];
}

- (NSString *)description
{
    NSMutableString * description = [NSMutableString string];
    NSString *className = NSStringFromClass([self class]);
    [description appendFormat:@"%@ = {\n", className];
	[description appendFormat:@"\tproductID=%@\n", self.productID];
	[description appendFormat:@"\textraInfo=%@\n", self.extraInfo];
	[description appendFormat:@"\tproductCharID=%@\n", self.productCharID];
    [description appendFormat:@"\torderID=%@\n", self.orderID];
	[description appendFormat:@"\ttitle=%@\n", self.title];
    [description appendFormat:@"\turl=%@\n", self.url];
    [description appendFormat:@"\tapplyId=%ld\n", (long)self.applyId];
    [description appendFormat:@"\treportTime=%f\n", self.reportTime];
    [description appendFormat:@"\tstatus=%d\n", self.status];
    [description appendFormat:@"\tmsgID=%ld\n", (long)self.msgID];
    [description appendFormat:@"\teventType=%d\n", self.eventType];
	[description appendString:@"}\n"];
    
	return description;
}

@end
