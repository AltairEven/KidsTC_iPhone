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
        self.type = [[data objectForKey:@"type"] integerValue];
        self.name = [data objectForKey:@"name"];
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        NSArray *nearbys = [data objectForKey:@"items"];
        if ([nearbys isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            NSMutableArray *tempDes = [[NSMutableArray alloc] init];
            NSMutableArray *tempLoc = [[NSMutableArray alloc] init];
            for (NSDictionary *nearbyDic in nearbys) {
                StoreDetailNearbyItem *model = [[StoreDetailNearbyItem alloc] initWithRawData:nearbyDic];
                if (model) {
                    [tempArray addObject:model];
                    if ([model.itemDescription length] > 0) {
                        [tempDes addObject:model.itemDescription];
                    }
                    if (model.location) {
                        [tempLoc addObject:model.location];
                    }
                }
            }
            self.itemsArray = [NSArray arrayWithArray:tempArray];
            if ([tempDes count] > 0) {
                _hasInfo = YES;
                _itemDescriptions = [NSArray arrayWithArray:tempDes];
            }
            if ([tempLoc count] > 0) {
                _hasInfo = YES;
                _locations = [NSArray arrayWithArray:tempLoc];
            }
        }
    }
    return self;
}

@end


@implementation StoreDetailNearbyItem

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.itemDescription = [data objectForKey:@"prompt"];
        CLLocationCoordinate2D coord = [GToolUtil coordinateFromString:[data objectForKey:@"mapAddress"]];
        if (CLLocationCoordinate2DIsValid(coord)) {
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
            if (loc) {
                self.location = [[KTCLocation alloc] initWithLocation:loc locationDescription:self.itemDescription];
            }
        }
    }
    return self;
}

- (BOOL)hasInfo {
    BOOL bInfo = NO;
    if ([self.itemDescription length] > 0 || self.location) {
        bInfo = YES;
    }
    return bInfo;
}

@end