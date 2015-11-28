//
//  OrderRefundViewController.m
//  KidsTC
//
//  Created by Altair on 11/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "OrderRefundViewController.h"
#import "OrderRefundViewModel.h"

@interface OrderRefundViewController () <OrderRefundViewDelegate>

@property (weak, nonatomic) IBOutlet OrderRefundView *refundView;

@property (nonatomic, strong) OrderRefundViewModel *viewModel;

@property (nonatomic, copy) NSString *orderId;

@end

@implementation OrderRefundViewController

- (instancetype)initWithOrderId:(NSString *)orderId {
    self = [super initWithNibName:@"OrderRefundViewController" bundle:nil];
    if (self) {
        self.orderId = orderId;
    }
    return self;
}

- (void)viewDidLoad {
    self.bTapToEndEditing = YES;
    [super viewDidLoad];
    _navigationTitle= @"申请退款";
    // Do any additional setup after loading the view from its nib.
    self.refundView.delegate = self;
    self.viewModel = [[OrderRefundViewModel alloc] initWithView:self.refundView];
    [self.viewModel.refundModel setOrderId:self.orderId];
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}

#pragma mark OrderRefundViewDelegate

- (void)didClickedReasonButtonOnOrderRefundView:(OrderRefundView *)view {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请选择退款原因" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak OrderRefundViewController *weakSelf = self;
    for (OrderRefundReasonItem *item in self.viewModel.refundModel.refundReasons) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:item.reasonName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.viewModel.refundModel.selectedReasonItem = item;
        }];
        [controller addAction:action];
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didClickedSubmitButtonOnOrderRefundView:(OrderRefundView *)view {
    [[iToast makeText:@"暂不支持"] show];
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
