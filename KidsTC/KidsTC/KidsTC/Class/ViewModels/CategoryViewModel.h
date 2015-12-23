//
//  CategoryViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/4/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "CategoryView.h"

extern NSString *const kSearchUrlKey;
extern NSString *const kSearchParamKey;

@interface CategoryViewModel : BaseViewModel

- (NSDictionary *)searchUrlAndParamsOfLevel1Index:(NSUInteger)lvl1Index level2Index:(NSUInteger)lvl2Index;

@end
