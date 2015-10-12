//
//  HomeHorizontalListCellModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/14/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeHorizontalListCellModel.h"

@implementation HomeHorizontalListCellModel

- (instancetype)initWithRawData:(NSArray *)dataArray {
    self = [super initWithRawData:dataArray];
    if (self) {
        self.type = HomeContentCellTypeHorizontalList;
        cellHeight = 120;
    }
    return self;
}

- (void)parseRawData:(NSArray *)dataArray {
    [super parseRawData:dataArray];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *singleData in dataArray) {
        HomeHorizontalListElement *item = [[HomeHorizontalListElement alloc] initWithHomeData:singleData];
        if (item) {
            [tempArray addObject:item];
        }
    }
    self.elementsArray = [NSArray arrayWithArray:tempArray];
}


- (CGFloat)cellHeight {
    return cellHeight;
}

- (NSArray *)elementModelsArray {
    return self.elementsArray;
}

@end

@implementation HomeHorizontalListElement

- (void)parseHomeData:(NSDictionary *)data {
    [super parseHomeData:data];
    
    //标题
    self.price = [[data objectForKey:@"price"] floatValue];
}

@end
