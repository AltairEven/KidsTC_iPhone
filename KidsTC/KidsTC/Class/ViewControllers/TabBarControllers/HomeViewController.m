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


@interface HomeViewController () <HomeViewDelegate, AUIFloorNavigationViewDataSource, AUIFloorNavigationViewDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet HomeView *homeView;
@property (weak, nonatomic) IBOutlet AUIFloorNavigationView *floorNavigationView;

@property (nonatomic, strong) HomeViewModel *viewModel;

@property (nonatomic, copy) NSString *sysNo;

@property (nonatomic, strong) UIWebView *testWebView;

- (void)userRoleHasChanged:(id)info;

- (void)themeDidChanged:(NSNotification *)notify;

- (void)resetHotSearchKeyWord;

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
    
//    self.testWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    self.testWebView.delegate = self;
//    [self.testWebView setScalesPageToFit:YES];
//    [self.testWebView.scrollView setScrollEnabled:NO];
//    [self.testWebView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
//    self.testWebView.opaque = NO;
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [self.testWebView setFrame:appDelegate.window.frame];
//    [self.testWebView layoutIfNeeded];
//    [appDelegate.window addSubview:self.testWebView];
//    [self.testWebView setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *url = @"http://demo.sc.chinaz.com//Files/DownLoad/webjs1/201410/jiaoben2890/#";
//    NSString *url = @"http://m.kidstc.com/event/detail/7C-B4-EA-88-F0-DE-9E-9F%7C100.html";
    [self.testWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
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
    HomeSegueModel *segueModel = [self.viewModel.homeModel segueModelAtHomeClickCoordinate:coordinate];
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

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.testWebView setHidden:NO];
    [self.testWebView.superview bringSubviewToFront:self.testWebView];
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
