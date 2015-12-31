//
//  HomeRecommendCellModel.m
//  KidsTC
//
//  Created by Altair on 12/31/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeRecommendCellModel.h"

@implementation HomeRecommendCellModel

- (instancetype)initWithRawData:(NSArray *)dataArray {
    self = [super initWithRawData:dataArray];
    if (self) {
        self.type = HomeContentCellTypeRecommend;
        cellRatio = 1;
    }
    return self;
}

- (void)parseRawData:(NSArray *)dataArray {
    [super parseRawData:dataArray];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *singleData in dataArray) {
        HomeRecommendElement *item = [[HomeRecommendElement alloc] initWithRawData:singleData];
        if (item) {
            [tempArray addObject:item];
        }
    }
    self.recommendElementsArray = [NSArray arrayWithArray:tempArray];
}

- (CGFloat)cellHeight {
    NSUInteger count = [self.recommendElementsArray count];
    if (count > 0) {
        NSUInteger left = count % 2;
        NSUInteger row = count / 2;
        if (left > 0) {
            cellHeight = (cellRatio * (SCREEN_WIDTH - 30) / 2 + 70 ) * (row + 1) + row * 10;
        } else {
            cellHeight = (cellRatio * (SCREEN_WIDTH - 30) / 2 + 70 ) * row + (row - 1) * 10;
        }
    }
    
    return cellHeight;
}

- (NSArray *)elementModelsArray {
    return [self recommendElementsArray];
}

@end


@implementation HomeRecommendElement

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        NSString *identifier = nil;
        if ([data objectForKey:@"serveId"]) {
            identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"serveId"]];
            
        }
        NSString *channelId = nil;
        if ([data objectForKey:@"channelId"]) {
            channelId = [NSString stringWithFormat:@"%@", [data objectForKey:@"channelId"]];
        }
        if ([identifier length] == 0) {
            return nil;
        }
        
        self.segueModel = [[HomeSegueModel alloc] initWithDestination:HomeSegueDestinationServiceDetail paramRawData:[NSDictionary dictionaryWithObjectsAndKeys:identifier, @"pid", channelId, @"cid", nil]];
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.title = [data objectForKey:@"serveName"];
        self.promotionPrice = [[data objectForKey:@"price"] floatValue];
        self.originalPrice = [[data objectForKey:@"originalPrice"] floatValue];
        self.saledCount = [[data objectForKey:@"sale"] integerValue];
    }
    return self;
}

@end
