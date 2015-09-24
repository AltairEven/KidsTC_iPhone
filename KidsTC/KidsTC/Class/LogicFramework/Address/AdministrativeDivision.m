//
//  AdministrativeDivision.m
//  ICSON
//
//  Created by 钱烨 on 2/26/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "AdministrativeDivision.h"

static NSManagedObjectContext *_managedObjectContext = nil;
static NSManagedObjectModel *_managedObjectModel = nil;
static NSPersistentStoreCoordinator *_persistentStoreCoordinator = nil;

@implementation AdministrativeDivision

@dynamic adminLevel;
@dynamic gbAreaId;
@dynamic name;
@dynamic sortId;
@dynamic uniqueId;

+ (instancetype)ADInstance
{
    return nil;
}


+ (NSManagedObjectContext *)getManagedObjectContext
{
    if (!_managedObjectContext) {
        
        //先初始化存储
        NSPersistentStoreCoordinator *coordinator = [AdministrativeDivision createPersistentStoreCoordinator:NO];
        
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
    NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"IcsonADList.sqlite"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:url.path isDirectory:NULL]) {
        NSError *error;
        [manager removeItemAtURL:url error:&error];
    }
    //重新建立存储文件
    [AdministrativeDivision createPersistentStoreCoordinator:YES];
}


+ (NSPersistentStoreCoordinator *)createPersistentStoreCoordinator:(BOOL)force
{
    if (force) {
        [AdministrativeDivision createPersistentStoreCoordinator];
        _managedObjectContext = nil;
    } else {
        if (!_persistentStoreCoordinator) {
            [AdministrativeDivision createPersistentStoreCoordinator];
        }
    }
    
    return _persistentStoreCoordinator;
}


+ (NSPersistentStoreCoordinator *)createPersistentStoreCoordinator {
    
    //先指定存储地址
    NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"IcsonADList.sqlite"];
    
    //初始化存储
    NSManagedObjectModel *model = [AdministrativeDivision createManagedObjectModel];
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
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"IcsonADList" withExtension:@"momd"];
        
        //初始化Model
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    }
    
    return _managedObjectModel;
}


- (BOOL)isInLocalFile {
    return NO;
}


- (BOOL)save
{
    NSError *error = nil;
    BOOL bSucceed = [[AdministrativeDivision getManagedObjectContext] save:&error];
    if (!bSucceed) {
        NSLog(@"Save failed:%@", [error localizedDescription]);
    }
    
    return bSucceed;
}



+ (NSArray *)getADArrayWithError:(NSError *__autoreleasing *)error
{
    return nil;
}



- (NSArray *)getNextLevelADWithError:(NSError *__autoreleasing *)error {
    return nil;
}



- (NSString *)getFullName {
    return nil;
}


- (NSArray *)getUpperLevelADArrayWithError:(NSError *__autoreleasing *)error {
    return nil;
}



- (AdministrativeDivision *)getUpperLevelAD {
    return nil;
}



- (NSNumber *)provinceId {
    return nil;
}


@end
