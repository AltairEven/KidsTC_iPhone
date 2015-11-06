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
    self.filterView.delegate = self;
    
    self.viewModel = [[ActivityViewModel alloc] initWithView:self.activityView];
    [self.activityView startRefresh];
    
    [self setupRightBarButton:nil target:self action:@selector(didClickedFilterButton) frontImage:@"filter" andBackImage:@"filter"];
}

#pragma mark ActivityViewDelegate

- (void)activityView:(ActivityView *)view didClickedCalendarButtonAtIndex:(NSUInteger)index {
    [self.viewModel resetResultWithCalendarIndex:index];
}

- (void)activityView:(ActivityView *)view DidPullDownToRefreshForCalendarIndex:(NSUInteger)index {
    [self.viewModel startUpdateDataWithCalendarIndex:index];
}

- (void)activityView:(ActivityView *)view DidPullUpToLoadMoreForCalendarIndex:(NSUInteger)index {
    [self.viewModel getMoreDataWithCalendarIndex:index];
}

- (void)activityView:(ActivityView *)view didSelectedItemAtIndex:(NSUInteger)index {
    ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithNibName:@"ServiceDetailViewController" bundle:nil];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark

- (void)didClickedConfirmButtonOnActivityFilterView:(ActivityFilterView *)filterView withSelectedCategoryIndex:(NSUInteger)categoryIndex selectedAreaIndex:(NSUInteger)areaIndex {
    NSArray *areaArray = [[KTCArea area] areaItems];
    if ([areaArray count] > areaIndex) {
        self.viewModel.currentAreaItem = [areaArray objectAtIndex:areaIndex];
    }
}

#pragma mark Private methods

- (void)didClickedFilterButton {
    if (!self.filterView) {
        self.filterView = [[ActivityFilterView alloc] init];
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
