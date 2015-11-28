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

@interface OrderDetailViewController () <OrderDetailViewDelegate, CommentFoundingViewControllerDelegate>

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
            [self.viewModel refund];
        }
            break;
        case OrderDetailActionTagGotoService:
        {
            ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithNibName:@"ServiceDetailViewController" bundle:nil];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case OrderDetailActionTagGetCode:
        {
            [self.viewModel getConsumptionCode];
        }
            break;
        default:
            break;
    }
}

#pragma mark OrderCommentViewControllerDelegate

- (void)commentFoundingViewControllerDidFinishSubmitComment:(CommentFoundingViewController *)vc {
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
