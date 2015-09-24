/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：RemindManager.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：6/7/13
 */

#import "RemindManager.h"

@implementation RemindManager

+ (RemindManager *)sharedRemindManager
{
    static RemindManager * sharedRemindManager = nil;
    if (!sharedRemindManager)
    {
        sharedRemindManager = [[RemindManager alloc] init];
    }
    
    return sharedRemindManager;
}
- (id)init
{
    if (self = [super init])
    {
        
    }
    
    return self;
}

- (NSArray *)validNotifications
{
    NSMutableArray *validArr = [[NSMutableArray alloc] init];
    NSArray *notifArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *aNofiy in notifArr)
    {
        RemindNotification *aRemindNotif = [[RemindNotification alloc] initWithLocalNotification:aNofiy];
        [validArr addObject:aRemindNotif];
    }
    
    return validArr;
}

- (NSString *)alertBodyOfNotification:(RemindNotification *)aNotification
{
    NSArray * productList = aNotification.productList;
    NSString * alertMsg = nil;
    if ([productList count]>0)
    {
        NSString * nameStr = [NSString string];
        for (int i = 0; i<[productList count]; i++)
        {
            NSDictionary *aProduct = [productList objectAtIndex:i];
            NSString * name = [aProduct objectForKey:@"name"];
            
            /*商品名称过长时取30个字符*/
            if ([name length]>30)
            {
                name = [name substringToIndex:30];
                name = [name stringByAppendingString:@"..."];
            }
            
            if (name!= nil)
            {
                nameStr = [nameStr stringByAppendingString:name];
            }
            
            if (i<[productList count]-1)
            {
                nameStr = [nameStr stringByAppendingString:@","];
            }
        }
        
        alertMsg = [NSString stringWithFormat:@"您关注的\"%@\",已经开抢啦,限时限量,赶紧去抢购吧!", nameStr];
    }
    else if ([aNotification.message length]>0)
    {
        alertMsg = aNotification.message;
    }
    else
    {
        alertMsg = @"开抢提醒";
    }
    
    return alertMsg;
}
/*
 */
- (void)createNewLocalNofitication:(RemindNotification *)aNotification
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = aNotification.fireDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    // Notification details
    localNotif.alertBody = [self alertBodyOfNotification:aNotification];
    
    // Set the action button
    localNotif.alertAction = @"抢购";
    localNotif.hasAction = YES;
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    // Specify custom data for the notification
    NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
    if (aNotification.productList)
    {
        [infoDict setObject:aNotification.productList forKey:kRemindProductList];
    }
    [infoDict setObject:[NSNumber numberWithInt:aNotification.type] forKey:kRemindType];
    
    localNotif.userInfo = infoDict;
    
    // Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}
/*
 添加一个本地通知
 */
- (void)addRemindNotification:(RemindNotification *)aNotification
{
    /*
     合并相同类型时间到通知
     */
    
    /*查找是否有相同类型，相同提示时间到通知*/
    NSArray *notifArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
    UILocalNotification *theNofiy = nil;
    for (UILocalNotification *aNofiy in notifArr)
    {
        if (aNotification.type == [[aNofiy.userInfo objectForKey:kRemindType] intValue]
            && [aNofiy.fireDate isEqualToDate:aNotification.fireDate])
        {
            theNofiy = aNofiy;
            break;
        }
    }
        
    if (!theNofiy)
    {
        /*没有相同时间到通知*/
        [self createNewLocalNofitication:aNotification];
    }
    else
    {
        /*更新通知*/
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:theNofiy.userInfo];
        NSMutableArray *productList = [NSMutableArray arrayWithArray:[userInfo objectForKey:kRemindProductList]];
        NSArray * addProducts = aNotification.productList;
        
        /*查找要添加的商品是否已经存在*/
        for (NSDictionary *item in addProducts)
        {
            NSDictionary *product = nil;
            NSString * itemPid = IDTOSTRING(item[@"product_id"]);
            for (NSDictionary *aProduct in productList)
            {
                if (itemPid.length > 0 && [itemPid isEqualToString:IDTOSTRING(aProduct[@"product_id"])]) {
                    product = aProduct;
                    break;
                }
            }
            
            if (product != nil)
            {
                /*从原来列表中删除已经存在到商品*/
                [productList removeObject:product];
            }
            
        }
        
        /*将要添加到商品，添加到通知列表中*/
        [productList addObjectsFromArray:addProducts];
        [userInfo setObject:productList forKey:kRemindProductList];
        aNotification.productList = productList;
        
        /*取消原有通知，并创建新通知*/
        [[UIApplication sharedApplication] cancelLocalNotification:theNofiy];
        [self createNewLocalNofitication:aNotification];
    }
    
}

- (void)cancelRemindNotificationByProductID:(NSString*)pid ofType:(RemindNotificationType)type
{
    pid = IDTOSTRING(pid);
    NSArray *notifArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
    UILocalNotification *theNofiy = nil;
    NSMutableDictionary *userInfo = nil;
    for (UILocalNotification *aNofiy in notifArr)
    {
        NSDictionary *infoDict = aNofiy.userInfo;
        if ([[infoDict objectForKey:kRemindType] intValue] == type)
        {
            NSMutableArray *productList = [NSMutableArray arrayWithArray:[infoDict objectForKey:kRemindProductList]];
            /*抢购取消提醒根据商品ID*/
            NSDictionary *productInfo = nil;
            for (NSDictionary *aProductInfo in productList) {
                if (pid.length > 0 && [pid isEqualToString:IDTOSTRING(aProductInfo[@"product_id"])])
                {
                    productInfo = aProductInfo;
                    break;
                }
            }
            
            if (productInfo != nil)
            {
                /*删除提醒商品*/
                [productList removeObject:productInfo];
                /*更新商品列表*/
                userInfo = [NSMutableDictionary dictionaryWithDictionary:infoDict];
                [userInfo setObject:productList forKey:kRemindProductList];
                theNofiy = aNofiy;
                break;
            }
        }
    }
    
    if (theNofiy)
    {
        NSArray *prodcuts = [userInfo objectForKey:kRemindProductList];
        
        if ([prodcuts count]==0)
        {
            /*无商品信息时候取消提醒*/
            [[UIApplication sharedApplication] cancelLocalNotification:theNofiy];
        }
        else
        {
            theNofiy.userInfo = userInfo;
        }
    }
}
/*
 删除一个符合条件到本地通知。
 */
- (void)cancelRemindNotification:(RemindNotification *)aNotification
{
    /*
     取消匹配商品ID，通知类型，fireDate的通知
     */
    NSArray *notifArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
    UILocalNotification *theNotify = nil;
    for (UILocalNotification *aNotify in notifArr)
    {
        if (aNotification.type == [[aNotify.userInfo objectForKey:kRemindType] intValue]
            && [aNotify.fireDate isEqualToDate:aNotification.fireDate])
        {
            theNotify = aNotify;
            break;
        }
    }
    
    if (theNotify)
    {
        /*更新通知*/
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:theNotify.userInfo];
        NSMutableArray *productList = [NSMutableArray arrayWithArray:[userInfo objectForKey:kRemindProductList]];
        NSArray * removeProducts = aNotification.productList;
        
        /*查找要添加的商品是否已经存在*/
        for (NSDictionary *item in removeProducts)
        {
            NSDictionary *product = nil;
            NSString * itemPid = IDTOSTRING(item[@"product_id"]);
            for (NSDictionary *aProduct in productList)
            {
                if (itemPid.length > 0 && [itemPid isEqualToString:IDTOSTRING(aProduct[@"product_id"])]) {
                    product = aProduct;
                    break;
                }
            }
            
            if (product != nil)
            {
                /*从原来列表中删除已经存在到商品*/
                [productList removeObject:product];
            }
            
        }
        
        /*取消原有通知，并创建新通知*/
        [[UIApplication sharedApplication] cancelLocalNotification:theNotify];
        if ([productList count]>0)
        {
            /*
             未取消的商品通知，重新添加到通知队列中。
             */
            aNotification.productList = productList;
            [self createNewLocalNofitication:aNotification];
        }
    }
}
/*
 取消所有本地通知。
 */
- (void)cancelAllNofification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

/*
 是否已经添加商品到制定类型到提醒
 */
- (BOOL)hasRemindNotificationOfProductID:(NSString*)pid ofType:(RemindNotificationType)type
{
    BOOL inRemindList = NO;
    
    pid = IDTOSTRING(pid);
    NSArray *notifArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *aNotify in notifArr)
    {
        NSDictionary * userInfo = aNotify.userInfo;
        if ([[userInfo objectForKey:kRemindType] intValue] == type)
        {
            NSArray *productList = [userInfo objectForKey:kRemindProductList];
            for (NSDictionary *aProduct in productList)
            {
                if (pid.length > 0 && [pid isEqualToString:IDTOSTRING(aProduct[@"product_id"])])
                {
                    inRemindList = YES;
                    break;
                }
            }
        }
    }
    
    return inRemindList;
}

@end
