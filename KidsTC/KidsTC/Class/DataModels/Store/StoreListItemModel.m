//
//  StoreListItemModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreListItemModel.h"

@implementation StoreListItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.identifier = [data objectForKey:@"storeId"];
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.storeName = [data objectForKey:@"storeName"];
        self.starNumber = [[data objectForKey:@"level"] integerValue];
        self.distanceDescription = [data objectForKey:@"distance"];
        NSDictionary *eventsDic = [data objectForKey:@"event"];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        if ([eventsDic isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in [eventsDic allKeys]) {
                if ([key isEqualToString:@"gift"]) {
                    NSUInteger tag = [[eventsDic objectForKey:key] integerValue];
                    if (tag == 0) {
                        ActiveModel *model = [[ActiveModel alloc] initWithType:ActiveTypeGift AndDescription:@"到店有礼"];
                        [tempArray addObject:model];
                    }
                }
                if ([key isEqualToString:@"tuan"]) {
                    NSUInteger tag = [[eventsDic objectForKey:key] integerValue];
                    if (tag == 0) {
                        ActiveModel *model = [[ActiveModel alloc] initWithType:ActiveTypeTuan AndDescription:@"团购"];
                        [tempArray addObject:model];
                    }
                }
            }
            self.activities = [NSArray arrayWithArray:tempArray];
        }
    }
    return self;
}

@end
