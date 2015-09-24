//
//  HomeBannerCellModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/22/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeContentCellModel.h"
#import "HomeBanner.h"

@interface HomeBannerCellModel : HomeContentCellModel

@property (nonatomic, strong) NSArray *homeBannersArray;

- (NSArray *)imageUrlsArray;

@end
