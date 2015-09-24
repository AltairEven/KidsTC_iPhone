//
//  IcsonCategoryManager.m
//  ICSON
//
//  Created by 钱烨 on 2/27/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "IcsonCategoryManager.h"

static IcsonCategoryManager *_categoryManager = nil;

#define DEFAULT_MD5_STRING (@"defaultmd5string")

//NSString *const kLoadClassUrl = @"http://mb.51buy.com/json.php?mod=Class&act=getnew";

@interface IcsonCategoryManager ()

@property (nonatomic, strong) HttpRequestClient *loadCategoryRequest;

@property (nonatomic, strong, readonly) IcsonCategories *icsonCategories;

@property (nonatomic, copy) NSString *localMD5String;

@property (nonatomic, assign) BOOL downloading;

- (void)resetProjectResource;

@end

@implementation IcsonCategoryManager
@synthesize icsonCategories = _icsonCategories;

- (id)init
{
    self = [super init];
    if (self) {
        [self resetProjectResource];
    }
    
    return self;
}


+ (instancetype)sharedManager
{
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^(void) {
        _categoryManager = [[IcsonCategoryManager alloc] init];
    });
    return _categoryManager;
}


- (NSArray *)level1Categories {
    if (!self.icsonCategories) {
        return nil;
    }
    NSArray *array = [self.icsonCategories.level1Categories allObjects];
    return [self sortForIcsonCategoriesArray:array WithLevel:CategoryLevel1];
}



- (void)loadIcsonCategoriesWithLastUpdatetime:(NSString *)time success:(void (^)(IcsonCategories *))success andFailure:(void (^)(NSError *))failure
{
    if (self.downloading) {
        return;
    }
    if (!self.loadCategoryRequest) {
        self.loadCategoryRequest = [HttpRequestClient clientWithUrlAliasName:@"CATEGORY_GET"];
    }
    //先获取本地MD5值
    self.localMD5String = [IcsonCategories getLocalMd5String];
    if ([GToolUtil isEmpty:self.localMD5String]) {
        self.localMD5String = DEFAULT_MD5_STRING;
    }
    
    if (!time) {
        time = @"";
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.localMD5String, @"md5", time, @"last_update_time", nil];
    
    __weak IcsonCategoryManager *weakSelf = self;
    self.downloading = YES;
    [weakSelf.loadCategoryRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        self.downloading = NO;
        [weakSelf getCategoriesSuccess:responseData];
        success(weakSelf.icsonCategories);
        
    } failure:^(HttpRequestClient *client, NSError *error) {
        self.downloading = NO;
        [weakSelf getCategorieseFailed:error];
        failure(error);
        
    }];
    
}



-(void)getCategoriesSuccess:(NSDictionary *)data
{
    NSError *error = nil;
    //解析并存储类目列表
    [IcsonCategories parseAndSaveServerData:data withError:&error];
    if (error) {
        return;
    }
    
    //同步存储在本地的类目列表到内存
    [self getLocalCategorsWithError:&error];
    
}

- (void)getCategorieseFailed:(NSError *)error
{
    if (error.code == -1001) {
        //md5相同
        //同步存储在本地的类目列表到内存
        [self getLocalCategorsWithError:&error];
    }
}



- (IcsonCategories *)getLocalCategorsWithError:(NSError *__autoreleasing *)error
{
    if (!_icsonCategories || [_icsonCategories hasChanges]) {
        _icsonCategories = [IcsonCategories getLocalCategorsWithError:error];
    }
    
    return self.icsonCategories;
}



- (NSArray *)getCategoryArrayWithLevel:(CategoryLevel)level Error:(NSError *__autoreleasing *)error
{
    NSArray *resultArray = [IcsonCategories getCategoryArrayWithLevel:level Error:error];
    resultArray = [self sortForIcsonCategoriesArray:resultArray WithLevel:level];
    
    return resultArray;
}



- (NSArray *)sortForIcsonCategoriesArray:(NSArray *)categories WithLevel:(CategoryLevel)level {
    NSArray *tempArray = [NSArray arrayWithArray:categories];
    if (tempArray && [tempArray count] > 0) {
        if (level == CategoryLevel3) {
            tempArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                //按ID升序排列
                IcsonBaseCategory *level1 = (IcsonBaseCategory *)obj1;
                
                IcsonBaseCategory *level2 = (IcsonBaseCategory *)obj2;
                
                NSNumber *temp1 = [NSNumber numberWithInteger:[level1.identifier integerValue]];
                NSNumber *temp2 = [NSNumber numberWithInteger:[level2.identifier integerValue]];
                return [temp1 compare:temp2];
            }];
//            //获取过滤后的数组
//            NSArray *filtedArray = [self level3ArrayFilter:tempArray];
//            //对所有数组排序，基于parente id
//            filtedArray = [filtedArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//                NSArray *firstArray = obj1;
//                NSArray *secondArray = obj2;
//                //按ID升序排列
//                IcsonBaseCategory *level1 = (IcsonBaseCategory *)[firstArray objectAtIndex:0];
//                
//                IcsonBaseCategory *level2 = (IcsonBaseCategory *)[secondArray objectAtIndex:0];
//                
//                NSArray *temArr1 = [level1.parentId componentsSeparatedByString:@"-"];
//                NSArray *temArr2 = [level2.parentId componentsSeparatedByString:@"-"];
//                
//                NSString *tempStr1 = [temArr1 objectAtIndex:2];
//                NSString *tempStr2 = [temArr2 objectAtIndex:2];
//                NSNumber *temp1 = [NSNumber numberWithInteger:[tempStr1 integerValue]];
//                NSNumber *temp2 = [NSNumber numberWithInteger:[tempStr2 integerValue]];
//                return [temp1 compare:temp2];
//            }];
//            
//            //针对每个数组排序
//            NSMutableArray *sortedListArray = [[NSMutableArray alloc] init];
//            for (NSArray *singlearray in filtedArray) {
//                NSArray *sortedArray = [singlearray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//                    //按ID升序排列
//                    IcsonBaseCategory *level1 = (IcsonBaseCategory *)obj1;
//                    
//                    IcsonBaseCategory *level2 = (IcsonBaseCategory *)obj2;
//                    
//                    NSString *tempStr1 = [level1.identifier substringFromIndex:level1.parentId.length+1];
//                    NSString *tempStr2 = [level2.identifier substringFromIndex:level2.parentId.length+1];
//                    NSNumber *temp1 = [NSNumber numberWithInteger:[tempStr1 integerValue]];
//                    NSNumber *temp2 = [NSNumber numberWithInteger:[tempStr2 integerValue]];
//                    return [temp1 compare:temp2];
//                }];
//                //添加到排好序的数组里
//                [sortedListArray addObject:sortedArray];
//            }
//            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:[sortedListArray count]];
//            //循环将排好序的数据加入统一的数组
//            for (NSArray *result in sortedListArray) {
//                [resultArray addObjectsFromArray:result];
//            }
//            tempArray = [NSArray arrayWithArray:resultArray];
            
        } else {
            tempArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                //按ID升序排列
                IcsonBaseCategory *level1 = (IcsonBaseCategory *)obj1;
                
                IcsonBaseCategory *level2 = (IcsonBaseCategory *)obj2;
                
                NSNumber *temp1 = [NSNumber numberWithInteger:[level1.identifier integerValue]];
                NSNumber *temp2 = [NSNumber numberWithInteger:[level2.identifier integerValue]];
                return [temp1 compare:temp2];
            }];
        }
    }
    return tempArray;
}


- (NSArray *)level3ArrayFilter:(NSArray *)level3Array {
    if (!level3Array || [level3Array count] == 0) {
        return nil;
    }
    NSMutableArray *diffParentArray = [[NSMutableArray alloc] init];
    NSMutableArray *level3Mutable = [NSMutableArray arrayWithArray:level3Array];
    
    while ([level3Mutable count] > 0) {
        //获取过滤后剩余数组的第一个数据
        IcsonBaseCategory *cate = (IcsonBaseCategory *)[level3Mutable objectAtIndex:0];
        NSMutableArray *temArray = [[NSMutableArray alloc] init];
        NSMutableArray *removeIndex = [[NSMutableArray alloc] init];
        //循环找出相同parent id的数据
        [level3Mutable enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            IcsonBaseCategory *tempCate = (IcsonBaseCategory *)obj;
            if ([tempCate.parentId isEqualToString:cate.parentId]) {
                [temArray addObject:tempCate];
                [removeIndex addObject:[NSNumber numberWithInteger:idx]];
            }
        }];
        [diffParentArray addObject:temArray];
        [level3Mutable removeObjectsInArray:temArray];
    }
    
    return [NSArray arrayWithArray:diffParentArray];
    
}

#pragma mark Private methods

- (void)resetProjectResource {
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ProjectResources.bundle/Category/IcsonCategories.sqlite"];
    NSString *cachePath = [[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"IcsonCategories.sqlite"].path;
    [GToolUtil copyFileFormBundlePath:bundlePath toFilePath:cachePath];
    
    bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ProjectResources.bundle/Category/IcsonCategories.sqlite-shm"];
    cachePath = [[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"IcsonCategories.sqlite-shm"].path;
    [GToolUtil copyFileFormBundlePath:bundlePath toFilePath:cachePath];
    
    bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ProjectResources.bundle/Category/IcsonCategories.sqlite-wal"];
    cachePath = [[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"IcsonCategories.sqlite-wal"].path;
    [GToolUtil copyFileFormBundlePath:bundlePath toFilePath:cachePath];

}


@end
