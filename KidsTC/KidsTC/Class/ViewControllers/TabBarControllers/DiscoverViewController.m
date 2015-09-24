//
//  DiscoverViewController.m
//  ICSON
//
//  Created by 肖晓春 on 15/3/13.
//  Copyright (c) 2015年 肖晓春. All rights reserved.
//

#import "DiscoverViewController.h"
#import "KTCWebViewController.h"

NSString*const kDiscoveryUrl = @"http://m.zdm.yixun.com/list?wapBack=1";

@interface DiscoverViewController () <KTCWebViewControllerDelegate>

@property (nonatomic, strong) KTCWebViewController *webController;

@property (nonatomic, assign) BOOL bNeedRefresh;

- (void)initSubViews;

- (void)destorySubViews;

- (void)leftBar;

@end

@implementation DiscoverViewController

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    self.bNeedRefresh = NO;
    _navigationTitle = @"发现";
}


- (void)destorySubViews {
    [self.webController.webView stopLoading];
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    self.webController = nil;
}


- (void)initSubViews {
    self.webController = [[KTCWebViewController alloc] initWithNibName:@"KTCWebViewController" bundle:nil];
    self.webController.backToLink = NO;
    self.webController.delegate = self;
    [self.webController setWebUrlString:kDiscoveryUrl];
    [self.webController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ];
    [self.view addSubview:self.webController.view];
}


- (void)webViewControllerDidStartLoad:(KTCWebViewController *)controller {
//    if (self.webController.currentUrlString && [self.webController.currentUrlString length] > 0) {
//        if ([self.webController.currentUrlString rangeOfString:@"m.zdm.yixun.com/list"].length == 0) {
//            [self setupLeftBarButton];
//        } else {
//            self.navigationItem.leftBarButtonItem = nil;
//        }
//    } else {
//        self.navigationItem.leftBarButtonItem = nil;
//    }
     [self leftBar];
}

- (void)goBackController:(id)sender {
    [self.webController goBackController:sender];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (!self.webController.backToLink) {
        [self.webController setWebUrlString:kDiscoveryUrl];
    }
    self.bNeedRefresh = YES;
    [self leftBar];
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.bNeedRefresh = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh {
    if (self.bNeedRefresh) {
        [self.webController closeWebPage];
        [self destorySubViews];
        [self initSubViews];
        [self.webController setWebUrlString:kDiscoveryUrl];
    }
}

#pragma mark - method
- (void)leftBar
{
    if (self.webController.currentUrlString && [self.webController.currentUrlString length] > 0) {
        if ([self.webController.currentUrlString rangeOfString:@"m.zdm.yixun.com/list"].length == 0) {
            [self setupLeftBarButton];
        } else {
            self.navigationItem.leftBarButtonItem = nil;
        }
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}


#pragma mark GWebviewControllerDelegate

- (void)webViewController:(KTCWebViewController *)webController willPushToController:(UIViewController *)pushController animated:(BOOL)animated {
    [self.navigationController pushViewController:pushController animated:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
