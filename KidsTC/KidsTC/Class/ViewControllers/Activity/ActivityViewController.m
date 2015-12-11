//
//  ActivityViewController.m
//  KidsTC
//
//  Created by 钱烨 on 10/12/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityViewModel.h"
#import "ServiceDetailViewController.h"
#import "ActivityFilterView.h"

@interface ActivityViewController () <ActivityViewDelegate, ActivityFilterViewDelegate>

@property (weak, nonatomic) IBOutlet ActivityView *activityView;

@property (nonatomic, strong) ActivityViewModel *viewModel;

@property (nonatomic, strong) ActivityFilterView *filterView;

@property (nonatomic, assign) NSInteger currentCategoryIndex;

@property (nonatomic, strong) ActivityFilterModel *filterModel;

@property (nonatomic, assign) NSInteger currentAreaIndex;

- (void)didClickedFilterButton;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _navigationTitle = @"热门活动";
    // Do any additional setup after loading the view from its nib.
    self.currentCategoryIndex = INVALID_INDEX;
    self.currentAreaIndex = INVALID_INDEX;
    
    self.activityView.delegate = self;
    
    self.viewModel = [[ActivityViewModel alloc] initWithView:self.activityView];
    [self.activityView startRefresh];
    
    [self setupRightBarButton:nil target:self action:@selector(didClickedFilterButton) frontImage:@"navigation_filter" andBackImage:@"navigation_filter"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[GAlertLoadingView sharedAlertLoadingView] hide];
}

#pragma mark ActivityViewDelegate

- (void)didPullDownToRefreshForActivityView:(ActivityView *)view {
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}

- (void)didPullUpToLoadMoreForactivityView:(ActivityView *)view {
    [self.viewModel getMoreDataWithSucceed:nil failure:nil];
}

- (void)activityView:(ActivityView *)view didSelectedItemAtIndex:(NSUInteger)index {
    ActivityListItemModel *itemModel = [[self.viewModel resultArray] objectAtIndex:index];
    
    ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithServiceId:itemModel.activityId channelId:itemModel.channelId];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark ActivityFilterViewDelegate

- (void)didClickedConfirmButtonOnActivityFilterView:(ActivityFilterView *)filterView withSelectedCategoryIndex:(NSUInteger)categoryIndex selectedAreaIndex:(NSUInteger)areaIndex {
    if (categoryIndex == self.currentCategoryIndex && areaIndex == self.currentAreaIndex) {
        return;
    }
    if ([self.filterModel.categoryFiltItems count] > categoryIndex) {
        self.viewModel.currentCategoryItem = [self.filterModel.categoryFiltItems objectAtIndex:categoryIndex];
    }
    if ([self.filterModel.areaFiltItems count] > areaIndex) {
        self.viewModel.currentAreaItem = [self.filterModel.areaFiltItems objectAtIndex:areaIndex];
    }
    
    [[GAlertLoadingView sharedAlertLoadingView] showInView:self.view];
    [self.viewModel startUpdateDataWithSucceed:^(NSDictionary *data) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    } failure:^(NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    }];
}

#pragma mark Private methods

- (void)didClickedFilterButton {
    [[GAlertLoadingView sharedAlertLoadingView] hide];
    if (!self.filterView) {
        self.filterView = [[ActivityFilterView alloc] init];
        self.filterView.delegate = self;
    }
    if (!self.filterModel || [self.filterModel needRefresh]) {
        __weak ActivityViewController *weakSelf = self;
        [self.filterView showLoading:YES];
        [weakSelf.viewModel getCategoryDataWithSucceed:^(NSDictionary *data) {
            weakSelf.filterModel = [[ActivityFilterModel alloc] initWithRawData:[data objectForKey:@"data"]];
            if (weakSelf.filterModel) {
                [weakSelf.filterView setCategoryNameArray:[weakSelf.filterModel categotyNames]];
                [weakSelf.filterView setAreaNameArray:[weakSelf.filterModel areaNames]];
            }
            [weakSelf.filterView showLoading:NO];
        } failure:^(NSError *error) {
            [weakSelf.filterView showLoading:NO];
        }];
    }
    [self.filterView showWithSelectedCategoryIndex:self.currentAreaIndex selectedAreaIndex:self.currentAreaIndex];
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
