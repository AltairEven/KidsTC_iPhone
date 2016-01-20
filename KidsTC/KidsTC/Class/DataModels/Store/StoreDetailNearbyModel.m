//
//  StoreDetailNearbyModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/27/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "StoreDetailNearbyModel.h"

@implementation StoreDetailNearbyModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.name = [data objectForKey:@"name"];
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        NSArray *nearbys = [data objectForKey:@"newFactilities"];
        if ([nearbys isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *nearbyDic in nearbys) {
                StoreDetailNearbyItem *model = [[StoreDetailNearbyItem alloc] initWithRawData:nearbyDic];
                if (model) {
                    [tempArray addObject:model];
                }
            }
            self.itemsArray = [NSArray arrayWithArray:tempArray];
        }
    }
    return self;
}

@end


@implementation StoreDetailNearbyItem

- (instancetype)initWithRawData:(NSDictionary *)data {
    return nil;
}

@end