//
//  IcsonCategories.h
//  ICSON
//
//  Created by 钱烨 on 4/20/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IcsonBaseCategory.h"

@class IcsonLevel1Category;


#define ICKEY_MD5    (@"md5")

@interface IcsonCategories : NSManagedObject

@property (nonatomic, retain) NSString * md5;
@property (nonatomic, retain) NSSet *level1Categories;

/*
 *brief:获取本地地址md5
 *return:md5字符串
 */
+ (NSString *)getLocalMd5String;

/*
 *brief:IcsonCategories实例化方法
 *return:返回IcsonCategories实例，无效则为nil
 */
+ (instancetype)categoryInstance;

/*
 *brief:保存内存中的信息到本地
 *return:保存成功或失败
 */
+ (BOOL)saveWithError:(NSError **)error;


/*
 *brief:获取本地类目信息
 *return:本地类目类别实例
 */
+ (IcsonCategories *)getLocalCategorsWithError:(NSError **)error;

/*
 *brief:获取某个存储实体的信息
 *param:初始化存储字段名称
 *return:IcsonBaseCategory子类的实例数组
 */
+ (NSArray *)getCategoryArrayWithLevel:(CategoryLevel)level Error:(NSError **)error;

/*
 *brief:解析并存储从服务端下载的地址列表数据
 *param:服务端返回的数据字典;
 *param:抛出错误信息
 *return:void
 */
+ (void)parseAndSaveServerData:(NSDictionary *)dataDic withError:(NSError **)error;



@end

@interface IcsonCategories (CoreDataGeneratedAccessors)

- (void)addLevel1CategoriesObject:(IcsonLevel1Category *)value;
- (void)removeLevel1CategoriesObject:(IcsonLevel1Category *)value;
- (void)addLevel1Categories:(NSSet *)values;
- (void)removeLevel1Categories:(NSSet *)values;

@end
