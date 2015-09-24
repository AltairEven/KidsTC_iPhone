/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GVisitCategory.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：12-12-11
 */

#import "GVisitCategory.h"

@implementation GVisitCategory

static GVisitCategory* _sharedVisitCategory = nil;
+(GVisitCategory*)sharedVisitCategory
{
    @synchronized([self class])
    {
        if (!_sharedVisitCategory) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath: FILE_CACHE_PATH(@"plist")]) {
                [fileManager createDirectoryAtPath: FILE_CACHE_PATH(@"plist") withIntermediateDirectories: YES attributes: nil error: nil];
            }
            
            _sharedVisitCategory = [[[self class] alloc] initWithContentsOfFile: FILE_CACHE_PATH(@"plist/gCategory.plist")];
		}
		
        return _sharedVisitCategory;
    }
	
    return nil;
}

- (void)loadCategory
{
	[addCategoryLock lock];
    
    NSArray *arr = [[NSArray alloc] initWithContentsOfFile:file];
    categoryList = [[NSMutableArray alloc] initWithArray:arr];
//    if (arr == nil) {
//        [categoryList addObject:@"311"];
//        [categoryList addObject:@"234"];
//        [categoryList addObject:@"47"];
//        [categoryList addObject:@"46"];
//        [categoryList addObject:@"642"];
//    }
	

	[addCategoryLock unlock];
}

- (id)initWithContentsOfFile:(NSString *)_file
{
	if (self = [super init]) {
		file = _file;
        addCategoryLock = [[NSLock alloc] init];
        
		[self loadCategory];
	}
    
	return self;
}

- (void)saveCategory
{
	[categoryList writeToFile: file atomically: NO];
}

- (void)addCategory:(NSString *)categoryID
{
	if (!categoryID) {
		return;
	}
    
	[addCategoryLock lock];
	NSInteger found = -1;
	NSInteger count = [categoryList count];
	for (NSUInteger i = 0; i < count; i++) {
		NSString *item = [categoryList objectAtIndex: i];
		if ([item isEqualToString:categoryID]) {
			found = i;
			break;
		}
	}
    
	if (found >= 0) {
		[categoryList removeObjectAtIndex: found];
		count --;
	}
    
	if (count >= 5) {
		[categoryList removeObjectsInRange: NSMakeRange(4, count - 5)];
	}
	
	
	[categoryList insertObject:categoryID atIndex:0];

	
	[addCategoryLock unlock];
	[self saveCategory];
}



- (NSArray *)getVisitCategory
{
	return categoryList;
}

- (void)dealloc
{
	 categoryList = nil;
	 file = nil;
	 addCategoryLock = nil;
}
@end