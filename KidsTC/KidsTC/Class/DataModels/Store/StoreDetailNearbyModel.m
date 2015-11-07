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
    if (!data) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.name = [data objectForKey:@"name"];
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
    }
    return self;
}

@end
