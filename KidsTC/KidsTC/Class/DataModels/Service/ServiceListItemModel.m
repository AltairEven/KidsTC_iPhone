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
        self.status = (ServiceStatus)[[data objectForKey:@"status"] integerValue];
        self.serviceName = [data objectForKey:@"serveName"];
        self.starNumber = [[data objectForKey:@"level"] integerValue];
        self.promotionPrice = [[data objectForKey:@"price"] floatValue];
        self.saledCount = [[data objectForKey:@"sale"] integerValue];
        
        BOOL supportGQT = [[data objectForKey:@"isGqt"] boolValue];
        BOOL supportSST = [[data objectForKey:@"isSst"] boolValue];
        BOOL supportBft = [[data objectForKey:@"isBft"] boolValue];
        
        //保险
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        if (supportGQT) {
            Insurance *gqt = [[Insurance alloc] initWithType:InsuranceTypeRefundOutOfDate description:@"过期退"];
            [tempArray addObject:gqt];
        }
        if (supportSST) {
            Insurance *sst = [[Insurance alloc] initWithType:InsuranceTypeRefundAnyTime description:@"随时退"];
            [tempArray addObject:sst];
        }
        if (supportBft) {
            Insurance *bft = [[Insurance alloc] initWithType:InsuranceTypeRefundPartially description:@"部分退"];
            [tempArray addObject:bft];
        }
        self.supportedInsurance = [NSArray arrayWithArray:tempArray];
        //promotion
        BOOL hasCoupon = [[data objectForKey:@"isHaveCoupon"] boolValue];
        if (hasCoupon) {
            PromotionLogoItem *item = [[PromotionLogoItem alloc] initWithType:PromotionLogoItemTypeCoupon description:nil];
            if (item) {
                self.promotionLogoItems = [NSArray arrayWithObject:item];
            }
        }
        //activity
        NSArray *fullCut = [data objectForKey:@"fullCut"];
        if ([fullCut isKindOfClass:[NSArray class]] && [fullCut count] > 0) {
            ActivityLogoItem *item = [[ActivityLogoItem alloc] initWithType:ActivityLogoItemTypeDiscount description:[fullCut firstObject]];
            if (item) {
                self.activityLogoItems = [NSArray arrayWithObject:item];
            }
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
