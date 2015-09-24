
//  GNavController.m
//  iphone
//
//  Created by icson apple on 12-2-17.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GNavController.h"
#import "GViewController.h"
#import "UINavigationBar+BackgroundColor.h"

@implementation GNavController

-(id)initWithRootViewController:(GViewController*)_rootViewController
{
	if(self = [super initWithRootViewController:_rootViewController])
	{
        UINavigationBar *navigationBar = [UINavigationBar appearance];
        [navigationBar setBarTintColor:COLOR_NAVIBAR];
        [navigationBar setBarStyle:UIBarStyleBlack];
//        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:18]};
	}

	return self;
}

-(void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	GViewController *currentController = [self.viewControllers lastObject];
	if (!currentController) {
		[super pushViewController: viewController animated: animated];
	} else {
		BOOL oldhidesBottomBarWhenPushed = currentController.hidesBottomBarWhenPushed;
		currentController.hidesBottomBarWhenPushed = NO;

		[super pushViewController: viewController animated: animated];
		currentController.hidesBottomBarWhenPushed = oldhidesBottomBarWhenPushed;
	}
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - StatusBarTitleColor

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}

@end
