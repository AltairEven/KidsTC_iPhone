//
//  ActiveModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/18/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ActiveModel.h"

@implementation ActiveModel

- (instancetype)initWithType:(ActiveType)type AndDescription:(NSString *)description {
    self = [super init];
    if (self) {
        self.type = type;
        self.activeDescription = description;
    }
    return self;
}


- (UIImage *)image {
    UIImage *retImage = nil;
    switch (self.type) {
        case ActiveTypeGift:
        {
            retImage = [UIImage imageNamed:@"store_gift"];
        }
            break;
        case ActiveTypePreferential:
        {
            retImage = [UIImage imageNamed:@"store_preferential"];
        }
            break;
        case ActiveTypeTuan:
        {
            retImage = [UIImage imageNamed:@"service_tuan"];
        }
            break;
        case ActiveTypeMiao:
        {
            retImage = [UIImage imageNamed:@"service_miao"];
        }
            break;
        default:
            break;
    }
    
    return retImage;
}

@end
