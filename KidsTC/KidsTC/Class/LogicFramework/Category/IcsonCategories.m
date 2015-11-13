//
//  IcsonCategories.m
//  ICSON
//
//  Created by 钱烨 on 4/20/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "IcsonCategories.h"
#import "IcsonLevel1Category.h"
#import "IcsonLevel2Category.h"
#import "IcsonLevel3Category.h"
#import "IcsonCategoryCondition.h"

#define IC_NAME_CATEGORYS (@"IcsonCategories")

@implementation IcsonCategories

@dynamic md5;
@dynamic level1Categories;

+ (instancetype)categoryInstance
{
    NSEntityDescription *description = [NSEntityDescription entityForName:IC_NAME_CATEGORYS inManagedObjectContext:[IcsonBaseCategory getManagedObjectContext]];
    
    if (description)
    {
        IcsonCategories *ic = [[IcsonCategories alloc] initWithEntity:description insertIntoManagedObjectContext:[IcsonBaseCategory getManagedObjectContext]];
        return ic;
    }
    
    return nil;
}




+ (NSString *)getLocalMd5String
{
    //先获取static context
    NSManagedObjectContext *context = [IcsonBaseCategory getManagedObjectContext];
    
    //初始化fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:IC_NAME_CATEGORYS inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    //执行查询操作并返回
    NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
    
    if (array && [array count] > 0) {
        IcsonCategories *cate = [array objectAtIndex:0];
        //读取md5值
        return cate.md5;
    }
    
    return nil;
}


+ (BOOL)saveWithError:(NSError *__autoreleasing *)error
{
    BOOL bSucceed = [[IcsonBaseCategory getManagedObjectContext] save:error];
    if (!bSucceed) {
        NSLog(@"Save failed:%@", [*error localizedDescription]);
    }
    
    return bSucceed;
}


+ (IcsonCategories *)getLocalCategorsWithError:(NSError *__autoreleasing *)error
{
    //先获取static context
    NSManagedObjectContext *context = [IcsonBaseCategory getManagedObjectContext];
    
    //初始化fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:IC_NAME_CATEGORYS inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    //执行查询操作
    NSArray *result = [context executeFetchRequest:fetchRequest error:error];
    
    if (result && [result count] > 0) {
        return [result objectAtIndex:0];
    }
    
    return nil;
}


+ (NSArray *)getCategoryArrayWithLevel:(CategoryLevel)level Error:(NSError *__autoreleasing *)error
{
    //先获取static context
    NSManagedObjectContext *context = [IcsonBaseCategory getManagedObjectContext];
    
    //初始化fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSString *entityName = [IcsonBaseCategory getEntityNameWithLevel:level];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    //执行查询操作并返回
    return [context executeFetchRequest:fetchRequest error:error];
}


+ (void)parseAndSaveServerData:(NSDictionary *)dataDic withError:(NSError *__autoreleasing *)error
{
    if (!dataDic || [dataDic count] == 0) {
        //没有数据可供解析
        *error = [NSError errorWithDomain:@"Parse server data" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"No response data." forKey:@"errMsg"]];
        return;
    }
    
    NSArray *categoryData = [dataDic objectForKey:@"data"];
    if (!categoryData || [categoryData count] == 0 || ![categoryData isKindOfClass:[NSArray class]]) {
        //没有类目数据
        *error = [NSError errorWithDomain:@"Parse server data" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"No category data." forKey:@"errMsg"]];
        return;
    }
    
    //此处需要重置存储
    [IcsonBaseCategory resetManagedObjectContext];
    
    IcsonCategories *categories = [IcsonCategories categoryInstance];
    //赋值md5
    NSString * md5String = [dataDic objectForKey:ICKEY_MD5];
    [categories setValue:md5String forKey:ICKEY_MD5];
    NSMutableSet *level1Set = [[NSMutableSet alloc] init];
    
    for (int n = 0; n < [categoryData count]; n++) {
        //遍历一级类目
        NSDictionary *dic1 = [categoryData objectAtIndex:n];
        NSString *identifier1 = [dic1 objectForKey:@"SysNo"];
        NSString *name1 = [dic1 objectForKey:@"Name"];
        NSString *parent1 = [dic1 objectForKey:@"PSysNo"];
        NSString *url1 = [dic1 objectForKey:@"SearchUrl"];
//        NSString *type1 = [NSString stringWithFormat:@"%@", [dic1 objectForKey:@"type"]];
        
        IcsonLevel1Category *singlelevel1Cate = [IcsonLevel1Category categoryInstanceWithLevel:CategoryLevel1];
        [singlelevel1Cate setValue:identifier1 forKey:ICKEY_ID];
        [singlelevel1Cate setValue:name1 forKey:ICKEY_NAME];
        [singlelevel1Cate setValue:parent1 forKey:ICKEY_PARENTID];
        [singlelevel1Cate setValue:url1 forKey:ICKEY_URL];
//        [singlelevel1Cate setValue:type1 forKey:ICKEY_TYPE];
        //解析condition
        NSSet *conditionSet1 = [IcsonCategories getConditionWithData:[dic1 objectForKey:@"search_parms"] andConditionCategory:singlelevel1Cate];
        if (conditionSet1) {
            [singlelevel1Cate addConditions:conditionSet1];
        }
        
        NSArray *l2Array = [dic1 objectForKey:@"ScondCategory"];
        NSMutableSet *level2Set = [[NSMutableSet alloc] init];
        if (l2Array && [l2Array isKindOfClass:[NSArray class]]) {
            //遍历二级类目
            for (int n = 0; n < [l2Array count]; n++) {
                NSDictionary *dic2 = [l2Array objectAtIndex:n];
                NSString *identifier2 = [dic2 objectForKey:@"SysNo"];
                NSString *name2 = [dic2 objectForKey:@"Name"];
                NSString *parent2 = [dic2 objectForKey:@"PSysNo"];
                NSString *url2 = [dic2 objectForKey:@"SearchUrl"];
//                NSString *type2 = [NSString stringWithFormat:@"%@", [dic1 objectForKey:@"type"]];
                
                IcsonLevel2Category *singlelevel2Cate = [IcsonLevel2Category categoryInstanceWithLevel:CategoryLevel2];
                [singlelevel2Cate setValue:identifier2 forKey:ICKEY_ID];
                [singlelevel2Cate setValue:name2 forKey:ICKEY_NAME];
                [singlelevel2Cate setValue:parent2 forKey:ICKEY_PARENTID];
                [singlelevel2Cate setValue:url2 forKey:ICKEY_URL];
//                [singlelevel2Cate setValue:type2 forKey:ICKEY_TYPE];
                //解析condition
                NSSet *conditionSet2 = [IcsonCategories getConditionWithData:[dic2 objectForKey:@"search_parms"] andConditionCategory:singlelevel2Cate];
                if (conditionSet2) {
                    [singlelevel2Cate addConditions:conditionSet2];
                }
                
                NSArray *l3Array = [dic2 objectForKey:@"ScondCategory"];
                NSMutableSet *level3Set = [[NSMutableSet alloc] init];
                if (l3Array && [l3Array isKindOfClass:[NSArray class]]) {
                    //遍历三级类目
                    for (int n = 0; n < [l3Array count]; n++) {
                        NSDictionary *dic3 = [l3Array objectAtIndex:n];
                        NSString *identifier3 = [dic3 objectForKey:@"SysNo"];
                        NSString *name3 = [dic3 objectForKey:@"Name"];
                        NSString *parent3 = [dic3 objectForKey:@"PSysNo"];
                        NSString *url3 = [dic3 objectForKey:@"SearchUrl"];
//                        NSString *type3 = [NSString stringWithFormat:@"%@", [dic1 objectForKey:@"type"]];
                        
                        IcsonLevel3Category *singlelevel3Cate = [IcsonLevel3Category categoryInstanceWithLevel:CategoryLevel3];
                        [singlelevel3Cate setValue:identifier3 forKey:ICKEY_ID];
                        [singlelevel3Cate setValue:name3 forKey:ICKEY_NAME];
                        [singlelevel3Cate setValue:parent3 forKey:ICKEY_PARENTID];
                        [singlelevel2Cate setValue:url3 forKey:ICKEY_URL];
//                        [singlelevel3Cate setValue:type3 forKey:ICKEY_TYPE];
                        //解析condition
                        NSSet *conditionSet3 = [IcsonCategories getConditionWithData:[dic3 objectForKey:@"search_parms"] andConditionCategory:singlelevel3Cate];
                        if (conditionSet3) {
                            [singlelevel3Cate addConditions:conditionSet3];
                        }
                        
                        //添加三级类目到集合
                        [level3Set addObject:singlelevel3Cate];
                    }
                    //添加三级类目集合到二级类目
                    [singlelevel2Cate addLevel3Categories:level3Set];
                }
                //添加二级类目到集合
                [level2Set addObject:singlelevel2Cate];
            }
            //添加二级类目集合到一级类目
            [singlelevel1Cate addLevel2Categories:level2Set];
        }
        //添加一级类目到集合
        [level1Set addObject:singlelevel1Cate];
    }
    //添加一级类目集合到类目列表
    [categories addLevel1Categories:level1Set];
    
    [IcsonCategories saveWithError:error];
}


+ (NSSet *)getConditionWithData:(id)data andConditionCategory:(IcsonBaseCategory *)category
{
    NSMutableSet *conditionSet = [[NSMutableSet alloc] init];
    
    if ([data isKindOfClass:[NSDictionary class]]) {
        //多个
        [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            IcsonCategoryCondition *condition = [IcsonCategoryCondition conditionInstance];
            [condition setValue:(NSString *)obj forKey:ICKEY_CONDITIONITEM];
            [condition setValue:key forKey:ICKEY_CONDITIONKEY];
            [condition setValue:category forKey:ICKEY_CONDITIONCATEGORY];
            [conditionSet addObject:condition];
        }];
        
    } else {
        return nil;
    }
    
    return [NSSet setWithSet:conditionSet];
}

@end
