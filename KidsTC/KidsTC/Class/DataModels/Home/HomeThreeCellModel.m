//
//  HomeThreeCellModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/22/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeThreeCellModel.h"

@implementation HomeThreeCellModel

- (instancetype)initWithRawData:(NSArray *)dataArray {
    self = [super initWithRawData:dataArray];
    if (self) {
        if ([dataArray count] < 3) {
            return nil;
        }
        self.type = HomeContentCellTypeThree;
    }
    return self;
}

- (void)parseRawData:(NSArray *)dataArray {
    [super parseRawData:dataArray];
    self.firstElement = [[HomeThreePictureElement alloc] initWithHomeData:[dataArray objectAtIndex:0]];
    self.secondeElement = [[HomeThreePictureElement alloc] initWithHomeData:[dataArray objectAtIndex:1]];
    self.thirdElement = [[HomeThreePictureElement alloc] initWithHomeData:[dataArray objectAtIndex:2]];
}


- (void)setRatio:(CGFloat)ratio {
    [super setRatio:ratio];
}

- (CGFloat)cellHeight {
    CGFloat width = (SCREEN_WIDTH - 30) / 2;
    cellHeight = cellRatio * width + 10;
    return cellHeight;
}

- (NSArray *)elementModelsArray {
    return [NSArray arrayWithObjects:self.firstElement, self.secondeElement, self.thirdElement, nil];
}

@end


@implementation HomeThreePictureElement

@end