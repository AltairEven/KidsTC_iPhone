//
//  KTCTabBarController.m
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCTabBarController.h"
#import "HomeViewController.h"
#import "NewsViewController.h"
#import "ParentingStrategyViewController.h"
#import "UserCenterViewController.h"
#import "KTCWebViewController.h"
#import "UITabBar+Badge.h"
#import "AdditionalTabBarItemManager.h"

static KTCTabBarController* _shareTabBarController = nil;

@interface KTCTabBarController () <UITabBarControllerDelegate>

- (void)didReceivedThemeChangedNotification:(NSNotification *)notify;

@end

@implementation KTCTabBarController

+ (KTCTabBarController*)shareTabBarController
{
    @synchronized([KTCTabBarController class])
    {
        if (!_shareTabBarController) {
            _shareTabBarController = [[self alloc] init];
            [_shareTabBarController.tabBar setBarTintColor:[[KTCThemeManager manager] defaultTheme].tabbarBGColor];
            //顶部边界线
//            [_shareTabBarController.tabBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
//            [_shareTabBarController.tabBar setBackgroundImage:[[UIImage alloc]init]];
        }
        
        return _shareTabBarController;
    }
    
    return nil;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)createViewControllers
{
    self.delegate = self;
    
    AUITheme *theme = [[AdditionalTabBarItemManager sharedManager] themeWithAdditionalTabBarItemInfo:[[KTCThemeManager manager] defaultTheme]];
    NSArray *tabBarItemElements = [theme tabbarItemElements];
    _tabCount = [tabBarItemElements count];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (AUITabbarItemElement *element in tabBarItemElements) {
        UIViewController *viewController = nil;
        switch (element.type) {
            case AUITabbarItemTypeHome:
            {
                viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            }
                break;
            case AUITabbarItemTypeNews:
            {
                viewController = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
            }
                break;
            case AUITabbarItemTypeStrategy:
            {
                viewController = [[ParentingStrategyViewController alloc] initWithNibName:@"ParentingStrategyViewController" bundle:nil];
            }
                break;
            case AUITabbarItemTypeUserCenter:
            {
                viewController = [[UserCenterViewController alloc] initWithNibName:@"UserCenterViewController" bundle:nil];
            }
                break;
            case AUITabbarItemTypeAdditional:
            {
                viewController = [[KTCWebViewController alloc] init];
                [(KTCWebViewController *)viewController setIsRootVC:YES];
                [(KTCWebViewController *)viewController setWebUrlString:[[element userInfo] objectForKey:kAdditionalTabBarItemInfoPageUrlStringKey]];
            }
                break;
            default:
                break;
        }
        if (viewController) {
            UINavigationController *naviController = [[GNavController alloc] initWithRootViewController:viewController];
            naviController.tabBarItem.title = element.tabbarItemTitle;
            if (element.tabbarTitleColor_Normal) {
                [naviController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:element.tabbarTitleColor_Normal forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
            }
            if (element.tabbarTitleColor_Highlight) {
                [naviController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:element.tabbarTitleColor_Highlight forKey:NSForegroundColorAttributeName] forState:UIControlStateHighlighted];
            }
            naviController.tabBarItem.image = [element.tabbarItemImage_Normal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            naviController.tabBarItem.selectedImage = [element.tabbarItemImage_Highlight imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [tempArray addObject:naviController];
        }
    }
    
    
    [self setViewControllers:[NSArray arrayWithArray:tempArray] animated: YES];
    
    _selectTabBarButtonIndex = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivedThemeChangedNotification:) name:kThemeDidChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangedNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if ([viewController respondsToSelector:@selector(popToRootViewControllerAnimated:)])
    {
        [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
    }
    
    for (NSUInteger index = 0; index < self.tabCount; index ++) {
        if (viewController == [self.viewControllers objectAtIndex:index]) {
            [self setBadge:nil forTabIndex:index];
            if (_selectTabBarButtonIndex == index) {
                UIViewController *controller = [(UINavigationController *)viewController topViewController];
                if ([controller isKindOfClass:[KTCWebViewController class]]) {
                    [[(KTCWebViewController *)controller webView] reload];
                }
            }
            _selectTabBarButtonIndex = index;
            break;
        }
    }
    
    return YES;
}

- (UIViewController *)rootViewControllerAtIndex:(NSUInteger)index {
    if (index < [self.viewControllers count])
    {
        UINavigationController *naviController = [self.viewControllers objectAtIndex:index];
        if ([naviController isKindOfClass:[UINavigationController class]]) {
            return [[naviController viewControllers] objectAtIndex:0];
        }
    }
    return nil;
}

- (NSUInteger)selectedButton
{
    return _selectTabBarButtonIndex;
}

- (void)logout
{
    [self setButtonSelected:0];
}

- (void)setButtonSelected:(NSUInteger)index
{
    if (index < [self.viewControllers count])
    {
        UIViewController *willSelectedController = [self.viewControllers objectAtIndex:index];
        if ([willSelectedController respondsToSelector:@selector(popToRootViewControllerAnimated:)])
        {
            [(UINavigationController *)willSelectedController popToRootViewControllerAnimated:NO];
        }
        
        self.selectedIndex = index;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if (self.keyboardDelegate) {
        [self.keyboardDelegate gKeyboardRect: CGRectZero animationDuration: animationDuration];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if (self.keyboardDelegate) {
        [self.keyboardDelegate gKeyboardRect: keyboardRect animationDuration: animationDuration];
    }
}

- (void)allPopToRoot
{
    NSArray *naviControllers = [self viewControllers];
    for (UINavigationController *navi in naviControllers) {
        [navi popToRootViewControllerAnimated:NO];
    }
}

- (void)gotoTabIndex:(int) index
{
    //    self.tabBarController.selectedIndex = index;
    self.selectedIndex = index;
}

- (void)makeTabBarHidden:(BOOL)hidden
{
    if ( [self.view.subviews count] < 2 )
        return;
    
    UIView *contentView;
    
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.view.subviews objectAtIndex:1];
    else
        contentView = [self.view.subviews objectAtIndex:0];
    
    if ( hidden ){
        contentView.frame = self.view.bounds;
    }
    else{
        contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.origin.y,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height - self.tabBar.frame.size.height);
    }
    
    self.tabBar.hidden = hidden;
}

- (void)setBadge:(NSString *)badgeString forTabIndex:(NSUInteger)index {
    if ([self selectedButton] == 0) {
        return;
    }
    [self.tabBar setBadgeWithValue:badgeString atIndex:(int)index];
}

- (void)didReceivedThemeChangedNotification:(NSNotification *)notify {
    if (!notify || ![notify.name isEqualToString:kThemeDidChangedNotification]) {
        return;
    }
    [self resetTheme:notify.object];
}

- (void)resetTheme:(AUITheme *)theme {
    if (!theme || ![theme isKindOfClass:[AUITheme class]]) {
        return;
    }
    [self.tabBar setBarTintColor:theme.tabbarBGColor];
    
    NSUInteger themeTabCount = [theme.tabbarItemElements count];
    if (self.tabCount != themeTabCount) {
        return;
    }
    
    for (NSUInteger index = 0; index < [self.viewControllers count]; index ++) {
        UINavigationController *naviController = [self.viewControllers objectAtIndex:index];
        AUITabbarItemElement *element = [theme.tabbarItemElements objectAtIndex:index];
        naviController.tabBarItem.title = element.tabbarItemTitle;
        if (element.tabbarTitleColor_Normal) {
            [naviController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:element.tabbarTitleColor_Normal forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
        }
        if (element.tabbarTitleColor_Highlight) {
            [naviController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:element.tabbarTitleColor_Highlight forKey:NSForegroundColorAttributeName] forState:UIControlStateHighlighted];
        }
        naviController.tabBarItem.image = [element.tabbarItemImage_Normal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        naviController.tabBarItem.selectedImage = [element.tabbarItemImage_Highlight imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}

@end
