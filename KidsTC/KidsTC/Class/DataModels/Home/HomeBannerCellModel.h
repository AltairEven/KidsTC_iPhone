//
//  HomeBannerCellModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/22/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeContentCellModel.h"

@class HomeBanner;

@interface HomeBannerCellModel : HomeContentCellModel

@property (nonatomic, strong) NSArray<HomeBanner *> *homeBannersArray;

- (NSArray *)imageUrlsArray;

@end

@interface HomeBanner : HomeElementBaseModel

@end