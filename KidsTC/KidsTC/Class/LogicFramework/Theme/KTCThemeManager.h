//
//  KTCThemeManager.h
//  KidsTC
//
//  Created by Altair on 12/24/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AUITheme.h"

@interface KTCThemeManager : NSObject

@property (nonatomic, strong, readonly) AUITheme *currentTheme;

+ (instancetype)manager;

- (void)setTheme:(AUITheme *)theme;

@end
