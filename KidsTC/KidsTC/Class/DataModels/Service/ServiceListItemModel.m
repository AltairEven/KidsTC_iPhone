//
//  ServiceListItemModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/11/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceListItemModel.h"

@implementation ServiceListItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"serveId"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"serveId"]];
        }
        if ([data objectForKey:@"channelId"]) {
            self.channelId = [NSString stringWithFormat:@"%@", [data objectForKey:@"channelId"]];
        }
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.serviceName = [data objectForKey:@"serveName"];
        self.starNumber = [[data objectForKey:@"level"] integerValue];
        self.promotionPrice = [[data objectForKey:@"price"] floatValue];
        self.saledCount = [[data objectForKey:@"sale"] integerValue];
    }
    return self;
}

@end
