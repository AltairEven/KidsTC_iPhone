//
//  HomeModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/9/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeFloorModel.h"

typedef struct HomeIndex {
    NSUInteger floorIndex;
    NSUInteger sectionIndex;
    BOOL isTitle;
    NSInteger contentIndex; //未选中则传<0
}HomeClickCoordinate;

NS_INLINE HomeClickCoordinate HomeClickMakeCoordinate(NSUInteger floor, NSUInteger section, BOOL isTitle, NSInteger content) {
    HomeClickCoordinate coord;
    coord.floorIndex = floor;
    coord.sectionIndex = section;
    coord.isTitle = isTitle;
    coord.contentIndex = content;
    return coord;
}

@interface HomeModel : NSObject

@property (nonatomic, strong, readonly) NSArray<HomeFloorModel *> *floorModels;

@property (nonatomic, readonly) NSUInteger floorCount;

@property (nonatomic, readonly) NSUInteger naviControlledFloorCount;

@property (nonatomic, strong, readonly) NSArray<HomeSectionModel *> *allSectionModels;

@property (nonatomic, strong, readonly) NSArray<NSString *> *allNaviControlledNames;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (HomeSegueModel *)segueModelAtHomeClickCoordinate:(HomeClickCoordinate)coordinate;

@end
