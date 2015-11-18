//
//  TencentManager.h
//  KidsTC
//
//  Created by Altair on 11/16/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kTencentUrlScheme;
extern NSString *const kTencentAppKey;

@interface TencentManager : NSObject

@property (nonatomic, readonly) BOOL isOnline;

+ (instancetype)sharedManager;

- (BOOL)handleOpenURL:(NSURL *)url;

- (BOOL)sendLoginRequestWithSucceed:(void(^)(NSString *token))succeed failure:(void(^)(NSError *error))failure;

@end
