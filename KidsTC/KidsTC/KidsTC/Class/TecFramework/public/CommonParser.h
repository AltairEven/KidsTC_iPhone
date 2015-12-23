/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：CommonParser.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：12-18-2012
 */

#import <Foundation/Foundation.h>
#import "DownLoadManager.h"

@interface CommonParser : NSObject {
    
    NSMutableDictionary *       _reqGetDict;
    NSMutableDictionary *       _reqPostDict;
    BOOL                        _needRawData;
}

@property (nonatomic) BOOL      enableUrlKeyMapping;            // url key map 开关, 默认打开
@property (nonatomic) BOOL      enableCoocieSiteUrlKey;         
@property (nonatomic) BOOL      enableCoocieUserUrlKey;


- (void)nocacheRequestWithURL:(NSString *)url completion:(void (^)(NSDictionary *))completion fail:(void (^)(NSError *))fail withName:(NSString*)name;
- (void)requestWithURL:(NSString *)url completion:(void (^)(NSDictionary *))completion fail:(void (^)(NSError *))fail withName:(NSString*)name;
- (void)requestWithURL:(NSString *)url completion:(void (^)(NSDictionary *))completion fail:(void (^)(NSError *))fail expireDuration:(NSTimeInterval)expire withName:(NSString*)name;   // second, 数据有效期

// 方便使用的helper函数，部分请求可能需要的参数
- (NSString*) udid;
- (NSNumber*) uid;

// override these if needed

- (NSDictionary*) userInfo;

- (NSString*) requestGroup;
- (NSTimeInterval) timeoutDuration;

- (NSMutableArray*) cookiesForUrl:(NSURL*)url;
- (NSString*) keyForUrl:(NSString*)urlStr;      // url生成cache key的方法，用于区分同一个url，不同post data，或者cookie的变化

- (NSOperationQueuePriority)priority;

- (DownloadOption*) downloadOption;              // only wrok for cache mode
- (void)preprocessRequest:(ASIHTTPRequest*)request;

+ (BOOL) checkValidData:(id)data forRule:(NSDictionary*)rule;

@end
