//
//  ParentingStrategyDetailModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/8/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ParentingStrategyDetailModel.h"

@implementation ParentingStrategyDetailModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.mainImageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.title = [data objectForKey:@"title"];
        NSArray *cellDataArray = [data objectForKey:@"step"];
        if ([cellDataArray isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *cellData in cellDataArray) {
                ParentingStrategyDetailCellModel *model = [[ParentingStrategyDetailCellModel alloc] initWithRawData:cellData];
                if (model) {
                    [tempArray addObject:model];
                }
            }
            self.cellModels = [NSArray arrayWithArray:tempArray];
        }
    }
    return self;
}

@end


@implementation ParentingStrategyDetailCellModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.cellContentString = [data objectForKey:@"content"];
        self.timeDescription = [data objectForKey:@"time"];
        self.relatedInfoType = (KTCSearchType)[[data objectForKey:@"type"] integerValue];
        if ([data objectForKey:@"id"]) {
            self.relatedInfoId = [NSString stringWithFormat:@"%@", [data objectForKey:@"id"]];
        }
        if ([data objectForKey:@"channelId"]) {
            self.relatedInfoChannelId = [NSString stringWithFormat:@"%@", [data objectForKey:@"channelId"]];
        }
        self.relatedInfoTitle = [data objectForKey:@"title"];
        self.ratio = 0.618;
    }
    return self;
}

- (CGFloat)cellHeight {
    CGFloat height = 40; //时间栏高度
    CGFloat cellWidth = SCREEN_WIDTH - 20;
    height += cellWidth * self.ratio; //图片
    height += [GConfig heightForLabelWithWidth:cellWidth - 20 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:15] topGap:10 bottomGap:10 andText:self.cellContentString]; //内容
    return height;
}

@end