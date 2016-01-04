//
//  AdditionalTabBarItemManager.h
//  KidsTC
//
//  Created by Altair on 1/3/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kAdditionalTabBarItemInfoPageUrlStringKey;
extern NSString *const kAdditionalTabBarItemInfoNormalImageKey;
extern NSString *const kAdditionalTabBarItemInfoSelectedImageKey;

@interface AdditionalTabBarItemManager : NSObject

+ (instancetype)sharedManager;

- (void)synchronizeAdditionalTabBarItem;

- (void)removeLocalData;

- (NSDictionary *)AdditionalTabBarItemInfo;

- (AUITheme *)themeWithAdditionalTabBarItemInfo:(AUITheme *)originalTheme;

@end
