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
    if (type == ActivityLogoItemTypeUnknow) {
        return nil;
    }
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
        case ActivityLogoItemTypeDiscount:
        {
            retImage = [UIImage imageNamed:@"activitylogo_discount"];
        }
            break;
        case ActivityLogoItemTypePreferential:
        {
            retImage = [UIImage imageNamed:@"activitylogo_preferential"];
        }
            break;        default:
            break;
    }
    
    return retImage;
}

@end
