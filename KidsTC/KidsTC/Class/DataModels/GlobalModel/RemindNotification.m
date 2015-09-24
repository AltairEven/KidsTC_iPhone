/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：RemindNotification.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：6/7/13
 */

#import "RemindNotification.h"
#import "RemindManager.h"

@implementation RemindNotification


#pragma mark - RemindManager
- (id)initWithLocalNotification:(UILocalNotification *)aNotification
{
    if (self = [self init])
    {
        NSDictionary *userInfo = aNotification.userInfo;
        self.type = [[userInfo objectForKey:kRemindType] intValue];
        self.productList = [userInfo objectForKey:kRemindProductList];
        self.fireDate = aNotification.fireDate;
        self.message = aNotification.alertBody;
    }
    
    return self;
}

+ (NSString *)titleOfType:(RemindNotificationType)type
{
    NSString * title = nil;
    switch (type) {
        case RemindNotificationTypeQiang:
            title = @"抢购提醒";
            break;
        case RemindNotificationTypeMorning:
            title = @"早市提醒";
            break;
        case RemindNotificationTypeNight:
            title = @"晚市提醒";
            break;
        case RemindNotificationTypeWeekend:
            title = @"周末清仓";
            break;
        case RemindNotificationTypeProduct:
            title = @"商品抢购提醒";
            break;
        case RemindNotificationTypeOther:
            title = @"提醒信息";
            break;
        default:
            break;
    }
    
    return title;
}
@end
