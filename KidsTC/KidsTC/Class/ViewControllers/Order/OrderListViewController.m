//
//  OrderListViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderDetailViewController.h"
#import "CommentFoundingViewController.h"
#import "KTCPaymentService.h"
#import "OrderRefundViewController.h"
#import "CashierViewController.h"

@interface OrderListViewController () <OrderListViewDelegate, CommentFoundingViewControllerDelegate, OrderRefundViewControllerDelegate, OrderDetailViewControllerDelegate>

@property (weak, nonatomic) IBOutlet OrderListView *orderListView;

@property (nonatomic, strong) OrderListViewModel *viewModel;

@property (nonatomic, assign) OrderListType listType;

@property (nonatomic, assign) BOOL needRefresh;

@end

@implementation OrderListViewController

- (instancetype)initWithOrderListType:(OrderListType)type {
    self = [super initWithNibName:@"OrderListViewController" bundle:nil];
    if (self) {
        self.listType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationTitle = @"订单列表";
    _pageIdentifier = @"pv_orders";
    // Do any additional setup after loading the view from its nib.
    self.orderListView.delegate = self;
    self.viewModel = [[OrderListViewModel alloc] initWithView:self.orderListView];
    [self.viewModel setOrderListType:self.listType];
//    [[GAlertLoadingView sharedAlertLoadingView] showInView:self.view];
    [self.viewModel startUpdateDataWithSucceed:^(NSDictionary *data) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    } failure:^(NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.needRefresh) {
        [[GAlertLoadingView sharedAlertLoadingView] showInView:self.view];
        [self.viewModel startUpdateDataWithSucceed:^(NSDictionary *data) {
            [[GAlertLoadingView sharedAlertLoadingView] hide];
        } failure:^(NSError *error) {
            [[GAlertLoadingView sharedAlertLoadingView] hide];
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[GAlertLoadingView sharedAlertLoadingView] hide];
}


#pragma mark OrderListViewDelegate

- (void)orderListViewDidPullDownToRefresh:(OrderListView *)listView {
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}

- (void)orderListViewDidPullUpToLoadMore:(OrderListView *)listView {
    [self.viewModel getMoreOrders];
}

- (void)orderListView:(OrderListView *)listView didSelectAtIndex:(NSUInteger)index {
    NSArray *modelArray = [self.viewModel orderModels];
    if ([modelArray count] > index) {
        OrderListModel *model = [modelArray objectAtIndex:index];
        OrderDetailViewController *controller = [[OrderDetailViewController alloc] initWithOrderId:model.orderId pushSource:OrderDetailPushSourceOrderList];
        controller.delegate = self;
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
        //MTA
        [MTA trackCustomKeyValueEvent:@"event_skip_acct_orders" props:nil];
    }
}

- (void)orderListView:(OrderListView *)listView didClickedPayButtonAtIndex:(NSUInteger)index {
    OrderListModel *model = [self.viewModel.orderModels objectAtIndex:index];
    CashierViewController *controller = [[CashierViewController alloc] initWithOrderIdentifier:model.orderId];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)orderListView:(OrderListView *)listView didClickedCommentButtonAtIndex:(NSUInteger)index {
    OrderListModel *model = [self.viewModel.orderModels objectAtIndex:index];
    CommentFoundingViewController *controller = [[CommentFoundingViewController alloc] initWithCommentFoundingModel:[CommentFoundingModel modelFromServiceOrderModel:model]];
    controller.delegate = self;
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
    //MTA
    [MTA trackCustomKeyValueEvent:@"event_skip_orders_evaluate" props:nil];
}

- (void)orderListView:(OrderListView *)listView didClickedReturnButtonAtIndex:(NSUInteger)index {
    OrderListModel *model = [self.viewModel.orderModels objectAtIndex:index];
    OrderRefundViewController *controller = [[OrderRefundViewController alloc] initWithOrderId:model.orderId];
    controller.delegate = self;
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark CommentFoundingViewControllerDelegate

- (void)commentFoundingViewControllerDidFinishSubmitComment:(CommentFoundingViewController *)vc {
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}

#pragma mark OrderRefundViewControllerDelegate

- (void)orderRefundViewController:(OrderRefundViewController *)vc didSucceedWithRefundForOrderId:(NSString *)identifier {
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}

#pragma mark OrderDetailViewControllerDelegate

- (void)orderStatusChanged:(NSString *)orderId needRefresh:(BOOL)need {
    if (need) {
        self.needRefresh = YES;
    }
}

#pragma mark CashierViewControllerDelegate

- (void)needRefreshStatusForOrderWithIdentifier:(NSString *)orderId {
    self.needRefresh = YES;
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
