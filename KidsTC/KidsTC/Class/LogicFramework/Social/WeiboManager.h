//
//  WeiboManager.h
//  KidsTC
//
//  Created by Altair on 11/16/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kWeiboUrlScheme;
extern NSString *const kWeiboAppKey;

@interface WeiboManager : NSObject

@property (nonatomic, readonly) BOOL isOnline;

+ (instancetype)sharedManager;

- (BOOL)handleOpenURL:(NSURL *)url;

- (BOOL)sendLoginRequestWithSucceed:(void(^)(NSString *token))succeed failure:(void(^)(NSError *error))failure;

- (BOOL)sendShareRequestWithContentTag:(NSString *)tag
                                 imgae:(UIImage *)image
                         linkUrlString:(NSString *)urlString
                               succeed:(void(^)(NSString *token))succeed
                               failure:(void(^)(NSError *error))failure;

@end
