/*
 * Copyright (c) 2013,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：SqliteStorageWrapper.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：13-05-17
 */

#import "SqliteStorageWrapper.h"
#import "Shortcut.h"


@implementation SqliteStorageWrapper

@synthesize errCode, errMsg;

static SqliteStorageWrapper * _sharedSqliteStorageWrapper = nil;

+(SqliteStorageWrapper *)sharedSqliteStorageWrapper
{  
    @synchronized([self class])  
    {  
        if (!_sharedSqliteStorageWrapper) {
            _sharedSqliteStorageWrapper = [[[self class] alloc] init];
		}
		
        return _sharedSqliteStorageWrapper;  
    }  
	
    return nil;  
}


-(void)clearERR{
	self.errCode = 0;
    self.errMsg = nil;
}

-(void)setERR:(NSInteger) code forMessage:(NSString *)message{
	self.errCode = code;
    self.errMsg = message;
}


-(NSString *)getDataBasePath{
//	NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
//	return [[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"icson.db"];
    return FILE_CACHE_PATH(@"icson.db");    //edit by Altair 20141112, move to Library/Caches
}

-(id)init{
	self = [super init];

	[self clearERR];
	
	NSString *databasePath=[self getDataBasePath];
	NSFileManager *filemgr = [NSFileManager defaultManager];

	//判断是否已经有这个数据库`
	if ([filemgr fileExistsAtPath: databasePath ] == YES){
		return self;
	}
    //创建数据表，四个字段，key, value, create_time, expire_time
	[self exec:@"CREATE TABLE IF NOT EXISTS T_PAGE_CACHE (CACHE_KEY VARCHAR(50) PRIMARY KEY, CACHE_VALUE TEXT, ROW_CREATE_TIME INTEGER, ROW_EXPIRE_TIME INTEGER)"];

    //edit by Altair 20141112, set exclude key for db file
//    NSURL * pathURL = [NSURL URLWithString:databasePath];
//    assert([[NSFileManager defaultManager] fileExistsAtPath: [pathURL path]]);
//    
//    NSError *error = nil;
//    BOOL success = [pathURL setResourceValue: [NSNumber numberWithBool: YES]
//                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
//    if(!success){
//        NSLog(@"Error excluding %@ from backup %@", [pathURL lastPathComponent], error);
//    }
//
//    NSNumber *resValue;
//    BOOL bRet = [pathURL getResourceValue:&resValue forKey:NSURLIsExcludedFromBackupKey error:nil];
//    [pathURL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];

	return self;
}

//打开数据库
-(void)open{
	
	[self clearERR];
    
	if ( sqlite3_open([[self getDataBasePath] UTF8String], &database) != SQLITE_OK ){
		database = nil;
		[self setERR:100 forMessage:  @"Failed to open/create database"] ;
	}
	
}
//关闭数据库
-(void)close{
	if( database != nil ){
		sqlite3_close(database);
		database = nil;
	}
}


-(BOOL)exec:(NSString *)sql  paramArray:(NSArray *)param {
	[self clearERR];
	
	[self open];
	
	if( self.errCode != 0 ){
		return NO;
	}
	/*
     将sql文本转换成一个准备语句（prepared statement）对象，同时返回这个对象的指针。这个接口需要一个数据库连接指针以及一个要准备的包含SQL语句的文本。它实际上并不执行（evaluate）这个SQL语句，它仅仅为执行准备这个sql语句
     db：数据指针
     zSql：sql语句，使用UTF-8编码
     nByte：如果nByte小于0，则函数取出zSql中从开始到第一个0终止符的内容；如果nByte不是负的，那么它就是这个函数能从zSql中读取的字节数的最大值。如果nBytes非负，zSql在第一次遇见’/000/或’u000’的时候终止
     pzTail：上面提到zSql在遇见终止符或者是达到设定的nByte之后结束，假如zSql还有剩余的内容，那么这些剩余的内容被存放到pZTail中，不包括终止符
     ppStmt：能够使用sqlite3_step()执行的编译好的准备语句的指针，如果错误发生，它被置为NULL，如假如输入的文本不包括sql语句。调用过程必须负责在编译好的sql语句完成使用后使用sqlite3_finalize()删除它
     */
	sqlite3_stmt *statement; 
	if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) != SQLITE_OK) { 
		[self close];
		[self setERR:103 forMessage: [@"exec not ok: " stringByAppendingFormat:@"%@", sql ]];
		return NO;
	}
	
	if( param != nil ){
		NSInteger max = [param count];
		for (int i=0; i<max; i++) {
			NSString *temp = [param objectAtIndex:i];
            if ([temp isKindOfClass:[NSNumber class]])
            {
                temp = [(NSNumber *)temp stringValue];
            }
            /*
             sqlite3_bind_text的第二个参数为序号（从1开始），第三个参数为字符串值，第四个参数为字符串长度。sqlite3_bind_text的第五个参数为一个函数指针，SQLITE3执行完操作后回调此函数，通常用于释放字符串占用的内存。此参数有两个常数，SQLITE_STATIC告诉sqlite3_bind_text函数字符串为常量，可以放心使用；而SQLITE_TRANSIENT会使得sqlite3_bind_text函数对字符串做一份拷贝。一般使用这两个常量参数来调用sqlite3_bind_text。
             */
            
			sqlite3_bind_text(statement, i+1, [temp UTF8String], -1, SQLITE_TRANSIENT);
		}
	}
	//执行操作
	int success = sqlite3_step(statement);
	//销毁sqlite3_stmt对象,防止内存泄漏
	sqlite3_finalize(statement);
	
	if (success == SQLITE_ERROR) {
		[self close];
		[self setERR:104 forMessage: [@"failed to exec: " stringByAppendingFormat:@"%@", sql ]];
		return NO;
	}

	[self close];
	
	return YES;
}

-(BOOL)exec:(NSString *)sql{
	return [self exec:sql paramArray: nil];
}

-(NSMutableArray *)query:(NSString *)sql{
	[self clearERR];
	
	[self open];
	
	if( self.errCode != 0 ){
		return nil;
	}
	
	sqlite3_stmt *statement; 
	if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) != SQLITE_OK) { 
		[self close];
		[self setERR:103 forMessage: [@"select not ok: " stringByAppendingFormat:@"%@", sql ]];
		return nil;
	}
	//回结果集中包含的列数.
	int count = sqlite3_column_count(statement);
	
	NSMutableArray * arrs = [NSMutableArray arrayWithCapacity: 1];
	
	while (sqlite3_step(statement) == SQLITE_ROW) { 
		NSMutableArray *row = [NSMutableArray arrayWithCapacity: count];
		for(int i = 0; i < count; i++){
			[row addObject: [NSString stringWithCString:(char *)sqlite3_column_text(statement, i)  encoding:NSUTF8StringEncoding]];
		}

		[arrs addObject:row];
	}
	
	sqlite3_finalize(statement);
	
	[self close];
		
	return arrs;

}
@end
