//
//  HomeImageNewsCellModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/10/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeImageNewsCellModel.h"

@implementation HomeImageNewsCellModel

- (instancetype)initWithRawData:(NSArray *)dataArray {
    self = [super initWithRawData:dataArray];
    if (self) {
        self.type = HomeContentCellTypeImageNews;
        cellHeight = 110;
    }
    return self;
}

- (void)parseRawData:(NSArray *)dataArray {
    [super parseRawData:dataArray];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *singleData in dataArray) {
        HomeImageNewsElement *item = [[HomeImageNewsElement alloc] initWithHomeData:singleData];
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


@implementation HomeImageNewsElement

- (void)parseHomeData:(NSDictionary *)data {
    [super parseHomeData:data];
}

@end