/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：MessageItem.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：haoquanbai
 * 完成日期：13-3-12
 */

#import <Foundation/Foundation.h>

typedef enum {
    MsgUnReaded = 0,
    MsgReaded = 1,
    MsgRemoved = 2,
} MessageStatus;

typedef enum {
    BizArrived = 1, // to product detail
    BizHomepage = 1001, // to homepage
    BizCharge = 1002, // to charge view
    BizCoupon = 1003, // to coupon fetch view
    BizChannelEvent = 1004, // to event channel on homepage, qiang, tuan, blah....
    BizWebpage = 1005, //web page
    BizMessageCenter = 1006, // message center
    BizProductDetail = 1007, // product detail with mPriceId
    BizRoll = 1008, // roll
    BizCommentReminder = 2001,   // to order detail
    BizCommentDeadline = 2002,   // to order detail
    BizGuijiupeiAccepted = 3001,   // web page
    BizGuijiupeiRefuse = 3002, // web page
    BizPriceGuardMatch = 3003,  // web page
    BizPriceGuardAccepted = 3004, // user point flow
    BizPriceGuardRefuse = 3005, // web page
    BizOrderApproach = 3006, // order detail
    BizFreshManCoupon = 4003, // my coupon list
    BizFeedbackHistory = 5001, // feedback history
    BizReturnAndChangeDetail = 6001, // return and change
} BizEventType;

@interface MessageItem : NSObject <NSCoding>

@property (nonatomic, strong) NSString *msgStr;
@property (nonatomic, strong) NSString *productID;
@property (nonatomic, strong) NSString *extraInfo;
@property (nonatomic, strong) NSString *productCharID;
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSInteger applyId;
@property (nonatomic) NSTimeInterval reportTime;
@property (nonatomic) MessageStatus status;
@property (nonatomic) NSInteger msgID;
@property (nonatomic) BizEventType eventType;

- (id)initWithRawData:(NSDictionary *)rawData;

@end
