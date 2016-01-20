//
//  StoreOwnedServiceModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/27/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "StoreOwnedServiceModel.h"

@implementation StoreOwnedServiceModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"serveId"]) {
            self.serviceId = [NSString stringWithFormat:@"%@", [data objectForKey:@"serveId"]];
        }
        if ([data objectForKey:@"channelId"]) {
            self.channelId = [NSString stringWithFormat:@"%@", [data objectForKey:@"channelId"]];
        }
        self.serviceName = [data objectForKey:@"title"];
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.price = [[data objectForKey:@"price"] floatValue];
        self.priceDescription = [data objectForKey:@"priceRuleName"];
        self.serviceDescription = [data objectForKey:@"ageGroup"];
        self.storeCount = [[data objectForKey:@"storeCount"] integerValue];
    }
    return self;
}

@end
