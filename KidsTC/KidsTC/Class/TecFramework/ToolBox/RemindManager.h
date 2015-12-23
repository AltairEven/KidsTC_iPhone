/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：RemindManager.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：6/7/13
 */

#import <Foundation/Foundation.h>
#import "RemindNotification.h"

#define kRemindType         @"kIcsonAppRemindType"
#define kRemindProductList  @"kIcsonAppRemindProductList"
#define kRemindProductInfo  @"kIcsonAppRemindProductInfo"

@interface RemindManager : NSObject
/*
 \brief 返回所有为执行的 notification
 */
@property (weak, nonatomic, readonly)NSArray *validNotifications;

/*
 \brief 单例
 */
+ (RemindManager *)sharedRemindManager;

/*
 \brief 添加一个本地通知，合并（相同类型&相同时间）的通知商品列表
 */
- (void)addRemindNotification:(RemindNotification *)aNotification;
/*
 \breif 创建新的本地通知，如有重复，不合并
 */
- (void)createNewLocalNofitication:(RemindNotification *)aNotification;
/*
 \brief 删除一个符合条件到本地通知。
 */
- (void)cancelRemindNotification:(RemindNotification *)aNofication;
/*
 \brief 删除对应通知类型下到 某个商品到通知。
 \param pid     商品id
 \param type    通知类型
 */
- (void)cancelRemindNotificationByProductID:(NSString*)pid ofType:(RemindNotificationType)type;
/*
 \brief 取消所有本地通知。
 */
- (void)cancelAllNofification;

/*
 \brief 是否已经添加商品到制定类型到提醒
 \param pid 商品id
 \param type 通知类型
 */
- (BOOL)hasRemindNotificationOfProductID:(NSString*)pid ofType:(RemindNotificationType)type;

@end
