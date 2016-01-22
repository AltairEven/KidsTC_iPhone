//
//  ServiceMoreDetailHotSalesItemModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/15/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceMoreDetailHotSalesItemModel.h"

@implementation ServiceMoreDetailHotSalesItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        if ([data objectForKey:@"productSysNo"]) {
            self.serviceId = [NSString stringWithFormat:@"%@", [data objectForKey:@"productSysNo"]];
        }
        if ([data objectForKey:@"channelId"]) {
            self.channelId = [NSString stringWithFormat:@"%@", [data objectForKey:@"channelId"]];
        }
        self.serviceName = [data objectForKey:@"productName"];
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imageUrl"]];
        self.price = [[data objectForKey:@"price"] floatValue];
        self.originalPrice = [[data objectForKey:@"storePrice"] floatValue];
        self.priceDescription = [data objectForKey:@"priceDescription"];
        self.storeCount = [[data objectForKey:@"storeCount"] integerValue];
        self.serviceDescription = [data objectForKey:@"promotionText"];
        self.ageDescription = [data objectForKey:@"ageDes"];
        self.saleCount = [[data objectForKey:@"saleCount"] integerValue];
    }
    return self;
}

@end
