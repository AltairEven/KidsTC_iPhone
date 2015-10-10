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
        NSArray *floorArray = [data objectForKey:@"data"];
        if ([floorArray isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            _naviControlledFloorCount = 0;
            NSMutableArray *tempSections = [[NSMutableArray alloc] init];
            NSMutableArray *tempNaviedNames = [[NSMutableArray alloc] init];
            for (NSUInteger index = 0; index < [floorArray count]; index ++) {
                NSDictionary *dic = [floorArray objectAtIndex:index];
                HomeFloorModel *model = [[HomeFloorModel alloc] initWithRawData:dic floorIndex:index];
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

- (HomeSegueModel *)segueModelAtHomeClickCoordinate:(HomeClickCoordinate)coordinate {
    return nil;
}

@end
