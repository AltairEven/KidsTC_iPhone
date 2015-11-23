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
        if ([data objectForKey:@"storeId"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"storeId"]];
        }
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.storeName = [data objectForKey:@"storeName"];
        self.starNumber = [[data objectForKey:@"level"] integerValue];
        self.distanceDescription = [data objectForKey:@"distance"];
        NSDictionary *eventsDic = [data objectForKey:@"event"];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        if ([eventsDic isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in [eventsDic allKeys]) {
                if ([key isEqualToString:@"gift"]) {
                    BOOL has = [[eventsDic objectForKey:key] boolValue];
                    if (has) {
                        NSArray *gifts = [data objectForKey:@"storeGift"];
                        NSString *giftName = @"到店有礼";
                        if ([gifts isKindOfClass:[NSArray class]]) {
                            giftName = [gifts firstObject];
                        }
                        ActivityLogoItem *item = [[ActivityLogoItem alloc] initWithType:ActivityLogoItemTypeGift description:giftName];
                        [tempArray addObject:item];
                    }
                }
                if ([key isEqualToString:@"tuan"]) {
                    BOOL has = [[eventsDic objectForKey:key] boolValue];
                    if (has) {
                        ActivityLogoItem *item = [[ActivityLogoItem alloc] initWithType:ActivityLogoItemTypeGift description:@"团购"];
                        [tempArray addObject:item];
                    }
                }
            }
        }
        BOOL hasCoupon = [[data objectForKey:@"isHaveCoupon"] boolValue];
        if (hasCoupon) {
            ActivityLogoItem *item = [[ActivityLogoItem alloc] initWithType:ActivityLogoItemTypeCoupon description:nil];
            [tempArray addObject:item];
        }
        NSArray *fullCut = [data objectForKey:@"fullCut"];
        if ([fullCut isKindOfClass:[NSArray class]] && [fullCut count] > 0) {
            ActivityLogoItem *item = [[ActivityLogoItem alloc] initWithType:ActivityLogoItemTypePreferential description:[fullCut firstObject]];
            if (item) {
                [tempArray addObject:item];
            }
        }
        self.activityLogoItems = [NSArray arrayWithArray:tempArray];
        
        self.commentCount = [[data objectForKey:@"commentCount"] integerValue];
        
        self.feature = [NSString stringWithFormat:@"%@", [data objectForKey:@"feature"]];
        self.feature = @"儿童摄影";
        
        self.businessZone = [NSString stringWithFormat:@"%@", [data objectForKey:@"businessZone"]];
        self.businessZone = @"徐家汇商圈";
    }
    return self;
}

- (CGFloat)cellHeight {
    CGFloat height = 101;
    height += [self.activityLogoItems count] * 25;
    return height;
}

@end
