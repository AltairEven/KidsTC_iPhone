//
//  HomeFloorModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/9/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeSectionModel.h"


typedef enum {
    HomeFloorTypeDefault,
    HomeFloorTypeHasNavi
}HomeFloorType;

@interface HomeFloorModel : NSObject

@property (nonatomic, assign) NSUInteger floorIndex;

@property (nonatomic, assign) HomeFloorType floorType;

@property (nonatomic, copy) NSString *floorName;

@property (nonatomic, strong) NSArray <HomeSectionModel *> *sectionModels;

- (instancetype)initWithRawData:(NSDictionary *)data floorIndex:(NSUInteger)index;

@end
