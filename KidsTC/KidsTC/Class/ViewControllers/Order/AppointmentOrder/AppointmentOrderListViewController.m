//
//  AppointmentOrderListViewController.m
//  KidsTC
//
//  Created by 钱烨 on 8/12/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AppointmentOrderListViewController.h"
#import "AppointmentOrderDetailViewController.h"
#import "AppointmentOrderListViewModel.h"

@interface AppointmentOrderListViewController () <AppointmentOrderListViewDelegate, AppointmentOrderDetailViewControllerDelegate>

@property (weak, nonatomic) IBOutlet AppointmentOrderListView *listView;

@property (nonatomic, strong) AppointmentOrderListViewModel *viewModel;

@end

@implementation AppointmentOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"预约订单";
    _pageIdentifier = @"pv_appoints";
    // Do any additional setup after loading the view from its nib.
    self.listView.delegate = self;
    
    self.viewModel = [[AppointmentOrderListViewModel alloc] initWithView:self.listView];
    [self.viewModel startUpdateDataWithOrderListStatus:AppointmentOrderListStatusAll];
}

#pragma mark AppointmentOrderListViewDelegate

- (void)orderListView:(AppointmentOrderListView *)listView didChangedListStatus:(AppointmentOrderListStatus)status {
    [self.viewModel resetResultWithOrderListStatus:status];
}

- (void)orderListViewDidPullDownToRefresh:(AppointmentOrderListView *)listView forListStatus:(AppointmentOrderListStatus)status {
    [self.viewModel startUpdateDataWithOrderListStatus:status];
}

- (void)orderListViewDidPullUpToLoadMore:(AppointmentOrderListView *)listView forListStatus:(AppointmentOrderListStatus)status {
    [self.viewModel getMoreDataWithOrderListStatus:status];
}

- (void)orderListView:(AppointmentOrderListView *)listView didSelectAtIndex:(NSUInteger)index ofListStatus:(AppointmentOrderListStatus)status {
    NSArray *resultArray = [self.viewModel currentResultArray];
    if ([resultArray count] > index) {
        AppointmentOrderModel *model = [resultArray objectAtIndex:index];
        AppointmentOrderDetailViewController *controller = [[AppointmentOrderDetailViewController alloc] initWithAppointmentOrderModel:model];
        if (controller) {
            [controller setDelegate:self];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark AppointmentOrderDetailViewControllerDelegate

- (void)AppointmentOrderDetailViewController:(AppointmentOrderDetailViewController *)vc didCanceledOrderWithId:(NSString *)orderId {
    [self.viewModel startUpdateDataWithOrderListStatus:self.listView.currentLsitStatus];
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
