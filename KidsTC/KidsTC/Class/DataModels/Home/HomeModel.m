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
        @try {
            NSArray *floorArray = [data objectForKey:@"data"];
            if ([floorArray isKindOfClass:[NSArray class]]) {
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                _naviControlledFloorCount = 0;
                NSMutableArray *tempSections = [[NSMutableArray alloc] init];
                NSMutableArray *tempNaviedFloors = [[NSMutableArray alloc] init];
                for (NSUInteger index = 0; index < [floorArray count]; index ++) {
                    NSDictionary *dic = [floorArray objectAtIndex:index];
                    HomeFloorModel *model = [[HomeFloorModel alloc] initWithRawData:dic floorIndex:index];
                    if (model) {
                        [tempArray addObject:model];
                        [tempSections addObjectsFromArray:model.sectionModels];
                        if (model.floorType == HomeFloorTypeHasNavi) {
                            _naviControlledFloorCount ++;
                            [tempNaviedFloors addObject:model];
                        }
                    }
                }
                _floorModels = [NSArray arrayWithArray:tempArray];
                _allSectionModels = [NSArray arrayWithArray:tempSections];
                _allNaviControlledFloors = [NSArray arrayWithArray:tempNaviedFloors];
            }
            _floorCount = [self.floorModels count];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
        @finally {
            
        }
    }
    return self;
}

- (HomeSegueModel *)segueModelAtHomeClickCoordinate:(HomeClickCoordinate)coordinate {
    HomeClickCoordinate clickCoord = coordinate;
    HomeSegueModel *segueModel = nil;
    HomeSectionModel *sectionModel = [self.allSectionModels objectAtIndex:clickCoord.sectionIndex];
    if (clickCoord.isTitle) {
        segueModel = sectionModel.titleModel.segueModel;
    } else if (clickCoord.contentIndex >= 0) {
        NSArray *elementsArray = [sectionModel.contentModel elementModelsArray];
        if ([elementsArray count] > coordinate.contentIndex) {
            segueModel = ((HomeElementBaseModel *)[elementsArray objectAtIndex:clickCoord.contentIndex]).segueModel;
        }
    }
    
    return segueModel;
}

@end
