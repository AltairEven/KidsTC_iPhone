//
//  StoreDetailHotRecommendModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/26/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "StoreDetailHotRecommendModel.h"

@implementation StoreDetailHotRecommendModel


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
        self.saleCount = [[data objectForKey:@"tuanCount"] integerValue];
    }
    return self;
}

@end
