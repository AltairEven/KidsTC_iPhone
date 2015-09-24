//
//  HomeSectionModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeNormalTitleCellModel.h"
#import "HomeCountDownTitleCellModel.h"
#import "HomeMoreTitleCellModel.h"
#import "HomeBannerCellModel.h"
#import "HomeTwinklingElfCellModel.h"
#import "HomeHorizontalListCellModel.h"
#import "HomeThreeCellModel.h"
#import "HomeTwoColumnCellModel.h"

@interface HomeSectionModel : NSObject

@property (nonatomic, readonly) BOOL hasTitle;

@property (nonatomic, strong, readonly) HomeTitleCellModel *titleModel;

@property (nonatomic, strong, readonly) HomeContentCellModel *contentModel;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
