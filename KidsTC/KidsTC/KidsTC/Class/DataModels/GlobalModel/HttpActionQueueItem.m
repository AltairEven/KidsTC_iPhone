/*
 * Copyright (c) 2013,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：HttpActionQueueItem.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：2013年5月15日
 */

#import "HttpActionQueueItem.h"

@implementation HttpActionQueueItem

@synthesize target;
@synthesize sucCb;
@synthesize failCb;

-(id)initWithTarget:(id) _target onSuccess:(SEL) _sucCb onFail:(SEL) _failCb
{
	if (self = [super init]) {
        self.target = _target;
		self.sucCb = _sucCb;
		self.failCb = _failCb;
	}
	return self;
}


@end
