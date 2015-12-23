/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：ASIDataProvider.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年11月17日
 */

#import <Foundation/Foundation.h>

#import "ASIFormDataRequest.h"

#define ASI_DEFAULT_QUEUE                       @"default" 
#define ASI_CANCEL_LAST_QUEUE                   @"cancelLast"


@interface ASIDataProvider : NSObject <ASIHTTPRequestDelegate> {
    
    NSMutableDictionary *           _queueDict;
    
}

+ (ASIDataProvider*) sharedASIDataProvider;

- (void) setMaxConcurrentOperationCount:(NSInteger)cnt forGroup:(NSString*)group;
- (void) setShowDetailProgress:(BOOL)ifShow forGroup:(NSString*)group groupProgressDelegate:(id)groupDelegate;

- (void) addASIRequest:(ASIHTTPRequest*)request;
- (void) addASIRequest:(ASIHTTPRequest*)request withGroup:(NSString*)group;

- (void) cancelRequestGroup:(NSString*)group;

- (void) suspendRequestGroup:(NSString*)group;
- (void) resumeRequestGroup:(NSString*)group;

@end
