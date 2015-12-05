//
//  KTCTabBarController.h
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKeyboardDelegate.h"


typedef enum {
    KTCTabHome = 0,
    KTCTabNews = 1,
    KTCTabParentingStrategy = 2,
    KTCTabUserCenter = 3
} KTCTabEnum;

@class HomeViewController;
@class ParentingStrategyViewController;
@class UserCenterViewController;
@class NewsViewController;

@interface KTCTabBarController : UITabBarController <UITabBarControllerDelegate>
{
    KTCTabEnum _selectTabBarButtonIndex;
    
}

@property (nonatomic, assign) id<GKeyboardDelegate> keyboardDelegate;
@property (nonatomic, strong) HomeViewController *homeVC;
@property (nonatomic, strong) NewsViewController *newsListVC;
@property (nonatomic, strong) ParentingStrategyViewController *parentingStrategyVC;
@property (nonatomic, strong) UserCenterViewController *userCenterVC;

@property (nonatomic, strong) UINavigationController *homeTab;
@property (nonatomic, strong) UINavigationController *newsTab;
@property (nonatomic, strong) UINavigationController *parentingStrategyTab;
@property (nonatomic, strong) UINavigationController *userCenterTab;

+ (KTCTabBarController *)shareTabBarController;
-(KTCTabEnum)selectedButton;
-(void)createViewControllers;
- (void)setButtonSelected:(KTCTabEnum) index;

- (void)allPopToRoot;
- (void)logout;
- (void)gotoTabIndex:(int) index;
- (void)makeTabBarHidden:(BOOL)hidden;

@end
