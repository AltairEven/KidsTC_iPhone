//
//  HomeViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewModel.h"
#import "KTCSearchViewController.h"
#import "CategoryViewController.h"
#import "AUIFloorNavigationView.h"
#import "UserRoleSelectViewController.h"
#import "KTCSegueMaster.h"
#import "HomeActivityService.h"
#import "KTCWebViewController.h"

#define ActivityWebViewClosePrefix (@"hook::close_activity::")
#define ActivityWebViewJumpPrefix (@"hook::jump_activity::")


@interface HomeViewController () <HomeViewDelegate, AUIFloorNavigationViewDataSource, AUIFloorNavigationViewDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet HomeView *homeView;
@property (weak, nonatomic) IBOutlet AUIFloorNavigationView *floorNavigationView;

@property (weak, nonatomic) IBOutlet UIImageView *activityThumbView;

@property (nonatomic, strong) HomeViewModel *viewModel;

@property (nonatomic, copy) NSString *sysNo;

@property (nonatomic, strong) HomeActivityService *activityService;

@property (nonatomic, strong) UIWebView *activityWebView;

- (void)userRoleHasChanged:(id)info;

- (void)themeDidChanged:(NSNotification *)notify;

- (void)resetHotSearchKeyWord;

- (void)createActivityViews;

- (void)didClickedOnActivityThumbView:(id)sender;

- (void)resetRightViews;

@end

@implementation HomeViewController

- (instancetype)initWithSysNo:(NSString *)number {
    self = [super initWithNibName:@"HomeViewController" bundle:nil];
    if (self) {
        self.sysNo = number;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIdentifier = @"pv_home";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRoleHasChanged:) name:UserRoleHasChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChanged:) name:kThemeDidChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetHotSearchKeyWord) name:kSearchHotKeysHasChangedNotification object:nil];
    // Do any additional setup after loading the view from its nib.
    self.homeView.delegate = self;
    self.floorNavigationView.dataSource = self;
    self.floorNavigationView.delegate = self;
    [self.floorNavigationView setEnableCollapse:YES];
    [self.floorNavigationView setAnimateDirection:AUIFloorNavigationViewAnimateDirectionDown];
    [self.homeView resetTopRoleWithImage:[KTCUserRole smallImageWithUserRole:[KTCUser currentUser].userRole]];
    
    self.viewModel = [[HomeViewModel alloc] initWithView:self.homeView];
    
    __weak HomeViewController *weakSelf = self;
    if ([self.sysNo length] > 0) {
        [weakSelf.viewModel refreshHomeDataWithSysNo:weakSelf.sysNo succeed:^(NSDictionary *data) {
            [weakSelf.floorNavigationView reloadData];
            [weakSelf.floorNavigationView setSelectedIndex:0];
        } failure:nil];
    } else {
        [weakSelf.viewModel startUpdateDataWithSucceed:^(NSDictionary *data) {
            [weakSelf.floorNavigationView reloadData];
            [weakSelf.floorNavigationView setSelectedIndex:0];
        } failure:nil];
    }
    
    //热门搜索词
    [self resetHotSearchKeyWord];
    //活动
    self.activityService = [[HomeActivityService alloc] init];
    [self.activityService synchronizeActivitySuccess:^(HomeActivity *activity) {
        [weakSelf createActivityViews];
    } failure:^(NSError *error) {
        [weakSelf createActivityViews];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.activityService.currentActivity) {
        if (![self.activityService.currentActivity hasDisplayedWebPage]) {
            //未显示过的活动
            NSURL *url = [NSURL URLWithString:[self.activityService.currentActivity pageUrlString]];
            if (url) {
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [self.activityWebView loadRequest:request];
            }
        }
        [self resetRightViews];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UserRoleHasChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangedNotification object:nil];
}

#pragma mark HomeViewDelegate

- (void)didClickedCategoryButtonOnHomeView:(HomeView *)homeView {
    CategoryViewController *controller = [[CategoryViewController alloc] initWithNibName:@"CategoryViewController" bundle:nil];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickedInputFieldOnHomeView:(HomeView *)homeView {
    KTCSearchViewController *controller = [[KTCSearchViewController alloc] initWithNibName:@"KTCSearchViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:NO];
}

- (void)didClickedRoleButtonOnHomeView:(HomeView *)homeView {
    UserRoleSelectViewController *controller = [[UserRoleSelectViewController alloc] initWithNibName:@"UserRoleSelectViewController" bundle:nil];
    
    __weak UserRoleSelectViewController *weakController = controller;
    [controller setCompleteBlock:^(UserRole selectedRole, KTCSex selectedSex){
        KTCUserRole *role = [KTCUserRole instanceWithRole:selectedRole sex:selectedSex];
        [[KTCUser currentUser] setUserRole:role];
        [weakController.navigationController popViewControllerAnimated:YES];
        [self.homeView resetTopRoleWithImage:[KTCUserRole smallImageWithUserRole:role]];
    }];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)homeViewDidPulledDownToRefresh:(HomeView *)homeView {
    [self.viewModel refreshHomeDataWithSucceed:^(NSDictionary *data) {
        [self.floorNavigationView reloadData];
        [self.floorNavigationView setSelectedIndex:0];
    } failure:nil];
}

- (void)homeViewDidPulledUpToloadMore:(HomeView *)homeView {
    [self.viewModel getCustomerRecommendWithSucceed:nil failure:nil];
}

- (void)homeView:(HomeView *)homeView didClickedAtCoordinate:(HomeClickCoordinate)coordinate {
    HomeSegueModel *segueModel = nil;
    if (coordinate.sectionIndex >= [self.viewModel.homeModel.allSectionModels count]) {
        //推荐
        HomeSectionModel *sectionModel = [[self.viewModel sectionModelsArray] objectAtIndex:coordinate.sectionIndex];
        if (coordinate.isTitle) {
            segueModel = sectionModel.titleModel.segueModel;
        } else if (coordinate.contentIndex >= 0) {
            NSArray *elementsArray = [sectionModel.contentModel elementModelsArray];
            if ([elementsArray count] > coordinate.contentIndex) {
                segueModel = ((HomeElementBaseModel *)[elementsArray objectAtIndex:coordinate.contentIndex]).segueModel;
            }
        }
    } else {
        //首页
        segueModel = [self.viewModel.homeModel segueModelAtHomeClickCoordinate:coordinate];
    }
    [KTCSegueMaster makeSegueWithModel:segueModel fromController:self];
}

- (void)homeView:(HomeView *)homeView didScrolled:(CGPoint)offset {
    [self.floorNavigationView collapse:YES];
}

- (void)homeView:(HomeView *)homeView didScrolledIntoVisionWithFloorIndex:(NSUInteger)index {
    for (NSUInteger naviIndex = 0; naviIndex < [self.viewModel.homeModel.allNaviControlledFloors count]; naviIndex ++) {
        HomeFloorModel *floorModel = [self.viewModel.homeModel.allNaviControlledFloors objectAtIndex:naviIndex];
        if (floorModel.floorIndex == index) {
            [self.floorNavigationView setSelectedIndex:naviIndex];
            break;
        }
    }
}

- (void)homeView:(HomeView *)homeView didEndDeDidEndDecelerating:(BOOL)downDirection {
    if (downDirection) {
        [self.floorNavigationView setSelectedIndex:0];
    } else {
        [self.floorNavigationView setSelectedIndex:[self.viewModel.homeModel.allNaviControlledFloors count] - 1];
    }
}

#pragma mark AUIFloorNavigationViewDataSource & AUIFloorNavigationViewDelegate

- (NSUInteger)numberOfItemsOnFloorNavigationView:(AUIFloorNavigationView *)navigationView {
    return [self.viewModel.homeModel.allNaviControlledFloors count];
}

- (UIView *)floorNavigationView:(AUIFloorNavigationView *)navigationView viewForItemAtIndex:(NSUInteger)index {
    HomeFloorModel *floorModel = [self.viewModel.homeModel.allNaviControlledFloors objectAtIndex:index];
    
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [itemView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    UILabel *label = [[UILabel alloc] initWithFrame:itemView.frame];
    [label setText:floorModel.floorName];
    [label setFont:[UIFont systemFontOfSize:13]];
    [label setTextColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    [itemView addSubview:label];
    
    itemView.layer.cornerRadius = 20;
    itemView.layer.borderWidth = 2;
    itemView.layer.borderColor = [[KTCThemeManager manager] defaultTheme].globalThemeColor.CGColor;
    itemView.layer.masksToBounds = YES;
    
    return itemView;
}

- (UIView *)floorNavigationView:(AUIFloorNavigationView *)navigationView highlightViewForItemAtIndex:(NSUInteger)index {
    HomeFloorModel *floorModel = [self.viewModel.homeModel.allNaviControlledFloors objectAtIndex:index];
    
    UIView *highlightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [highlightView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    UILabel *label = [[UILabel alloc] initWithFrame:highlightView.frame];
    [label setText:floorModel.floorName];
    [label setFont:[UIFont systemFontOfSize:13]];
    [label setTextColor:[[KTCThemeManager manager] defaultTheme].navibarTitleColor_Normal];
    [label setTextAlignment:NSTextAlignmentCenter];
    [highlightView addSubview:label];
    
    highlightView.layer.cornerRadius = 20;
    highlightView.layer.borderWidth = 2;
    highlightView.layer.borderColor = [[KTCThemeManager manager] defaultTheme].globalBGColor.CGColor;
    highlightView.layer.masksToBounds = YES;
    
    return highlightView;
}

- (UIView *)floorNavigationView:(AUIFloorNavigationView *)navigationView viewForItemGapAtIndex:(NSUInteger)index {
    UIView *gapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
    [gapView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    return gapView;
}

- (void)floorNavigationView:(AUIFloorNavigationView *)navigationView didSelectedAtIndex:(NSUInteger)index {
    HomeFloorModel *floorModel = [self.viewModel.homeModel.allNaviControlledFloors objectAtIndex:index];
    [self.homeView scrollHomeViewToFloorIndex:floorModel.floorIndex];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL * requestUrl = [request URL];
    NSString *urlString = [requestUrl absoluteString];
    if ([urlString hasPrefix:ActivityWebViewClosePrefix]) {
        [self.activityWebView setHidden:YES];
        [self.activityWebView removeFromSuperview];
        return NO;
    } else if ([urlString hasPrefix:ActivityWebViewJumpPrefix]) {
        [self.activityWebView setHidden:YES];
        [self.activityWebView removeFromSuperview];
        
        NSString *paramString = [urlString substringFromIndex:[ActivityWebViewJumpPrefix length]];
        NSDictionary *params = [GToolUtil parsetUrl:paramString];
        NSString *linkString = @"";
        if (params) {
            linkString = [params objectForKey:@"url"];
        }
        if ([linkString length] == 0) {
            linkString = self.activityService.currentActivity.linkUrlString;
        }
        
        if ([linkString length] != 0) {
            KTCWebViewController *controller = [[KTCWebViewController alloc] init];
            [controller setWebUrlString:self.activityService.currentActivity.linkUrlString];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (![webView isLoading]) {
        [self.activityWebView setHidden:NO];
        [self.activityWebView.superview bringSubviewToFront:self.activityWebView];
        [self.activityService setHasDisplayedWebPage];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"load webview error:%@", error);
}

#pragma mark Private method

- (void)userRoleHasChanged:(id)info {
    [self.viewModel refreshHomeDataWithSucceed:^(NSDictionary *data) {
        [self.homeView resetTopRoleWithImage:[KTCUserRole smallImageWithUserRole:[KTCUser currentUser].userRole]];
        [self.floorNavigationView reloadData];
        [self.floorNavigationView setSelectedIndex:0];
    } failure:nil];
}

- (void)themeDidChanged:(NSNotification *)notify {
    if (!notify || ![notify.name isEqualToString:kThemeDidChangedNotification]) {
        return;
    }
    if (!notify || ![notify.object isKindOfClass:[AUITheme class]]) {
        return;
    }
    [self.homeView resetTopViewWithBGColor:((AUITheme *)notify.object).navibarBGColor];
}

- (void)resetHotSearchKeyWord {
    KTCSearchServiceCondition *hotSearchCondition = (KTCSearchServiceCondition *)[[KTCSearchService sharedService] mostHotSearchConditionOfSearchType:KTCSearchTypeService];
    NSString *hotSearchKeyWord = @"";
    if (hotSearchCondition) {
        hotSearchKeyWord = hotSearchCondition.keyWord;
    }
    if ([hotSearchKeyWord length] == 0) {
        hotSearchKeyWord = @"宝爸宝妈都在这里找";
    }
    [self.homeView resetTopViewWithInputContent:hotSearchKeyWord isPlaceHolder:YES];
}

- (void)createActivityViews {
    if (self.activityService.currentActivity) {
        if (![self.activityService.currentActivity hasDisplayedWebPage]) {
            self.activityWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            self.activityWebView.delegate = self;
            [self.activityWebView setScalesPageToFit:YES];
            [self.activityWebView.scrollView setScrollEnabled:NO];
            [self.activityWebView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
            self.activityWebView.opaque = NO;
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [self.activityWebView setFrame:appDelegate.window.frame];
            [self.activityWebView layoutIfNeeded];
            [appDelegate.window addSubview:self.activityWebView];
            [self.activityWebView setHidden:YES];
            //set user agent
            NSString *userAgent = [self.activityWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            NSString *extInfo = [NSString stringWithFormat:@"KidsTC/Iphone/%@", appVersion];
            if ([userAgent rangeOfString:extInfo].location == NSNotFound)
            {
                NSString *newUserAgent = [NSString stringWithFormat:@"%@ %@", userAgent, extInfo];
                // Set user agent (the only problem is that we can't modify the User-Agent later in the program)
                NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
                [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
            }
            //未显示过的活动
            NSURL *url = [NSURL URLWithString:[self.activityService.currentActivity pageUrlString]];
            if (url) {
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [self.activityWebView loadRequest:request];
            }
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedOnActivityThumbView:)];
        [self.activityThumbView addGestureRecognizer:tap];
        
        [self resetRightViews];
    }
}

- (void)didClickedOnActivityThumbView:(id)sender {
    if ([self.activityService.currentActivity.linkUrlString length] > 0) {
        KTCWebViewController *controller = [[KTCWebViewController alloc] init];
        [controller setWebUrlString:self.activityService.currentActivity.linkUrlString];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)resetRightViews {
    if (self.activityService.currentActivity.thumbImage) {
        [self.activityThumbView setImage:self.activityService.currentActivity.thumbImage];
        [self.activityThumbView setHidden:NO];
        
        [self.floorNavigationView setHidden:YES];
        [self.floorNavigationView setEnableCollapse:NO];
    } else if ([self.activityService.currentActivity.thumbImageUrlString length] > 0) {
        [self.activityThumbView setImageWithURL:[NSURL URLWithString:self.activityService.currentActivity.thumbImageUrlString] placeholderImage:nil];
        [self.activityThumbView setHidden:NO];
        
        [self.floorNavigationView setHidden:YES];
        [self.floorNavigationView setEnableCollapse:NO];
    } else {
        [self.activityThumbView setHidden:YES];
        
        [self.floorNavigationView setHidden:NO];
        [self.floorNavigationView setEnableCollapse:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
