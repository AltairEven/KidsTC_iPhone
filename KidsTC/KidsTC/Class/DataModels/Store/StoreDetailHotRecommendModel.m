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
        self.title = [data objectForKey:@"title"];
        self.keyword = [data objectForKey:@"subTitileKeyword"];
        NSArray *array = [data objectForKey:@"products"];
        if ([array isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *singleElem in array) {
                StoreDetailHotRecommendItem *item = [[StoreDetailHotRecommendItem alloc] initWithRawData:singleElem];
                if (item) {
                    [tempArray addObject:item];
                    item.recommendDescription = self.keyword;
                }
            }
            self.recommendItems = [NSArray arrayWithArray:tempArray];
        }
    }
    return self;
}

@end


@implementation StoreDetailHotRecommendItem

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"productId"]) {
            self.serviceId = [NSString stringWithFormat:@"%@", [data objectForKey:@"productId"]];
        }
        if ([data objectForKey:@"chId"]) {
            self.channelId = [NSString stringWithFormat:@"%@", [data objectForKey:@"chId"]];
        }
        self.serviceName = [data objectForKey:@"productName"];
        self.serviceDescription = [data objectForKey:@"ageGroup"];
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.price = [[data objectForKey:@"promotionPrice"] floatValue];
        self.saleCount = [[data objectForKey:@"buyNum"] integerValue];
        self.storeCount = [[data objectForKey:@"storeCount"] integerValue];
    }
    return self;
}

@end