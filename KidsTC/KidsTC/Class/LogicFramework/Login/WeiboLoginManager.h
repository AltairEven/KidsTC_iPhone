//
//  WeiboLoginManager.h
//  KidsTC
//
//  Created by 钱烨 on 11/5/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"
#import "WeiboUser.h"

extern NSString *const kWeiboAppKey;

@interface WeiboLoginManager : NSObject <WeiboSDKDelegate>

@property (nonatomic, readonly) BOOL isOnline;

+ (instancetype)sharedManager;

- (BOOL)sendLoginRequest;

@end
