/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：PayTypeItem.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：haoquanbai
 * 完成日期：13-2-28
 */

#import <Foundation/Foundation.h>

@interface PayTypeItem : NSObject

@property (nonatomic) NSInteger payTypeID;
@property (nonatomic, strong) NSString *payTypeName;
@property (nonatomic) int sortID;

- (id)initWithRawData:(NSDictionary *)rawData;

@end
