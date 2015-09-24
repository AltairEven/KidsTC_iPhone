//
//  StoreTuanModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreTuanModel.h"

@implementation StoreTuanModel


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
        self.tuanName = [data objectForKey:@"title"];
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.price = [[data objectForKey:@"price"] floatValue];
        self.tuanCount = [[data objectForKey:@"tuanCount"] integerValue];
    }
    return self;
}

@end
