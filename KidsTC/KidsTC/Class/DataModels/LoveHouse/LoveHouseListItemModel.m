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
//        self.name = [data objectForKey:@"title"];
//        self.houseDescription = [data objectForKey:@"content"];
//        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
//        self.distanceDescription = [data objectForKey:@"distance"];
//        self.coordinate = [GToolUtil coordinateFromString:[data objectForKey:@"mapAddr"]];
        
        self.name = @"爱心妈咪小屋";
        self.houseDescription = @"爱心妈咪小屋爱心妈咪小屋爱心妈咪小屋爱心妈咪小屋爱心妈咪小屋爱心妈咪小屋爱心妈咪小屋爱心妈咪小屋爱心妈咪小屋爱心妈咪小屋爱心妈咪小屋爱心妈咪小屋爱心妈咪小屋";
        self.imageUrl = [NSURL URLWithString:@"http://img.sqkids.com:7500/v1/img/T1KtETBjVT1RCvBVdK.jpg"];
        self.distanceDescription = @"<500米";
        self.coordinate = [GToolUtil coordinateFromString:@"34.50000,121.43333"];
    }
    return self;
}

@end
