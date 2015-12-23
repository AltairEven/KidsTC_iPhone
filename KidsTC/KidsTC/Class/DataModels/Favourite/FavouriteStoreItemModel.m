//
//  FavouriteStoreItemModel.m
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "FavouriteStoreItemModel.h"

@implementation FavouriteStoreItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"storeId"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"storeId"]];
        }
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgurl"]];
        self.name = [data objectForKey:@"storeName"];
        self.starNumber = [[data objectForKey:@"level"] integerValue];
        self.distanceDescription = [data objectForKey:@"distance"];
    }
    return self;
}

@end