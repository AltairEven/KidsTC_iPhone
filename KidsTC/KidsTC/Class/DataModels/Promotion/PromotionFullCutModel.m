//
//  PromotionFullCutModel.m
//  KidsTC
//
//  Created by 钱烨 on 9/7/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "PromotionFullCutModel.h"

@implementation PromotionFullCutModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    self = [super initWithRawData:data];
    if (self) {
        if ([data objectForKey:@"promotionId"]) {
            self.promotionId = [NSString stringWithFormat:@"%@", [data objectForKey:@"promotionId"]];
        }
        self.promotionDescription = [data objectForKey:@"fullcutdesc"];
        self.fullAmount = [[data objectForKey:@"fiftyamt"] floatValue];
        self.cutAmount = [[data objectForKey:@"promotionamt"] floatValue];
    }
    return self;
}

@end
