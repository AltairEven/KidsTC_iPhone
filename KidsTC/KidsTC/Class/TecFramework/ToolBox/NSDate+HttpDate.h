/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：NSDate+HttpDate.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：2012年09月06日
 */

#import <Foundation/Foundation.h>

@interface NSDate (HttpDate)

+ (NSDate *)dateFromHttpDateString:(NSString *)httpDate;
+ (NSDate *)GMTNow;

@end
