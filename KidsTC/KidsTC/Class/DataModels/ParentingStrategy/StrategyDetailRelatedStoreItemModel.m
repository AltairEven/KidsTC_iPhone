//
//  StrategyDetailRelatedStoreItemModel.m
//  KidsTC
//
//  Created by Altair on 1/22/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "StrategyDetailRelatedStoreItemModel.h"

@implementation StrategyDetailRelatedStoreItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"storeNo"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"storeNo"]];
        }
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"image"]];
        self.storeName = [data objectForKey:@"storeName"];
        //location
        CLLocationCoordinate2D coord = [GToolUtil coordinateFromString:[data objectForKey:@"mapAddress"]];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        self.location = [[KTCLocation alloc] initWithLocation:loc locationDescription:self.storeName];
        NSString *storeAddress = [data objectForKey:@"address"];
        if ([storeAddress isKindOfClass:[NSString class]]) {
            [self.location setMoreDescription:storeAddress];
        }
    }
    return self;
}

@end
