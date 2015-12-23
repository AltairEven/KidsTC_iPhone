/*
 * Copyright (c) 2013,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：HttpActionQueueItem.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：2013年5月15日
 */

// if the targe reatin make a cycle and cause the crash
//  rQueue{HttpActionQueueItem} -> targe(GSearchInputController) -> searchReq(HttpRequestWrapper) -> rQueue(NSArray)

#import <Foundation/Foundation.h>

@interface HttpActionQueueItem : NSObject

@property (weak, nonatomic) id target;
@property (nonatomic) SEL sucCb;
@property (nonatomic) SEL failCb;

-(id)initWithTarget:(id) target onSuccess:(SEL) sucCb onFail:(SEL) failCb;
@end
