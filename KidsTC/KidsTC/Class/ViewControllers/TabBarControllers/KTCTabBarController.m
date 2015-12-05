//
//  KTCTabBarController.m
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCTabBarController.h"
#import "GNavController.h"
#import "HomeViewController.h"
#import "NewsViewController.h"
#import "ParentingStrategyViewController.h"
#import "UserCenterViewController.h"
#import "KTCSearchViewController.h"

@interface KTCTabBarController ()

@end

@implementation KTCTabBarController

static KTCTabBarController* _shareTabBarController = nil;

+ (KTCTabBarController*)shareTabBarController
{
    @synchronized([KTCTabBarController class])
    {
        if (!_shareTabBarController) {
            _shareTabBarController = [[self alloc] init];
            [_shareTabBarController.tabBar setBarTintColor:[AUITheme theme].tabbarBGColor];
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
    self.homeVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.homeTab = [[GNavController alloc] initWithRootViewController:self.homeVC];
    self.homeTab.tabBarItem.title = @"首页";
    [self.homeTab.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[AUITheme theme].tabbarTitleColor_Normal forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
    [self.homeTab.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[AUITheme theme].tabbarTitleColor_Highlight forKey:NSForegroundColorAttributeName] forState:UIControlStateHighlighted];
    self.homeTab.tabBarItem.image = [[AUITheme theme].tabbar1Image_Normal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.homeTab.tabBarItem.selectedImage = [[AUITheme theme].tabbar1Image_Highlight imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.newsListVC = [[NewsViewController alloc]initWithNibName:@"NewsViewController" bundle:nil];
    self.newsTab = [[GNavController alloc] initWithRootViewController:self.newsListVC];
    self.newsTab.tabBarItem.title = @"知识库";
    [self.newsTab.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[AUITheme theme].tabbarTitleColor_Normal forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
    [self.newsTab.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[AUITheme theme].tabbarTitleColor_Highlight forKey:NSForegroundColorAttributeName] forState:UIControlStateHighlighted];
    self.newsTab.tabBarItem.image = [[AUITheme theme].tabbar2Image_Normal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.newsTab.tabBarItem.selectedImage = [[AUITheme theme].tabbar2Image_Highlight imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.parentingStrategyVC = [[ParentingStrategyViewController alloc]initWithNibName:@"ParentingStrategyViewController" bundle:nil];
    self.parentingStrategyTab = [[GNavController alloc] initWithRootViewController:self.parentingStrategyVC];
    self.parentingStrategyTab.tabBarItem.title = @"亲子攻略";
    [self.parentingStrategyTab.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[AUITheme theme].tabbarTitleColor_Normal forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
    [self.parentingStrategyTab.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[AUITheme theme].tabbarTitleColor_Highlight forKey:NSForegroundColorAttributeName] forState:UIControlStateHighlighted];
    self.parentingStrategyTab.tabBarItem.image = [[AUITheme theme].tabbar3Image_Normal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.parentingStrategyTab.tabBarItem.selectedImage = [[AUITheme theme].tabbar3Image_Highlight imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.userCenterVC = [[UserCenterViewController alloc]initWithNibName:@"UserCenterViewController" bundle:nil];
    self.userCenterTab = [[GNavController alloc] initWithRootViewController:self.userCenterVC];
    self.userCenterTab.tabBarItem.title = @"我";
    [self.userCenterTab.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[AUITheme theme].tabbarTitleColor_Normal forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
    [self.userCenterTab.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[AUITheme theme].tabbarTitleColor_Highlight forKey:NSForegroundColorAttributeName] forState:UIControlStateHighlighted];
    self.userCenterTab.tabBarItem.image = [[AUITheme theme].tabbar4Image_Normal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.userCenterTab.tabBarItem.selectedImage = [[AUITheme theme].tabbar4Image_Highlight imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self setViewControllers:[NSArray arrayWithObjects: self.homeTab, self.newsTab, self.parentingStrategyTab, self.userCenterTab, nil] animated: YES];
    
    _selectTabBarButtonIndex = KTCTabHome;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    
    if (viewController == self.homeTab) {
        _selectTabBarButtonIndex = KTCTabHome;
    }
    else if(viewController == self.newsTab)
    {
        _selectTabBarButtonIndex = KTCTabNews;
    }
    else if(viewController == self.parentingStrategyTab)
    {
        _selectTabBarButtonIndex = KTCTabParentingStrategy;
    }
    else if(viewController == self.userCenterTab)
    {
        _selectTabBarButtonIndex = KTCTabUserCenter;
    }
    
    return YES;
}

- (KTCTabEnum)selectedButton
{
    return _selectTabBarButtonIndex;
}

- (void)logout
{
    [self setButtonSelected:KTCTabHome];
}

- (void)setButtonSelected:(KTCTabEnum)index
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
    [self.homeTab popToRootViewControllerAnimated:NO];
    [self.newsTab popToRootViewControllerAnimated:NO];
    [self.parentingStrategyTab popToRootViewControllerAnimated:NO];
    [self.userCenterTab popToRootViewControllerAnimated:NO];
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


- (UIViewController *)rootViewCtrlOfIndex:(KTCTabEnum)index
{
    UIViewController * aViewCtrl = nil;
    switch (index) {
        case KTCTabHome:
            aViewCtrl = self.homeVC;
            break;
        case KTCTabNews:
            aViewCtrl = self.newsListVC;
            break;
        case KTCTabParentingStrategy:
            aViewCtrl = self.parentingStrategyVC;
            break;
        case KTCTabUserCenter:
            aViewCtrl = self.userCenterVC;
            break;
        default:
            break;
    }
    
    return aViewCtrl;
}

@end
