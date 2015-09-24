/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：ShippingTypeItem.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：haoquanbai
 * 完成日期：13-2-28
 */

#import "ShippingTypeItem.h"

@implementation ShippingTimeItem

- (id)initWithRawData:(NSDictionary *)rawData
{
    if (self = [super init])
    {
        self.name = [rawData objectForKey:@"name"];
        self.shipDate = [rawData objectForKey:@"ship_date"];
        self.status = [[rawData objectForKey:@"status"] intValue];
        self.timeSpan = [[rawData objectForKey:@"time_span"] intValue];
        self.weekDay = [[rawData objectForKey:@"week_day"] intValue];
    }
    
    return self;
}


- (NSString *)description
{
    NSMutableString * description = [NSMutableString string];
    NSString *className = NSStringFromClass([self class]);
    [description appendFormat:@"%@ = {\n", className];
	[description appendFormat:@"\tname=%@\n", self.name];
    [description appendFormat:@"\tshippingDate=%@\n", self.shipDate];
    [description appendFormat:@"\ttimeSpan=%d\n", self.timeSpan];
    [description appendFormat:@"\tweekDay=%d\n", self.weekDay];
	[description appendString:@"}\n"];
    
	return description;
}

@end

@implementation UnifiedShippingTimeItem

- (id)initWithRawData:(NSDictionary *)rawData
{
	if (self = [super init])
    {
		self.name     = [rawData objectForKey:@"name"];
		self.shipDate = [rawData objectForKey:@"ship_date"];
		self.spanList = [rawData objectForKey:@"spanList"];
		self.status   = [[rawData objectForKey:@"status"] integerValue];
		self.timeSpan = [[rawData objectForKey:@"time_span"] integerValue];
		self.weekDay  = [[rawData objectForKey:@"week_day"] integerValue];		
    }
    return self;
}


- (NSString *)description
{
    NSMutableString * description = [NSMutableString string];
    NSString *className = NSStringFromClass([self class]);
    [description appendFormat:@"%@ = {\n", className];
	[description appendFormat:@"\tname=%@\n", self.name];
    [description appendFormat:@"\tshippingDate=%@\n", self.shipDate];
    [description appendFormat:@"\ttimeSpan=%d\n", self.timeSpan];
    [description appendFormat:@"\tweekDay=%d\n", self.weekDay];
    [description appendFormat:@"\tstatus=%d\n", self.status];
	[description appendFormat:@"\tspanList=%@\n", self.spanList];
	[description appendString:@"}\n"];
	return description;
}

@end

@implementation ShippingTypeItem

- (id)initWithRawData:(NSDictionary *)rawData
{
    if (self = [super init])
    {
        self.shippingTypeID = [[rawData objectForKey:@"ShippingId"] intValue];
        self.shippingTypeName = [rawData objectForKey:@"ShipTypeName"];
        id freePriceLimit = [rawData objectForKey:@"free_price_limit"];
        self.freePriceLimit = freePriceLimit == [NSNull null] ? 0 : [freePriceLimit intValue];
        id freeType = [rawData objectForKey:@"free_type"];
        self.freeType = (freeType == [NSNull null] ? 0 : [freeType intValue]);
        id shippingCost = [rawData objectForKey:@"shippingCost"];
        self.shippingCost = (shippingCost == [NSNull null] ? 0 : [shippingCost intValue]);
        id shippingPrice = [rawData objectForKey:@"shippingPrice"];
        self.shippingPrice = (shippingPrice == [NSNull null] ? 0 : [shippingPrice intValue]);
        id shippingCutPrice = [rawData objectForKey:@"shippingPriceCut"];
        self.shippingCutPrice = (shippingCutPrice == [NSNull null] ? 0 : [shippingCutPrice intValue]);
		
		
		NSArray *combineShipList = [rawData objectForKey:@"CombineShipList"];
		NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:3];
		for(NSDictionary *unifiedShipInfo in combineShipList)
		{
			UnifiedShippingTimeItem * item = [[UnifiedShippingTimeItem alloc] initWithRawData:unifiedShipInfo];
			[arrayTemp addObject:item];
		}
		self.unifiedShipTypeLists = [NSArray arrayWithArray:arrayTemp];
		if([self.unifiedShipTypeLists count] > 0)
		{
			self.selectedUnifiledShippingTimeItem = [self.unifiedShipTypeLists objectAtIndex:0];
		}
		
		
		NSMutableDictionary *tempAvalaibleShipTimeList = [NSMutableDictionary dictionaryWithCapacity:3];
		NSMutableDictionary *tempAvalaibleShipPrice = [NSMutableDictionary dictionary];
		NSDictionary * dicOfShippingTimeList = [rawData objectForKey:@"subOrder"];
		for (int i = 0; i< [[dicOfShippingTimeList allKeys] count]; i++)
		{
			NSString*key = [[dicOfShippingTimeList allKeys]objectAtIndex:i];
			NSDictionary *subOrderShipData = [dicOfShippingTimeList objectForKey:key];
			NSString *shippingPrice = [subOrderShipData objectForKey:@"shippingPrice"];
			NSDictionary *dicOfShipPrice = [NSDictionary dictionaryWithObjectsAndKeys:shippingPrice, @"shippingPrice", nil];
			[tempAvalaibleShipPrice setObject:dicOfShipPrice forKey:key];
			NSArray *timeAvaiableArr = [subOrderShipData objectForKey:@"timeAvaiable"];
			if ([timeAvaiableArr count] > 0)
			{
				NSMutableArray *tempTimeList = [NSMutableArray arrayWithCapacity:[timeAvaiableArr count]];
				for (NSDictionary *item in timeAvaiableArr)
				{
					ShippingTimeItem *timeItem = [[ShippingTimeItem alloc] initWithRawData:item];
					if (timeItem.status == 0)
					{
						[tempTimeList addObject:timeItem];
					}
				}
				
				[tempTimeList sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
					int shipDate1 = [((ShippingTimeItem *)obj1).shipDate intValue];
					int shipDate2 = [((ShippingTimeItem *)obj2).shipDate intValue];
					int timeSpan1 = ((ShippingTimeItem *)obj1).timeSpan;
					int timeSpan2 = ((ShippingTimeItem *)obj2).timeSpan;
					
					if (shipDate1 != shipDate2)
					{
						return (shipDate1 > shipDate2);
					}
					else
					{
						return (timeSpan1 > timeSpan2);
					}
				}];
				[tempAvalaibleShipTimeList setObject:tempTimeList forKey:key];
			}
            
            // jenny修改：如果不是易迅快递，显示预计配送时间
            if (self.shippingTypeID != 1)
            {
                NSDictionary *timeAvaiablePreDic = [subOrderShipData objectForKey:@"timeAvaiablePre"];
                if (timeAvaiablePreDic)
                {
                    NSArray *timeAvaiablePreArr = [timeAvaiablePreDic objectForKey:@""];
                    if (timeAvaiablePreArr)
                    {
                        NSDictionary *timeAvaiablePreItemDic = [timeAvaiablePreArr objectAtIndex:0];
                        if (timeAvaiablePreItemDic)
                        {
                            ShippingTimeItem *timeItem = [[ShippingTimeItem alloc] initWithRawData:timeAvaiablePreItemDic];
                            if (timeItem.status == 0)
                            {
                                self.timeAvaiablePre = timeItem;
                            }
                        }
                    }
                }
            }
		}
		if([[tempAvalaibleShipTimeList allKeys] count] > 0)
		{
			self.availabelPackageTimeList = [NSDictionary dictionaryWithDictionary:tempAvalaibleShipTimeList];
			NSArray *allKeys = [self.availabelPackageTimeList allKeys];
			NSMutableDictionary*mutable = [NSMutableDictionary dictionaryWithCapacity:3];
			for(NSString*key in allKeys)
			{
				NSArray *availableList = [self.availabelPackageTimeList objectForKey:key];
				if([availableList count] > 0)
				[mutable setObject:[availableList objectAtIndex:0] forKey:key];
			}
			self.selectedShippingTimeItem = [NSDictionary dictionaryWithDictionary:mutable];
		}
		if([[tempAvalaibleShipPrice allKeys] count] > 0)
		{
			self.availableShippingPrice = tempAvalaibleShipPrice;
		}
	}
    
    return self;
}


- (NSString *)getShipTypeDesc
{
	NSInteger shipPrice = self.shippingPrice - self.shippingCutPrice;
	return [NSString stringWithFormat: @"%@ (%@)", self.shippingTypeName, shipPrice > 0 ? [NSString stringWithFormat: @"运费¥%@", [GToolUtil covertPriceToString:shipPrice]] : @"免运费"];
}

- (NSString *)description
{
    NSMutableString * description = [NSMutableString string];
    NSString *className = NSStringFromClass([self class]);
    [description appendFormat:@"%@ = {\n", className];
	[description appendFormat:@"\tshippingTypeID=%d\n", self.shippingTypeID];
    [description appendFormat:@"\tshippingTypeName=%@\n", self.shippingTypeName];
    [description appendFormat:@"\tfreePriceLimit=%d\n", self.freePriceLimit];
    [description appendFormat:@"\tfreeType=%d\n", self.freeType];
    [description appendFormat:@"\tshippingCost=%d\n", self.shippingCost];
    [description appendFormat:@"\tshippingPrice=%d\n", self.shippingPrice];
    [description appendFormat:@"\tshippingCutPrice=%d\n", self.shippingCutPrice];
    [description appendFormat:@"\tavailabelTimeList=%@\n", self.availabelPackageTimeList];
	[description appendFormat:@"\tselectedItemTime=%@\n",self.selectedShippingTimeItem];
	[description appendString:@"}\n"];
    
	return description;
}

@end
