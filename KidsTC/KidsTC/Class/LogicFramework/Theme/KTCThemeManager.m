//
//  KTCThemeManager.m
//  KidsTC
//
//  Created by Altair on 12/24/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "KTCThemeManager.h"


static KTCThemeManager *_sharedInstance = nil;

@interface KTCThemeManager ()

@end

@implementation KTCThemeManager
@synthesize currentTheme = _currentTheme;

+ (instancetype)manager {
    static dispatch_once_t token = 0;
    
    dispatch_once(&token, ^{
        _sharedInstance = [[KTCThemeManager alloc] init];
    });
    
    return _sharedInstance;
}

- (AUITheme *)currentTheme {
    if (!_currentTheme) {
        _currentTheme = [AUITheme defaultTheme];
    }
    return _currentTheme;
}

- (void)setTheme:(AUITheme *)theme {
    if (!theme) {
        return;
    }
    _currentTheme = [theme copy];
}

@end
