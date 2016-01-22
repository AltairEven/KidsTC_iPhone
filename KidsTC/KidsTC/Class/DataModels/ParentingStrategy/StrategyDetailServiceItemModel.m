//
//  StrategyDetailServiceItemModel.m
//  KidsTC
//
//  Created by Altair on 1/22/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "StrategyDetailServiceItemModel.h"

@implementation StrategyDetailServiceItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"productNo"]) {
            self.serviceId = [NSString stringWithFormat:@"%@", [data objectForKey:@"productNo"]];
        }
        if ([data objectForKey:@"channelId"]) {
            self.channelId = [NSString stringWithFormat:@"%@", [data objectForKey:@"channelId"]];
        }
        self.serviceName = [data objectForKey:@"productName"];
        self.serviceDescription = [data objectForKey:@"ageGroup"];
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imageUrl"]];
        self.price = [[data objectForKey:@"promotionPrice"] floatValue];
        self.saleCount = [[data objectForKey:@"buyNum"] integerValue];
        self.storeCount = [[data objectForKey:@"storeCount"] integerValue];
    }
    return self;
}

@end
