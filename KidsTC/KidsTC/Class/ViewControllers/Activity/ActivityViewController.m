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
#import "KTCAreaSelectView.h"

@interface ActivityViewController () <ActivityViewDelegate>

@property (weak, nonatomic) IBOutlet ActivityView *activityView;

@property (nonatomic, strong) ActivityViewModel *viewModel;

@property (nonatomic, strong) KTCAreaSelectView *areaSelectView;

- (void)didClickedFilterButton;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _navigationTitle = @"热门活动";
    // Do any additional setup after loading the view from its nib.
    self.activityView.delegate = self;
    
    self.viewModel = [[ActivityViewModel alloc] initWithView:self.activityView];
    [self.activityView startRefresh];
    
    [self setupRightBarButton:self.viewModel.currentAreaItem.name target:self action:@selector(didClickedFilterButton) frontImage:@"filter" andBackImage:@"filter"];
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

#pragma mark Private methods

- (void)didClickedFilterButton {
    if (!self.areaSelectView) {
        self.areaSelectView = [KTCAreaSelectView areaSelecteView];
    }
    
    __weak ActivityViewController *weakSelf = self;
    [weakSelf.areaSelectView showAddressSelectViewWithCurrent:weakSelf.viewModel.currentAreaItem Selection:^(KTCAreaItem *areaItem) {
        weakSelf.viewModel.currentAreaItem = areaItem;
        [weakSelf setRightBarButtonTitle:areaItem.name frontImage:@"filter" andBackImage:@"filter"];
    }];
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
