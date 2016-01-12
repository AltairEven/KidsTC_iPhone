
//  GNavController.m
//  iphone
//
//  Created by icson apple on 12-2-17.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GNavController.h"
#import "GViewController.h"
#import "UINavigationBar+BackgroundColor.h"

@interface GNavController ()

@end

@implementation GNavController

-(id)initWithRootViewController:(GViewController*)_rootViewController
{
	if(self = [super initWithRootViewController:_rootViewController])
	{
        UINavigationBar *navigationBar = [UINavigationBar appearance];
        UIColor *color = [[KTCThemeManager manager] defaultTheme].navibarBGColor;
//        CGRect frame = self.navigationBar.frame;
//        alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
//        alphaView.backgroundColor = color;
//        [self.view insertSubview:alphaView belowSubview:self.navigationBar];
//        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bigShadow.png"] forBarMetrics:UIBarMetricsCompact];
//        self.navigationBar.layer.masksToBounds = YES;
//        [self.navigationBar setTranslucent:YES];
        [navigationBar setBarTintColor:color];
        CGFloat white = 0.0;
        [color getWhite:&white alpha:NULL];
        if (white > 0.8) {
            [navigationBar setBarStyle:UIBarStyleDefault];
        } else {
            [navigationBar setBarStyle:UIBarStyleBlack];
        }
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:18]};
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



- (void)setNavigationBarAlpha:(CGFloat)alpha {
    alphaView.alpha = alpha;
}

//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}

@end
