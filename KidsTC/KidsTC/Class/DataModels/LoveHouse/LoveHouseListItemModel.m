//
//  LoveHouseListItemModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/13/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "LoveHouseListItemModel.h"

@implementation LoveHouseListItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.name = [data objectForKey:@"title"];
        self.houseDescription = [data objectForKey:@"content"];
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.distanceDescription = [data objectForKey:@"distance"];
        self.coordinate = [GToolUtil coordinateFromString:[data objectForKey:@"mapAddr"]];
    }
    return self;
}

@end
