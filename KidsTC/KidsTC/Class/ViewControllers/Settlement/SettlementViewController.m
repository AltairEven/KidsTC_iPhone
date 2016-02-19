//
//  SettlementViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "SettlementViewController.h"
#import "SettlementViewModel.h"
#import "SettlementBottomView.h"
#import "OrderDetailViewController.h"
#import "CouponUsableListViewController.h"
#import "OrderDetailViewController.h"
#import "KTCPaymentService.h"
#import "SettlementScoreEditViewController.h"

@interface SettlementViewController () <SettlementViewDelegate, SettlementBottomViewDelegate>

@property (weak, nonatomic) IBOutlet SettlementView *settlementView;
@property (weak, nonatomic) IBOutlet SettlementBottomView *bottomView;

@property (nonatomic, strong) SettlementViewModel *viewModel;

- (void)submitOrderSucceed;

- (void)goToOrderDetailViewController;

- (void)loadSettlementSucceed:(NSDictionary *)data;

- (void)loadSettlementFailed:(NSError *)error;

@end

@implementation SettlementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"订单确认";
    _pageIdentifier = @"pv_orderpalce";
    // Do any additional setup after loading the view from its nib.
    self.settlementView.delegate = self;
    self.bottomView.delegate = self;
    
    self.viewModel = [[SettlementViewModel alloc] initWithView:self.settlementView];
    __weak SettlementViewController *weakSelf = self;
    [self.viewModel setNetErrorBlock:^(NSError *error) {
        [weakSelf showConnectError:YES];
    }];
    [self reloadNetworkData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[GAlertLoadingView sharedAlertLoadingView] hide];
}

#pragma mark SettlementViewDelegate

- (void)didClickedServiceOnSettlementView:(SettlementView *)settlementView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickedCouponOnSettlementView:(SettlementView *)settlementView {
    NSInteger selectedIndex = -1;
    for (NSUInteger index = 0; index < [self.viewModel.dataModel.usableCoupons count]; index ++) {
        CouponFullCutModel *model = [self.viewModel.dataModel.usableCoupons objectAtIndex:index];
        if ([model.couponId isEqualToString:self.viewModel.dataModel.usedCoupon.couponId]) {
            selectedIndex = index;
            break;
        }
    }
    CouponUsableListViewController *controller = [[CouponUsableListViewController alloc] initWithCouponModels:self.viewModel.dataModel.usableCoupons selectedCoupon:self.viewModel.dataModel.usedCoupon];
    __weak SettlementViewController *weakSelf = self;
    [controller setDismissBlock:^(CouponBaseModel *selectedCoupon) {
        [[GAlertLoadingView sharedAlertLoadingView] show];
        [weakSelf.viewModel resetWithUsedCoupon:selectedCoupon succeed:^(NSDictionary *data) {
            [weakSelf loadSettlementSucceed:data];
            [[GAlertLoadingView sharedAlertLoadingView] hide];
        } failure:^(NSError *error) {
            [[GAlertLoadingView sharedAlertLoadingView] hide];
            [weakSelf loadSettlementFailed:error];
        }];
    }];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickedScoreEditOnSettlementView:(SettlementView *)settlementView {
    if (self.viewModel.dataModel.canUseScore > 0) {
        SettlementScoreEditViewController *controller = [SettlementScoreEditViewController alertInstance];
        controller.totalScore = self.viewModel.dataModel.canUseScore;
        controller.usedScore = self.viewModel.dataModel.usedScore;
        __weak SettlementViewController *weakSelf = self;
        [controller setDismissBlock:^(NSUInteger usedScore) {
            [[GAlertLoadingView sharedAlertLoadingView] show];
            [self.viewModel resetWithUsedScore:usedScore succeed:^(NSDictionary *data) {
                [weakSelf loadSettlementSucceed:data];
                [[GAlertLoadingView sharedAlertLoadingView] hide];
            } failure:^(NSError *error) {
                [[GAlertLoadingView sharedAlertLoadingView] hide];
                [weakSelf loadSettlementFailed:error];
            }];
        }];
        [self presentViewController:controller animated:NO completion:nil];
    }
}

- (void)settlementView:(SettlementView *)settlementView didEndEditWithScore:(NSUInteger)score {
    __weak SettlementViewController *weakSelf = self;
    [[GAlertLoadingView sharedAlertLoadingView] show];
    [self.viewModel resetWithUsedScore:score succeed:^(NSDictionary *data) {
        [weakSelf loadSettlementSucceed:data];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    } failure:^(NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [weakSelf loadSettlementFailed:error];
    }];
}

- (void)settlementView:(SettlementView *)settlementView didSelectedPaymentAtIndex:(NSUInteger)index {
    [self.viewModel resetWithSelectedPaymentIndex:index];
}

#pragma mark SettlementBottomViewDelegate

- (void)didClickedConfirmButtonOnSettlementBottomView:(SettlementBottomView *)bottomView {
    __weak SettlementViewController *weakSelf = self;
    [[GAlertLoadingView sharedAlertLoadingView] show];
    [weakSelf.viewModel submitOrderWithSucceed:^(NSDictionary *data) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [weakSelf submitOrderSucceed];
        NSDictionary *trackParam = [NSDictionary dictionaryWithObjectsAndKeys:self.viewModel.orderId, @"id", [NSNumber numberWithInteger:self.viewModel.paymentInfo.paymentType], @"payType", @"true", @"result", nil];
        [MTA trackCustomKeyValueEvent:@"event_result_orderplace_submit" props:trackParam];
    } failure:^(NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        NSString *errMsg = @"提交订单失败";
        NSString *text = [[error userInfo] objectForKey:@"data"];
        if ([text isKindOfClass:[NSString class]] && [text length] > 0) {
            errMsg = text;
        }
        [[iToast makeText:errMsg] show];
        NSDictionary *trackParam = [NSDictionary dictionaryWithObjectsAndKeys:@"false", @"result", nil];
        [MTA trackCustomKeyValueEvent:@"event_result_orderplace_submit" props:trackParam];
    }];
}

#pragma mark Private methods

- (void)submitOrderSucceed {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"下单成功" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *goToOrderDetailAction = [UIAlertAction actionWithTitle:@"查看订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self goToOrderDetailViewController];
//    }];
//    [alertController addAction:goToOrderDetailAction];
//    if (self.viewModel.paymentInfo.paymentType == KTCPaymentTypeNone) {
//        UIAlertAction *goToPay = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }];
//        [alertController addAction:goToPay];
//    } else {
//        UIAlertAction *goToPay = [UIAlertAction actionWithTitle:@"去支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [KTCPaymentService startPaymentWithInfo:self.viewModel.paymentInfo succeed:^{
//                [self goToOrderDetailViewController];
//            } failure:^(NSError *error) {
//                NSString *errMsg = @"支付失败";
//                NSString *text = [[error userInfo] objectForKey:kErrMsgKey];
//                if ([text isKindOfClass:[NSString class]] && [text length] > 0) {
//                    errMsg = text;
//                }
//                [[iToast makeText:errMsg] show];
//                [self goToOrderDetailViewController];
//            }];
//        }];
//        [alertController addAction:goToPay];
//    }
//    [self presentViewController:alertController animated:YES completion:nil];
    
    [KTCPaymentService startPaymentWithInfo:self.viewModel.paymentInfo succeed:^{
        [self goToOrderDetailViewController];
        NSDictionary *trackParam = [NSDictionary dictionaryWithObjectsAndKeys:self.viewModel.orderId, @"id", @"true", @"result", nil];
        [MTA trackCustomKeyValueEvent:@"event_result_pay_result" props:trackParam];
    } failure:^(NSError *error) {
        NSString *errMsg = @"支付失败";
        NSString *text = [[error userInfo] objectForKey:kErrMsgKey];
        if ([text isKindOfClass:[NSString class]] && [text length] > 0) {
            errMsg = text;
        }
        [[iToast makeText:errMsg] show];
        [self goToOrderDetailViewController];
        NSDictionary *trackParam = [NSDictionary dictionaryWithObjectsAndKeys:self.viewModel.orderId, @"id", @"false", @"result", nil];
        [MTA trackCustomKeyValueEvent:@"event_result_pay_result" props:trackParam];
    }];
}

- (void)goToOrderDetailViewController {
    OrderDetailViewController *controller = [[OrderDetailViewController alloc] initWithOrderId:self.viewModel.orderId pushSource:OrderDetailPushSourceSettlement];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark Super methods

- (void)reloadNetworkData {
    __weak SettlementViewController *weakSelf = self;
    [[GAlertLoadingView sharedAlertLoadingView] show];
    [self.bottomView.confirmButton setEnabled:NO];
    [weakSelf.viewModel startUpdateDataWithSucceed:^(NSDictionary *data) {
        [weakSelf loadSettlementSucceed:data];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    } failure:^(NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [weakSelf loadSettlementFailed:error];
    }];
}

- (void)loadSettlementSucceed:(NSDictionary *)data {
    [self.bottomView setPrice:self.viewModel.dataModel.totalPrice];
    [self.bottomView.confirmButton setEnabled:YES];
    if (self.viewModel.dataModel.needPay) {
        [self.bottomView.confirmButton setTitle:@"确认支付" forState:UIControlStateNormal];
    } else {
        [self.bottomView.confirmButton setTitle:@"确认提交" forState:UIControlStateNormal];
    }
    [self.bottomView setSubmitEnable:YES];
}

- (void)loadSettlementFailed:(NSError *)error {
    if ([[error userInfo] count] > 0) {
        [[iToast makeText:[[error userInfo] objectForKey:@"data"]] show];
    }
    [self.bottomView setSubmitEnable:NO];
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
