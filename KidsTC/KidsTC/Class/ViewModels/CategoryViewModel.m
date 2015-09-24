//
//  CategoryViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/4/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CategoryViewModel.h"
#import "IcsonCategoryManager.h"

NSString *const kSearchUrlKey = @"kSearchUrlKey";
NSString *const kSearchParamKey = @"kSearchParamKey";


@interface CategoryViewModel () <CategoryViewDataSource>

@property (nonatomic, weak) CategoryView *view;

@end

@implementation CategoryViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (CategoryView *)view;
        self.view.dataSource = self;
    }
    return self;
}

#pragma mark CategoryViewDataSource

- (NSArray *)categoriesOfCategoryView:(CategoryView *)view {
    return [[IcsonCategoryManager sharedManager] level1Categories];
}


#pragma mark Super methods

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (![[IcsonCategoryManager sharedManager] level1Categories]) {
        __weak CategoryViewModel *weakSelf = self;
        [[IcsonCategoryManager sharedManager] loadIcsonCategoriesWithLastUpdatetime:@"" success:^(IcsonCategories *categories) {
            [weakSelf startUpdateDataWithSucceed:nil failure:nil];
        } andFailure:^(NSError *error) {
            [weakSelf startUpdateDataWithSucceed:nil failure:nil];
        }];
    } else {
        [self.view reloadData];
    }
}

#pragma mark Public methods

- (NSDictionary *)searchUrlAndParamsOfLevel1Index:(NSUInteger)lvl1Index level2Index:(NSUInteger)lvl2Index {
    NSArray *level1Array = [[IcsonCategoryManager sharedManager] level1Categories];
    if ([level1Array count] > 0) {
        IcsonLevel1Category *level1Category = [level1Array objectAtIndex:lvl1Index];
        IcsonLevel2Category *level2Category = [[level1Category nextLevel] objectAtIndex:lvl2Index];
        NSDictionary *retData = [NSDictionary dictionaryWithObjectsAndKeys:level2Category.url, kSearchUrlKey, level2Category.conditions, kSearchParamKey, nil];
        return retData;
    }
    return nil;
}

@end
