//
//  WeChatManager.h
//  KidsTC
//
//  Created by Altair on 11/16/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kWeChatUrlScheme;
extern NSString *const kWeChatAppKey;

@interface WeChatManager : NSObject

@property (nonatomic, readonly) BOOL isOnline;

+ (instancetype)sharedManager;

//程序启动时调用
- (BOOL)getOnline;

- (BOOL)handleOpenURL:(NSURL *)url;

- (BOOL)sendLoginRequestWithSucceed:(void(^)(NSString *token))succeed failure:(void(^)(NSError *error))failure;

@end
