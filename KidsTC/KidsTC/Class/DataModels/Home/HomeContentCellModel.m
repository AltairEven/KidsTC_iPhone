//
//  HomeContentCellModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeContentCellModel.h"

@implementation HomeContentCellModel

- (instancetype)initWithRawData:(NSArray *)dataArray {
    self = [super init];
    if (self) {
        if (!dataArray || [dataArray count] == 0 || ![dataArray isKindOfClass:[NSArray class]]) {
            return nil;
        }
        [self parseRawData:dataArray];
    }
    return self;
}

- (void)parseRawData:(NSArray *)dataArray {
    
}

- (CGFloat)cellHeight {
    return 0;
}

@end
