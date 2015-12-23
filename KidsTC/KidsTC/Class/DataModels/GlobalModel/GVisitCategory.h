/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GVisitCategory.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：12-12-11
 */

#import <Foundation/Foundation.h>

@interface GVisitCategory : NSObject
{
	NSString *file;
	NSMutableArray *categoryList;
    
	NSLock *addCategoryLock;
}

+(GVisitCategory*)sharedVisitCategory;
- (void)addCategory:(NSString *)categoryID;
- (NSArray *)getVisitCategory;
@end
