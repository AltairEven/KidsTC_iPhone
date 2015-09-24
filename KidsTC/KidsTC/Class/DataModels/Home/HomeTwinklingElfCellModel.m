//
//  HomeTwinklingElfCellModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/22/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeTwinklingElfCellModel.h"

@implementation HomeTwinklingElfCellModel

- (instancetype)initWithRawData:(NSArray *)dataArray {
    self = [super initWithRawData:dataArray];
    if (self) {
        self.type = HomeContentCellTypeTwinklingElf;
    }
    return self;
}

- (void)parseRawData:(NSArray *)dataArray {
    [super parseRawData:dataArray];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *singleData in dataArray) {
        HomeTwinklingElf *item = [[HomeTwinklingElf alloc] initWithHomeData:singleData];
        if (item) {
            [tempArray addObject:item];
        }
    }
    self.twinklingElvesArray = [NSArray arrayWithArray:tempArray];
}


- (CGFloat)cellHeight {
    NSUInteger count = [self.twinklingElvesArray count];
    CGFloat elfHeight = SCREEN_WIDTH / 4 + 15;
    if (count > 0) {
        NSUInteger left = count % 4;
        if (left > 0) {
            cellHeight = elfHeight * ((count / 4) + 1);
        } else {
            cellHeight = elfHeight * count / 4;
        }
    }
    return cellHeight;
}

@end
