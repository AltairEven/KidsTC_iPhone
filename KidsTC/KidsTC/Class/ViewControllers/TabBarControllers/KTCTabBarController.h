//
//  KTCTabBarController.h
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKeyboardDelegate.h"

@interface KTCTabBarController : UITabBarController
{
    NSUInteger _selectTabBarButtonIndex;
}

@property (nonatomic, assign) id<GKeyboardDelegate> keyboardDelegate;

@property (nonatomic, readonly) NSUInteger tabCount;

+ (KTCTabBarController *)shareTabBarController;

- (NSUInteger)selectedButton;

- (void)createViewControllers;

- (void)setButtonSelected:(NSUInteger)index;

- (void)allPopToRoot;

- (void)logout;

- (void)gotoTabIndex:(int) index;

- (void)makeTabBarHidden:(BOOL)hidden;

- (void)setBadge:(NSString *)badgeString forTabIndex:(NSUInteger)index;

- (void)resetTheme:(AUITheme *)theme;

@end
