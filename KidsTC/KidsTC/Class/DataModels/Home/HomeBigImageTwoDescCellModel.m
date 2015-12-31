//
//  HomeBigImageTwoDescCellModel.m
//  KidsTC
//
//  Created by Altair on 12/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeBigImageTwoDescCellModel.h"

@implementation HomeBigImageTwoDescCellModel

- (instancetype)initWithRawData:(NSArray *)dataArray {
    self = [super initWithRawData:dataArray];
    if (self) {
        self.type = HomeContentCellTypeBigImageTwoDesc;
    }
    return self;
}

- (void)parseRawData:(NSArray *)dataArray {
    [super parseRawData:dataArray];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dataDic in dataArray) {
        HomeBigImageTwoDescItem *cellItem = [[HomeBigImageTwoDescItem alloc] initWithHomeData:dataDic];
        if (cellItem) {
            [tempArray addObject:cellItem];
        }
    }
    self.cellItemsArray = [NSArray arrayWithArray:tempArray];
}

- (void)setRatio:(CGFloat)ratio {
    [super setRatio:ratio];
    cellHeight = cellRatio * SCREEN_WIDTH + 30;
}

- (CGFloat)cellHeight {
    return cellHeight;
}

- (NSArray *)elementModelsArray {
    return self.cellItemsArray;
}

@end


@implementation HomeBigImageTwoDescItem


- (void)parseHomeData:(NSDictionary *)data {
    [super parseHomeData:data];
    
    self.title = [NSString stringWithFormat:@"%@", [data objectForKey:@"title"]];
    if ([data objectForKey:@"subTitle"]) {
        self.subTitle = [NSString stringWithFormat:@"%@", [data objectForKey:@"subTitle"]];
    }
}


@end