//
//  ServiceOwnerStoreModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceOwnerStoreModel.h"

@implementation ServiceOwnerStoreModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"storeId"]) {
            self.storeId = [NSString stringWithFormat:@"%@", [data objectForKey:@"storeId"]];
        }
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.storeName = [data objectForKey:@"storeName"];
        self.starNumber = [[data objectForKey:@"level"] integerValue];
        self.phoneNumber = [data objectForKey:@"phone"];
        self.hotSaleCount = [[data objectForKey:@"hotCount"] integerValue];
        self.favourateCount = [[data objectForKey:@"attentNum"] integerValue];
        self.distanceDescription = [data objectForKey:@"distance"];
    }
    return self;
}

@end
