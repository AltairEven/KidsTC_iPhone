//
//  ActivityLogoItem.m
//  KidsTC
//
//  Created by Altair on 11/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ActivityLogoItem.h"

@implementation ActivityLogoItem

- (instancetype)initWithType:(ActivityLogoItemType)type description:(NSString *)description {
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
        case ActivityLogoItemTypeGift:
        {
            retImage = [UIImage imageNamed:@"activitylogo_gift"];
        }
            break;
        case ActivityLogoItemTypePreferential:
        {
            retImage = [UIImage imageNamed:@"activitylogo_preferential"];
        }
            break;
        case ActivityLogoItemTypeCoupon:
        {
            retImage = [UIImage imageNamed:@"activitylogo_coupon"];
        }
            break;
        case ActivityLogoItemTypeTuan:
        {
            retImage = [UIImage imageNamed:@"activitylogo_tuan"];
        }
            break;
        default:
            break;
    }
    
    return retImage;
}

@end
