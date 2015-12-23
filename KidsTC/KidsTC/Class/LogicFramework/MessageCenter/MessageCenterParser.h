/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：MessageCenterParser.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：haoquanbai
 * 完成日期：13-3-12
 */

#import "CommonParser.h"
#import "MTA.h"


typedef enum {
    RefreshMessage,
    LoadMoreMessage,
} MsgReqType;

@interface UserMessageCache : NSObject

+ (UserMessageCache *)sharedUserMessageCache;
+ (void)updateMessageCacheWithUid:(NSInteger)uid andNewCache:(NSArray *)newCache;
+ (NSArray *)getMessageCacheWithUid:(NSInteger)uid;

@end

@protocol MessageCenterParserDelegate <NSObject>
@optional
- (void)messageCenterDidGetSuccessWithData:(NSDictionary *)messageInfo andType:(MsgReqType)type;
- (void)messageCenterDidGetFailedWithError:(NSError *)error andType:(MsgReqType)type;
@end

@interface MessageCenterParser : CommonParser
{
}

@property (nonatomic, weak) id <MessageCenterParserDelegate> delegate;

- (id)initWithDelegate:(id<MessageCenterParserDelegate>)delegate;
- (void)loadMessageWithParams:(NSDictionary *)params andReqType:(MsgReqType)type;
- (void)setMessageStatusWithParams:(NSDictionary *)params;

@end
