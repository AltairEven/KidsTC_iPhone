//
//  HomeModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/9/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeFloorModel.h"

@interface HomeModel : NSObject

@property (nonatomic, strong, readonly) NSArray<HomeFloorModel *> *floorModels;

@property (nonatomic, readonly) NSUInteger floorCount;

@property (nonatomic, readonly) NSUInteger naviControlledFloorCount;

@property (nonatomic, strong, readonly) NSArray<HomeSectionModel *> *allSectionModels;

@property (nonatomic, strong, readonly) NSArray<NSString *> *allNaviControlledNames;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
