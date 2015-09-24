/*
 * Copyright (c) 2013,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：SqliteStorageWrapper.h
 * 文件标识：
 * 摘 要：实现对sqlite的封装，用来存用户，站点等信息，这里我觉得有点大材小用，完全可以用缺省plist存。
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：13-05-17
 */

/*
 * 技术注释：sqlite是嵌入式的和轻量级的sql数据库。sqlite是由c实现的。广泛用于包括浏览器（支持html5的大部分浏览器，ie除外）、ios、android以及一些便携需求的小型web应用系统。
 * #import "/usr/include/sqlite3.h"
 * 库文件libsqlite3.0.dylib
 */


/*
 */

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <CoreLocation/CoreLocation.h>
#import "GConfig.h"

@interface SqliteStorageWrapper : NSObject {
	sqlite3 *database;
	NSString *path;
}

- (NSMutableArray *)query:(NSString *)sql;
- (BOOL)exec:(NSString *)sql paramArray:(NSArray *)param;
-(BOOL)exec:(NSString *)sql;


+(SqliteStorageWrapper *)sharedSqliteStorageWrapper;

@property (nonatomic) NSInteger errCode;
@property (strong, nonatomic) NSString *errMsg;

@end