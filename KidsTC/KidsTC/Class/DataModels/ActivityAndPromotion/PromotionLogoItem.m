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
        case PromotionLogoItemTypeTuan:
        {
            retImage = [UIImage imageNamed:@"promotionlogo_tuan"];
        }
            break;
        case PromotionLogoItemTypeMiao:
        {
            retImage = [UIImage imageNamed:@"promotionlogo_miao"];
        }
            break;
        default:
            break;
    }
    
    return retImage;
}

@end
