//
//  OrderDetailViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailModel.h"
#import "CommentFoundingViewController.h"
#import "OrderDetailViewModel.h"
#import "ServiceDetailViewController.h"
#import "KTCPaymentService.h"
#import "OrderRefundViewController.h"
#import "OnlineCustomerService.h"
#import "KTCWebViewController.h"

@interface OrderDetailViewController () <OrderDetailViewDelegate, CommentFoundingViewControllerDelegate, OrderRefundViewControllerDelegate>

@property (weak, nonatomic) IBOutlet OrderDetailView *detailView;

@property (nonatomic, strong) OrderDetailViewModel *viewModel;

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, assign) OrderDetailPushSource pushSource;

- (void)didClickedContectCSButton;

- (void)makePhoneCallToCS;

- (void)contectOnlineCustomerService;

@end

@implementation OrderDetailViewController

- (instancetype)initWithOrderId:(NSString *)orderId pushSource:(OrderDetailPushSource)source {
    self = [super initWithNibName:@"OrderDetailViewController" bundle:nil];
    if (self) {
        self.orderId = orderId;
        self.pushSource = source;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationTitle = @"订单详情";
    _pageIdentifier = @"pv_order_dtl";
    // Do any additional setup after loading the view from its nib.
    self.detailView.delegate = self;
    self.viewModel = [[OrderDetailViewModel alloc] initWithView:self.detailView];
    [self.viewModel setOrderId:self.orderId];
    __weak OrderDetailViewController *weakSelf = self;
    [weakSelf.viewModel startUpdateDataWithSucceed:^(NSDictionary *data) {
    } failure:^(NSError *error) {
    }];
    [weakSelf setupRightBarButton:@"" target:self action:@selector(didClickedContectCSButton) frontImage:@"customerService_n" andBackImage:@"customerService_n"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
#pragma mark & OrderDetailViewDelegate

- (void)orderDetailView:(OrderDetailView *)detailView executeActionWithTag:(OrderDetailActionTag)tag {
    switch (tag) {
        case OrderDetailActionTagPay:
        {
            __weak OrderDetailViewController *weakSelf = self;
            [[KTCPaymentService sharedService] startPaymentWithOrderIdentifier:weakSelf.orderId succeed:^{
                [weakSelf.viewModel startUpdateDataWithSucceed:nil failure:nil];
                if (self.delegate && [self.delegate respondsToSelector:@selector(orderStatusChanged:needRefresh:)]) {
                    [self.delegate orderStatusChanged:self.orderId needRefresh:YES];
                }
                NSDictionary *trackParam = [NSDictionary dictionaryWithObjectsAndKeys:self.orderId, @"id", @"true", @"result", nil];
                [MTA trackCustomKeyValueEvent:@"event_result_order_dtl_pay" props:trackParam];
            } failure:^(NSError *error) {
                NSString *errMsg = @"支付失败";
                NSString *text = [[error userInfo] objectForKey:kErrMsgKey];
                if ([text isKindOfClass:[NSString class]] && [text length] > 0) {
                    errMsg = text;
                }
                [[iToast makeText:errMsg] show];
                NSDictionary *trackParam = [NSDictionary dictionaryWithObjectsAndKeys:self.orderId, @"id", @"false", @"result", nil];
                [MTA trackCustomKeyValueEvent:@"event_result_order_dtl_pay" props:trackParam];
            }];
        }
            break;
        case OrderDetailActionTagCancel:
        {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"您真的要取消订单么？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不取消了" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"忍痛取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.viewModel cancelOrder];
                if (self.delegate && [self.delegate respondsToSelector:@selector(orderStatusChanged:needRefresh:)]) {
                    [self.delegate orderStatusChanged:self.orderId needRefresh:YES];
                }
            }];
            [controller addAction:cancelAction];
            [controller addAction:confirmAction];
            [self presentViewController:controller animated:YES completion:nil];
        }
            break;
        case OrderDetailActionTagComment:
        {
            CommentFoundingViewController *controller = [[CommentFoundingViewController alloc] initWithCommentFoundingModel:[CommentFoundingModel modelFromServiceOrderModel:self.viewModel.detailModel]];
            controller.delegate = self;
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case OrderDetailActionTagRefund:
        {
            OrderRefundViewController *controller = [[OrderRefundViewController alloc] initWithOrderId:self.orderId];
            controller.delegate = self;
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case OrderDetailActionTagGotoService:
        {
            ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithServiceId:self.viewModel.detailModel.serviceId channelId:@""];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case OrderDetailActionTagGetCode:
        {
            [self.detailView setGetCodeButtonEnabled:NO];
            __weak OrderDetailViewController *weakSelf = self;
            [weakSelf.viewModel getConsumeCodeWithSucceed:^{
                [[iToast makeText:@"消费码已发到您的手机，请注意查收"] show];
                [self.detailView setGetCodeButtonEnabled:YES];
                NSDictionary *trackParam = [NSDictionary dictionaryWithObjectsAndKeys:self.orderId, @"id", @"true", @"result", nil];
                [MTA trackCustomKeyValueEvent:@"event_result_order_dtl_consume" props:trackParam];
            } failure:^(NSError *error) {
                if (error.userInfo) {
                    NSString *msg = [error.userInfo objectForKey:@"data"];
                    if ([msg isKindOfClass:[NSString class]] && [msg length] > 0) {
                        [[iToast makeText:msg] show];
                    } else {
                        [[iToast makeText:@"获取消费码失败"] show];
                    }
                } else {
                    [[iToast makeText:@"获取消费码失败"] show];
                }
                [self.detailView setGetCodeButtonEnabled:YES];
                NSDictionary *trackParam = [NSDictionary dictionaryWithObjectsAndKeys:self.orderId, @"id", @"false", @"result", nil];
                [MTA trackCustomKeyValueEvent:@"event_result_order_dtl_consume" props:trackParam];
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark CommentFoundingViewControllerDelegate

- (void)commentFoundingViewControllerDidFinishSubmitComment:(CommentFoundingViewController *)vc {
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderStatusChanged:needRefresh:)]) {
        [self.delegate orderStatusChanged:self.orderId needRefresh:YES];
    }
}

#pragma mark OrderRefundViewControllerDelegate

- (void)orderRefundViewController:(OrderRefundViewController *)vc didSucceedWithRefundForOrderId:(NSString *)identifier {
    [[GAlertLoadingView sharedAlertLoadingView] showInView:self.view];
    [self.viewModel startUpdateDataWithSucceed:^(NSDictionary *data) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        if (self.delegate && [self.delegate respondsToSelector:@selector(orderStatusChanged:needRefresh:)]) {
            [self.delegate orderStatusChanged:self.orderId needRefresh:YES];
        }
    } failure:^(NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    }];
}

#pragma mark Private methods

- (void)didClickedContectCSButton {
    BOOL hasOnlineService = [OnlineCustomerService serviceIsOnline];
    if (hasOnlineService) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请选择客服类型" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *onlineAction = [UIAlertAction actionWithTitle:@"在线客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self contectOnlineCustomerService];
        }];
        UIAlertAction *phoneAction = [UIAlertAction actionWithTitle:@"电话热线" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self makePhoneCallToCS];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:onlineAction];
        [controller addAction:phoneAction];
        [controller addAction:cancelAction];
        
        [self presentViewController:controller animated:YES completion:nil];
        
    } else {
        [self makePhoneCallToCS];
    }
}

- (void)makePhoneCallToCS {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", kCustomerServicePhoneNumber]]];
}

- (void)contectOnlineCustomerService {
    KTCWebViewController *controller = [[KTCWebViewController alloc] init];
    [controller setWebUrlString:[OnlineCustomerService onlineCustomerServiceLinkUrlString]];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark Super methods

- (void)goBackController:(id)sender {
    switch (self.pushSource) {
        case OrderDetailPushSourceOrderList:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case OrderDetailPushSourceSettlement:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        default:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
