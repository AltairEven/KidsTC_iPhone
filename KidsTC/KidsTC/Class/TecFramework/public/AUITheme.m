//
//  AUITheme.m
//  KidsTC
//
//  Created by 钱烨 on 10/13/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "AUITheme.h"

static AUITheme *_sharedInstance = nil;

@interface AUITheme ()

@end

@implementation AUITheme

+ (instancetype)theme {
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        _sharedInstance = [[AUITheme alloc] init];
    });
    return _sharedInstance;
}

#pragma mark Global

- (UIColor *)globalThemeColor {
    if (!_globalThemeColor) {
        _globalThemeColor = RGBA(255, 136, 136, 1);
    }
    return _globalThemeColor;
}

- (UIColor *)globalBGColor {
    if (!_globalBGColor) {
        _globalBGColor = RGBA(252, 248, 245, 1);
    }
    return _globalBGColor;
}

- (UIColor *)globalCellBGColor {
    if (!_globalCellBGColor) {
        _globalCellBGColor = RGBA(255, 255, 255, 1);
    }
    return _globalCellBGColor;
}

- (UIColor *)darkTextColor {
    if (!_darkTextColor) {
        _darkTextColor = RGBA(85, 85, 85, 1);
    }
    return _darkTextColor;
}

- (UIColor *)lightTextColor {
    if (!_lightTextColor) {
        _lightTextColor = RGBA(170, 170, 170, 1);
    }
    return _lightTextColor;
}

- (UIColor *)buttonBGColor_Normal {
    if (!_buttonBGColor_Normal) {
        _buttonBGColor_Normal = RGBA(255, 136, 136, 1);
    }
    return _buttonBGColor_Normal;
}

- (UIColor *)buttonBGColor_Highlight {
    if (!_buttonBGColor_Highlight) {
        _buttonBGColor_Highlight = RGBA(230, 120, 120, 1);
    }
    return _buttonBGColor_Highlight;
}

- (UIColor *)buttonBGColor_Disable {
    if (!_buttonBGColor_Disable) {
        _buttonBGColor_Disable = RGBA(230, 230, 230, 1);
    }
    return _buttonBGColor_Disable;
}

#pragma mark NaviBar

- (UIColor *)navibarBGColor {
    if (!_navibarBGColor) {
        _navibarBGColor = RGBA(255, 136, 136, 1);
    }
    return _navibarBGColor;
}

- (UIColor *)navibarTitleColor_Normal {
    if (!_navibarTitleColor_Normal) {
        _navibarTitleColor_Normal = RGBA(255, 255, 255, 1);
    }
    return _navibarTitleColor_Normal;
}

- (UIColor *)navibarTitleColor_Highlight {
    if (!_navibarTitleColor_Highlight) {
        _navibarTitleColor_Highlight = RGBA(230, 230, 230, 1);
    }
    return _navibarTitleColor_Highlight;
}

- (UIImage *)naviBackImage_Normal {
    if (!_naviBackImage_Normal) {
        _naviBackImage_Normal = [UIImage imageNamed:@"navi_back"];
    }
    return _naviBackImage_Normal;
}

- (UIImage *)naviBackImage_Highlight {
    if (!_naviBackImage_Highlight) {
        _naviBackImage_Highlight = [UIImage imageNamed:@"navi_back"];
    }
    return _naviBackImage_Highlight;
}

#pragma mark Tabbar

- (UIColor *)tabbarBGColor {
    if (!_tabbarBGColor) {
        _tabbarBGColor = RGBA(252, 248, 245, 1);
    }
    return _tabbarBGColor;
}

- (UIColor *)tabbarTitleColor_Normal {
    if (!_tabbarTitleColor_Normal) {
        _tabbarTitleColor_Normal = RGBA(175, 158, 139, 1);
    }
    return _tabbarTitleColor_Normal;
}

- (UIColor *)tabbarTitleColor_Highlight {
    if (!_tabbarTitleColor_Highlight) {
        _tabbarTitleColor_Highlight = RGBA(255, 136, 136, 1);
    }
    return _tabbarTitleColor_Highlight;
}

- (UIImage *)tabbar1Image_Normal {
    if (!_tabbar1Image_Normal) {
        _tabbar1Image_Normal = [UIImage imageNamed:@"tabbar_home_n"];
    }
    return _tabbar1Image_Normal;
}

- (UIImage *)tabbar1Image_Highlight {
    if (!_tabbar1Image_Highlight) {
        _tabbar1Image_Highlight = [UIImage imageNamed:@"tabbar_home_h"];
    }
    return _tabbar1Image_Highlight;
}

- (UIImage *)tabbar2Image_Normal {
    if (!_tabbar2Image_Normal) {
        _tabbar2Image_Normal = [UIImage imageNamed:@"tabbar_discovery_n"];
    }
    return _tabbar2Image_Normal;
}

- (UIImage *)tabbar2Image_Highlight {
    if (!_tabbar2Image_Highlight) {
        _tabbar2Image_Highlight = [UIImage imageNamed:@"tabbar_discovery_h"];
    }
    return _tabbar2Image_Highlight;
}

- (UIImage *)tabbar3Image_Normal {
    if (!_tabbar3Image_Normal) {
        _tabbar3Image_Normal = [UIImage imageNamed:@"tabbar_parantingStrategy_n"];
    }
    return _tabbar3Image_Normal;
}

- (UIImage *)tabbar3Image_Highlight {
    if (!_tabbar3Image_Highlight) {
        _tabbar3Image_Highlight = [UIImage imageNamed:@"tabbar_parantingStrategy_h"];
    }
    return _tabbar3Image_Highlight;
}

- (UIImage *)tabbar4Image_Normal {
    if (!_tabbar4Image_Normal) {
        _tabbar4Image_Normal = [UIImage imageNamed:@"tabbar_userCenter_n"];
    }
    return _tabbar4Image_Normal;
}

- (UIImage *)tabbar4Image_Highlight {
    if (!_tabbar4Image_Highlight) {
        _tabbar4Image_Highlight = [UIImage imageNamed:@"tabbar_userCenter_h"];
    }
    return _tabbar4Image_Highlight;
}

@end
