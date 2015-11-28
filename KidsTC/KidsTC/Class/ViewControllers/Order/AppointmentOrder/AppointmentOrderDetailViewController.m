//
//  AppointmentOrderDetailViewController.m
//  KidsTC
//
//  Created by 钱烨 on 8/12/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AppointmentOrderDetailViewController.h"
#import "AppointmentOrderDetailViewModel.h"
#import "StoreDetailViewController.h"
#import "CommentFoundingViewController.h"

@interface AppointmentOrderDetailViewController () <AppointmentOrderDetailViewDelegate, CommentFoundingViewControllerDelegate>

@property (weak, nonatomic) IBOutlet AppointmentOrderDetailView *detailView;

@property (nonatomic, strong) AppointmentOrderDetailViewModel *viewModel;

@property (nonatomic, strong) AppointmentOrderModel *orderModel;

@end

@implementation AppointmentOrderDetailViewController

- (instancetype)initWithAppointmentOrderModel:(AppointmentOrderModel *)model {
    if (!model) {
        return nil;
    }
    self = [super initWithNibName:@"AppointmentOrderDetailViewController" bundle:nil];
    if (self) {
        self.orderModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"预约订单";
    // Do any additional setup after loading the view from its nib.
    self.detailView.delegate = self;
    self.viewModel = [[AppointmentOrderDetailViewModel alloc] initWithView:self.detailView];
    [self.viewModel setOrderModel:self.orderModel];
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}

#pragma mark AppointmentOrderDetailViewDelegate

- (void)didClickedStoreOnAppointmentOrderDetailView:(AppointmentOrderDetailView *)detailView {
    StoreDetailViewController *controller = [[StoreDetailViewController alloc] initWithStoreId:self.viewModel.orderModel.storeId];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickedCommentButtonOnAppointmentOrderDetailView:(AppointmentOrderDetailView *)detailView {
    CommentFoundingViewController *controller = [[CommentFoundingViewController alloc] initWithCommentFoundingModel:[CommentFoundingModel modelFromStoreAppointmentModel:self.viewModel.orderModel]];
    controller.delegate = self;
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickedCancelButtonOnAppointmentOrderDetailView:(AppointmentOrderDetailView *)detailView {
    __weak AppointmentOrderDetailViewController *weakSelf = self;
    [weakSelf.viewModel cancelOrderWithSucceed:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(AppointmentOrderDetailViewController:didCanceledOrderWithId:)]) {
            [weakSelf.delegate AppointmentOrderDetailViewController:weakSelf didCanceledOrderWithId:weakSelf.orderModel.orderId];
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        if (error.userInfo) {
            NSString *msg = [error.userInfo objectForKey:@"data"];
            if ([msg isKindOfClass:[NSString class]] && [msg length] > 0) {
                [[iToast makeText:msg] show];
            } else {
                [[iToast makeText:@"取消订单失败"] show];
            }
        } else {
            [[iToast makeText:@"取消订单失败"] show];
        }
    }];
}

- (void)didClickedGetCodeButtonOnAppointmentOrderDetailView:(AppointmentOrderDetailView *)detailView {
}

#pragma mark CommentFoundingViewControllerDelegate

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
