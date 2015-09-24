//
//  IcsonCategoryManager.h
//  ICSON
//
//  Created by 钱烨 on 2/27/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IcsonCategories.h"
#import "IcsonCategoryCondition.h"
#import "IcsonLevel1Category.h"
#import "IcsonLevel2Category.h"
#import "IcsonLevel3Category.h"

@interface IcsonCategoryManager : NSObject

/*
 *brief:IcsonCategoryManager单实例
 *return:IcsonCategoryManager实例
 */
+ (instancetype)sharedManager;

/*
 *brief:加载全部类目
 *param:上一次更新时间
 *param:成功回调
 *param:失败回调
 *return:void
 */
- (void)loadIcsonCategoriesWithLastUpdatetime:(NSString *)time success:(void(^)(IcsonCategories *categories))success andFailure:(void(^)(NSError *error))failure;

/*
 *brief:获取不同级别类目的数组
 *param:类目级别
 *param:失败信息
 *return:返回指定级别类目的数组
 */
- (NSArray *)getCategoryArrayWithLevel:(CategoryLevel)level Error:(NSError **)error;

/*
 *brief:获取本地类目存储实体
 *param:抛出错误信息
 *return:返回本地类目存储实体
 */
- (IcsonCategories *)getLocalCategorsWithError:(NSError **)error;

/*
 *brief:默认排序方法
 *param:待排序的同级别分类数组
 *param:待排序的级别
 *return:排完序的数组
 */
- (NSArray *)sortForIcsonCategoriesArray:(NSArray *)categories WithLevel:(CategoryLevel)level;

- (NSArray *)level1Categories;

@end
