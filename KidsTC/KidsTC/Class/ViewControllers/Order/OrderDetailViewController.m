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

@interface OrderDetailViewController () <OrderDetailViewDelegate, CommentFoundingViewControllerDelegate, OrderRefundViewControllerDelegate>

@property (weak, nonatomic) IBOutlet OrderDetailView *detailView;

@property (nonatomic, strong) OrderDetailViewModel *viewModel;

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, assign) OrderDetailPushSource pushSource;

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
    // Do any additional setup after loading the view from its nib.
    self.detailView.delegate = self;
    self.viewModel = [[OrderDetailViewModel alloc] initWithView:self.detailView];
    [self.viewModel setOrderId:self.orderId];
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}
#pragma mark & OrderDetailViewDelegate

- (void)orderDetailView:(OrderDetailView *)detailView executeActionWithTag:(OrderDetailActionTag)tag {
    switch (tag) {
        case OrderDetailActionTagPay:
        {
            __weak OrderDetailViewController *weakSelf = self;
            [[KTCPaymentService sharedService] startPaymentWithOrderIdentifier:weakSelf.orderId succeed:^{
                [weakSelf.viewModel startUpdateDataWithSucceed:nil failure:nil];
            } failure:^(NSError *error) {
                NSString *errMsg = @"支付失败";
                NSString *text = [[error userInfo] objectForKey:kErrMsgKey];
                if ([text isKindOfClass:[NSString class]] && [text length] > 0) {
                    errMsg = text;
                }
                [[iToast makeText:errMsg] show];
            }];
        }
            break;
        case OrderDetailActionTagCancel:
        {
            [self.viewModel cancelOrder];
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
        case OrderDetailActionTagReturn:
        {
            OrderRefundViewController *controller = [[OrderRefundViewController alloc] initWithOrderId:self.orderId];
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
}

#pragma mark OrderRefundViewControllerDelegate

- (void)orderRefundViewController:(OrderRefundViewController *)vc didSucceedWithRefundForOrderId:(NSString *)identifier {
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
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
