//
//  PromotionLogoItem.m
//  KidsTC
//
//  Created by Altair on 11/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "PromotionLogoItem.h"

@implementation PromotionLogoItem

- (instancetype)initWithType:(PromotionLogoItemType)type description:(NSString *)description {
    self = [super init];
    if (self) {
        self.type = type;
        self.itemDescription = description;
    }
    return self;
}


- (UIImage *)image {
    UIImage *retImage = nil;
    switch (self.type) {
        case PromotionLogoItemTypeCoupon:
        {
            retImage = [UIImage imageNamed:@"promotionlogo_coupon"];
        }
            break;
        default:
            break;
    }
    
    return retImage;
}

@end
