//
//  HomeTwoThreeFourCellModel.m
//  KidsTC
//
//  Created by Altair on 12/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeTwoThreeFourCellModel.h"

@implementation HomeTwoThreeFourCellModel

- (instancetype)initWithRawData:(NSArray *)dataArray {
    self = [super initWithRawData:dataArray];
    if (self) {
        if ([dataArray count] < 2 || [dataArray count] > 4) {
            return nil;
        }
        self.type = HomeContentCellTypeTwoThreeFour;
    }
    return self;
}

- (void)parseRawData:(NSArray *)dataArray {
    [super parseRawData:dataArray];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *singleData in dataArray) {
        HomeTwoThreeFourItem *item = [[HomeTwoThreeFourItem alloc] initWithHomeData:singleData];
        if (item) {
            [tempArray addObject:item];
        }
    }
    self.itemsArray = [NSArray arrayWithArray:tempArray];
}

- (void)setRatio:(CGFloat)ratio {
    [super setRatio:ratio];
    NSUInteger count = [self.itemsArray count];
    CGFloat hMargin = 10;
    CGFloat vMargin = 10;
    cellHeight = cellRatio * (SCREEN_WIDTH - (count + 1) * hMargin) / count  + 2 * vMargin;
}


- (CGFloat)cellHeight {
    return cellHeight;
}

- (NSArray *)elementModelsArray {
    return self.itemsArray;
}

@end


@implementation HomeTwoThreeFourItem

- (void)parseHomeData:(NSDictionary *)data {
    [super parseHomeData:data];
}

@end