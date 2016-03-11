//
//  FlashStageModel.m
//  KidsTC
//
//  Created by Altair on 2/29/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "FlashStageModel.h"

@implementation FlashStageModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
