//
//  KTCWebViewController.h
//  KidsTC
//
//  Created by 钱烨 on 9/15/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "GViewController.h"

@class KTCWebViewController;

@protocol KTCWebViewControllerDelegate <NSObject>

- (void)webViewControllerDidStartLoad:(KTCWebViewController *)controller;

- (void)webViewController:(KTCWebViewController *)webController willPushToController:(UIViewController *)pushController animated:(BOOL)animated;

@end

@interface KTCWebViewController : GViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (assign, nonatomic) BOOL backToLink;
@property (copy, nonatomic) NSString *webUrlString;
@property (nonatomic, assign) id<KTCWebViewControllerDelegate> delegate;
@property (nonatomic, readonly, strong) NSString *currentUrlString;

/*
 关闭web页面
 */
- (void)closeWebPage;

@end
