//
//  ParentingStrategyViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ParentingStrategyViewController.h"
#import "ParentingStrategyViewModel.h"
#import "ServiceDetailViewController.h"

@interface ParentingStrategyViewController () <ParentingStrategyViewDelegate ,ParentingStrategyFilterViewDelegate>

@property (weak, nonatomic) IBOutlet ParentingStrategyView *strategyView;

@property (nonatomic, strong) ParentingStrategyFilterView *filterView;

@property (nonatomic, strong) ParentingStrategyViewModel *viewModel;

- (void)didClickedFilterButton;

@end

@implementation ParentingStrategyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationTitle = @"亲子攻略";
    // Do any additional setup after loading the view from its nib.
    self.strategyView.delegate = self;
    
    [self setupRightBarButton:nil target:self action:@selector(didClickedFilterButton) frontImage:@"filter" andBackImage:@"filter"];
    
    self.filterView = [[ParentingStrategyFilterView alloc] init];
    self.filterView.delegate = self;
    
    self.viewModel = [[ParentingStrategyViewModel alloc] initWithView:self.strategyView];
    [self.strategyView startRefresh];
}

#pragma mark ParentingStrategyViewDelegate

- (void)didPullDownToRefreshForParentingStrategyView:(ParentingStrategyView *)strategyView {
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}

- (void)didPullUpToLoadMoreForParentingStrategyView:(ParentingStrategyView *)strategyView {
    [self.viewModel getMoreStrategies];
}

- (void)parentingStrategyView:(ParentingStrategyView *)strategyView didSelectedItemAtIndex:(NSUInteger)index {
    ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithNibName:@"ServiceDetailViewController" bundle:nil];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark ParentingStrategyFilterViewDelegate

- (void)didClickedConfirmButtonOnParentingStrategyFilterView:(ParentingStrategyFilterView *)filterView withSelectedSortType:(ParentingStrategySortType)type selectedAreaIndex:(NSUInteger)index {
    if (self.viewModel.currentSortType != type || self.viewModel.currentAreaIndex != index) {
        [self.viewModel setCurrentSortType:type];
        [self.viewModel setCurrentAreaIndex:index];
        [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
    }
}

#pragma mark Private methods

- (void)didClickedFilterButton {
    [self.filterView showWithSelectedSortType:self.viewModel.currentSortType selectedAreaIndex:self.viewModel.currentAreaIndex];
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
