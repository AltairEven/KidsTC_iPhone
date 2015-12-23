/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：RemindNotification.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：6/7/13
 */

#import <Foundation/Foundation.h>


typedef enum {
    RemindNotificationTypeUnknow = 0,   //未知类型
    RemindNotificationTypeQiang = 1,        //抢购
    RemindNotificationTypeMorning,      //早市
    RemindNotificationTypeNight,        //晚市
    RemindNotificationTypeWeekend,      //周末清仓
    RemindNotificationTypeProduct,      //指定商品（预留字段）
    RemindNotificationTypeOther = 99,
}RemindNotificationType;

@interface RemindNotification : NSObject
@property (nonatomic)int notificationID;
@property (nonatomic)RemindNotificationType type;
@property (nonatomic, strong)NSDate *fireDate;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSMutableArray *productList;

@end

@interface RemindNotification (RemindManager)
- (id)initWithLocalNotification:(UILocalNotification *)aNotification;

+ (NSString *)titleOfType:(RemindNotificationType)type;
@end;