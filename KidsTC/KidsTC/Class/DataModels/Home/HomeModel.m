//
//  HomeModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/9/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        NSArray *sectionArray = [data objectForKey:@"floors"];
        if ([sectionArray isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            _naviControlledFloorCount = 0;
            NSMutableArray *tempSections = [[NSMutableArray alloc] init];
            NSMutableArray *tempNaviedNames = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in sectionArray) {
                HomeFloorModel *model = [[HomeFloorModel alloc] initWithRawData:dic];
                if (model) {
                    [tempArray addObject:model];
                    [tempSections addObjectsFromArray:model.sectionModels];
                    if (model.floorType == HomeFloorTypeHasNavi) {
                        _naviControlledFloorCount ++;
                        [tempNaviedNames addObject:model.floorName];
                    }
                }
            }
            _floorModels = [NSArray arrayWithArray:tempArray];
            _allSectionModels = [NSArray arrayWithArray:tempSections];
            _allNaviControlledNames = [NSArray arrayWithArray:tempNaviedNames];
        }
        _floorCount = [self.floorModels count];
    }
    return self;
}

@end
