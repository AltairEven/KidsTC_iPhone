//
//  IcsonBaseCategory.m
//  ICSON
//
//  Created by 钱烨 on 2/27/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "IcsonBaseCategory.h"
#import "IcsonCategoryCondition.h"


#define IC_NAME_CATEGORY1 (@"IcsonLevel1Category")
#define IC_NAME_CATEGORY2 (@"IcsonLevel2Category")
#define IC_NAME_CATEGORY3 (@"IcsonLevel3Category")

static NSManagedObjectContext *_managedObjectContext = nil;
static NSManagedObjectModel *_managedObjectModel = nil;
static NSPersistentStoreCoordinator *_persistentStoreCoordinator = nil;


@implementation IcsonBaseCategory

@dynamic identifier;
@dynamic name;
@dynamic type;
@dynamic parentId;
@dynamic url;
@dynamic conditions;


+ (instancetype)categoryInstanceWithLevel:(CategoryLevel)level
{
    if (level < CategoryLevel1 || level > CategoryLevel3) {
        return nil;
    }
    NSString *entityName = [IcsonBaseCategory getEntityNameWithLevel:level];
    NSEntityDescription *description = [NSEntityDescription entityForName:entityName inManagedObjectContext:[IcsonBaseCategory getManagedObjectContext]];
    
    if (description)
    {
        IcsonBaseCategory *ic = [[IcsonBaseCategory alloc] initWithEntity:description insertIntoManagedObjectContext:[IcsonBaseCategory getManagedObjectContext]];
        return ic;
    }
    
    return nil;
}



+ (NSString *)getEntityNameWithLevel:(CategoryLevel)level
{
    switch (level) {
        case CategoryLevel1:
        {
            return IC_NAME_CATEGORY1;
        }
            break;
        case CategoryLevel2:
        {
            return IC_NAME_CATEGORY2;
        }
            break;
        case CategoryLevel3:
        {
            return IC_NAME_CATEGORY3;
        }
            break;
        default:
            break;
    }
    
    return nil;
}



+ (NSManagedObjectContext *)getManagedObjectContext
{
    if (!_managedObjectContext) {
        
        //先初始化存储
        NSPersistentStoreCoordinator *coordinator = [IcsonBaseCategory createPersistentStoreCoordinator:NO];
        
        if (coordinator) {
            //初始化成功，则初始化context
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    
    return _managedObjectContext;
}


+ (void)resetManagedObjectContext {
    //防止重复写入，先删除本地
    NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"IcsonCategories.sqlite"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:url.path isDirectory:NULL]) {
        NSError *error;
        [manager removeItemAtURL:url error:&error];
    }
    //重新建立存储文件
    [IcsonBaseCategory createPersistentStoreCoordinator:YES];
}


+ (NSPersistentStoreCoordinator *)createPersistentStoreCoordinator:(BOOL)force
{
    if (force) {
        [IcsonBaseCategory createPersistentStoreCoordinator];
        _managedObjectContext = nil;
    } else {
        if (!_persistentStoreCoordinator) {
            [IcsonBaseCategory createPersistentStoreCoordinator];
        }
    }
    
    return _persistentStoreCoordinator;
}


+ (NSPersistentStoreCoordinator *)createPersistentStoreCoordinator
{
    //先指定存储地址
    NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"IcsonCategories.sqlite"];
    
    //初始化存储
    NSManagedObjectModel *model = [IcsonBaseCategory createManagedObjectModel];
    if (model) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    } else {
        return nil;
    }
    
    NSPersistentStore *store = [_persistentStoreCoordinator persistentStoreForURL:url];
    if (!store) {
        NSError *error = nil;
        //NSDictionary *storeOptions = [NSDictionary dictionaryWithObject:NSSQLitePragmasOption forKey:@"1"];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    
    return _persistentStoreCoordinator;
}



+ (NSManagedObjectModel *)createManagedObjectModel
{
    if (!_managedObjectModel) {
        //指定Model文件地址
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"IcsonCategories" withExtension:@"momd"];
        
        //初始化Model
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    }
    
    return _managedObjectModel;
}


- (NSArray *)nextLevel {
    return nil;
}

@end
