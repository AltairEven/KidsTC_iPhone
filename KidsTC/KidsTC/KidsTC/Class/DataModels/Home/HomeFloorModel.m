//
//  HomeFloorModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/9/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeFloorModel.h"

@implementation HomeFloorModel

- (instancetype)initWithRawData:(NSDictionary *)data floorIndex:(NSUInteger)index{
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.floorIndex = index;
        self.floorType = (HomeFloorType)[[data objectForKey:@"floorType"] integerValue];
        self.floorName = [data objectForKey:@"floorName"];
        NSArray *sectionArray = [data objectForKey:@"floors"];
        if ([sectionArray isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in sectionArray) {
                HomeSectionModel *model = [[HomeSectionModel alloc] initWithRawData:dic];
                if (model) {
                    model.floorIndex = index;
                    model.floorName = self.floorName;
                    [tempArray addObject:model];
                }
            }
            self.sectionModels = [NSArray arrayWithArray:tempArray];
        }
    }
    return self;
}

@end
