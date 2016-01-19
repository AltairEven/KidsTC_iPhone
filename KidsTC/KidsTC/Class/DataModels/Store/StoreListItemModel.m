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
        //promotion
        BOOL hasCoupon = [[data objectForKey:@"isHaveCoupon"] boolValue];
        if (hasCoupon) {
            PromotionLogoItem *item = [[PromotionLogoItem alloc] initWithType:PromotionLogoItemTypeCoupon description:nil];
            if (item) {
                self.promotionLogoItems = [NSArray arrayWithObject:item];
            }
        }
        
        //activity
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        NSArray *gifts = [data objectForKey:@"storeGift"];
        NSString *giftName = @"";
        if ([gifts isKindOfClass:[NSArray class]]) {
            giftName = [gifts firstObject];
        }
        if ([giftName length] > 0) {
            ActivityLogoItem *item = [[ActivityLogoItem alloc] initWithType:ActivityLogoItemTypeGift description:giftName];
            [tempArray addObject:item];
        }
        NSArray *fullCut = [data objectForKey:@"fullCut"];
        if ([fullCut isKindOfClass:[NSArray class]] && [fullCut count] > 0) {
            ActivityLogoItem *item = [[ActivityLogoItem alloc] initWithType:ActivityLogoItemTypeDiscount description:[fullCut firstObject]];
            if (item) {
                [tempArray addObject:item];
            }
        }
        NSArray *discount = [data objectForKey:@"storeDiscount"];
        if ([discount isKindOfClass:[NSArray class]] && [discount count] > 0) {
            ActivityLogoItem *item = [[ActivityLogoItem alloc] initWithType:ActivityLogoItemTypePreferential description:[discount firstObject]];
            if (item) {
                [tempArray addObject:item];
            }
        }
        
        self.activityLogoItems = [NSArray arrayWithArray:tempArray];
        
        //comment
        self.commentCount = [[data objectForKey:@"commentCount"] integerValue];
        
        if ([data objectForKey:@"feature"]) {
            self.feature = [NSString stringWithFormat:@"%@", [data objectForKey:@"feature"]];
        }
        if ([data objectForKey:@"businessZone"]) {
            self.businessZone = [NSString stringWithFormat:@"%@", [data objectForKey:@"businessZone"]];
        }
        if ([data objectForKey:@"phone"]) {
            self.phoneNumber = [NSString stringWithFormat:@"%@", [data objectForKey:@"phone"]];
        }
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

- (CGFloat)cellHeight {
    CGFloat height = 101;
    height += [self.activityLogoItems count] * 25;
    return height;
}

@end
