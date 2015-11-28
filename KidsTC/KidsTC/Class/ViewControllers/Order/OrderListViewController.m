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

@interface OrderListViewController () <OrderListViewDelegate, CommentFoundingViewControllerDelegate>

@property (weak, nonatomic) IBOutlet OrderListView *orderListView;

@property (nonatomic, strong) OrderListViewModel *viewModel;

@property (nonatomic, assign) OrderListType listType;

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
    // Do any additional setup after loading the view from its nib.
    self.orderListView.delegate = self;
    self.viewModel = [[OrderListViewModel alloc] initWithView:self.orderListView];
    [self.viewModel setOrderListType:self.listType];
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
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
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)orderListView:(OrderListView *)listView didClickedPayButtonAtIndex:(NSUInteger)index {
    
}

- (void)orderListView:(OrderListView *)listView didClickedCommentButtonAtIndex:(NSUInteger)index {
    OrderListModel *model = [self.viewModel.orderModels objectAtIndex:index];
    CommentFoundingViewController *controller = [[CommentFoundingViewController alloc] initWithCommentFoundingModel:[CommentFoundingModel modelFromServiceOrderModel:model]];
    controller.delegate = self;
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)orderListView:(OrderListView *)listView didClickedReturnButtonAtIndex:(NSUInteger)index {
    
}

#pragma mark OrderCommentViewControllerDelegate

- (void)commentFoundingViewControllerDidFinishSubmitComment:(CommentFoundingViewController *)vc {
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
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
