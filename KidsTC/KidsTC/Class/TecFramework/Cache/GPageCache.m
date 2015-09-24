/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GPageCache.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：12-12-11
 */

#import "GPageCache.h"


static int errCode;
static NSString * errMsg;

@implementation GPageCache

+(BOOL)set:(NSString*)key forValue:(NSString *)value forExpireTime:(int)expireTime{
	
	[self clearERR];
	
	if( key == nil || value == nil ){
		[GPageCache setErrMsg:105 forMessage:@"key or value is nil."];
		return NO;
	}
	
	SqliteStorageWrapper* core = [SqliteStorageWrapper sharedSqliteStorageWrapper];
	
	NSString * sql = [NSString stringWithFormat:@"SELECT CACHE_KEY FROM T_PAGE_CACHE WHERE CACHE_KEY= '%@'", key];
	NSMutableArray * records = [core query: sql];
	
	if( core.errCode != 0 ){
		[GPageCache setErrMsg:(int)(core.errCode) forMessage:core.errMsg];
		return NO;
	}
	
	NSTimeInterval now =  [[NSDate date] timeIntervalSince1970];
	
	expireTime =  expireTime == 0 ? 0 : ( expireTime + now );
	 		
	BOOL success = NO;
	if( [records count]  > 0){
		NSArray *params = [[NSArray alloc] initWithObjects:value, [NSString stringWithFormat:@"%d",expireTime], key, nil];
		success = [core exec:@"UPDATE T_PAGE_CACHE SET CACHE_VALUE=?, ROW_EXPIRE_TIME=? WHERE CACHE_KEY=?" paramArray:params];
	}
	else{
		NSArray *params = [[NSArray alloc] initWithObjects:key, value, [NSString stringWithFormat:@"%0.f",now], [NSString stringWithFormat:@"%d",expireTime], nil];
		success = [core exec:@"INSERT INTO T_PAGE_CACHE(CACHE_KEY, CACHE_VALUE, ROW_CREATE_TIME, ROW_EXPIRE_TIME) VALUES(?,?,?,?)" paramArray:params];
	}
	
	if( !success){
		[GPageCache setErrMsg:(int)(core.errCode) forMessage:core.errMsg];
		return NO;
	}
	
	return YES;
}

+(BOOL)set:(NSString*)key forValue:(NSString *)value{
	return [self set:key forValue:value forExpireTime:0];
}

+(NSString *)get:(NSString *)key{
	NSLog(@"%@",NSHomeDirectory());
	[self clearERR];
	
	SqliteStorageWrapper * core = [SqliteStorageWrapper sharedSqliteStorageWrapper];
	
	NSString * sql = [NSString stringWithFormat:@"SELECT CACHE_VALUE, ROW_EXPIRE_TIME FROM T_PAGE_CACHE WHERE CACHE_KEY='%@'", key];
	NSMutableArray * records = [core query:sql];
	
	if( core.errCode != 0 ){
		[GPageCache setErrMsg:(int)(core.errCode) forMessage:core.errMsg];
		return nil;
	}

	if(  [records count] < 1   ){
		return nil;
	}
	
	NSMutableArray * item = [records objectAtIndex:0];
	
	NSInteger expireTime = [(NSString *)[item objectAtIndex:1] intValue];
	
	NSTimeInterval now =  [[NSDate date] timeIntervalSince1970];
	
	if( ( expireTime !=0 ) && ( now >  expireTime ) ){
		NSArray *params = [[NSArray alloc] initWithObjects:key, nil];
		[core exec:@"DELETE FROM T_PAGE_CACHE WHERE CACHE_KEY=?" paramArray:params];
		return nil;
	}
	
	return  (NSString *)[item objectAtIndex:0];
	
}

+(BOOL)remove:(NSString *)key{
	[self clearERR];
	
	SqliteStorageWrapper * core = [SqliteStorageWrapper sharedSqliteStorageWrapper];
	NSArray *params = [NSArray arrayWithObjects:key, nil];
	return [core exec:@"DELETE FROM T_PAGE_CACHE WHERE CACHE_KEY=?" paramArray:params];	
}


+(BOOL)removeByLeftLike:(NSString *)key{
	[self clearERR];
	
	SqliteStorageWrapper * core = [SqliteStorageWrapper sharedSqliteStorageWrapper];
	NSArray *params = [NSArray arrayWithObjects:key, nil];
	return [core exec:@"DELETE FROM T_PAGE_CACHE WHERE CACHE_KEY like ?" paramArray:params];	
}


+(int)errCode{
	return errCode;
}

+(NSString *)errMsg{
	return errMsg;
}

+(void) clearERR{
	errCode = 0;
	
	if(errMsg != nil){
		errMsg = nil;
	}
}

+(void)setErrMsg:(int)code forMessage:(NSString *) str{
	[self clearERR];
	errCode = code;
	errMsg = str;
}

@end
