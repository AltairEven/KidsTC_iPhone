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

@property (weak, nonatomic) IBOutlet UIScrollView *scrollBGView;
@property (strong, nonatomic) IBOutlet OrderRefundView *refundView;

@property (nonatomic, strong) OrderRefundViewModel *viewModel;

@property (nonatomic, copy) NSString *orderId;

- (BOOL)isValidParams;

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
    _pageIdentifier = @"pv_refund";
    // Do any additional setup after loading the view from its nib.
    self.refundView.delegate = self;
    [self.refundView setMinCount:1 andMaxCount:1];
    
    self.viewModel = [[OrderRefundViewModel alloc] initWithView:self.refundView];
    [self.viewModel.refundModel setOrderId:self.orderId];
    [self.viewModel startUpdateDataWithSucceed:^(NSDictionary *data) {
        [self.refundView setMinCount:1 andMaxCount:self.viewModel.refundModel.maxRefundCount];
    } failure:^(NSError *error) {
        NSString *msg = nil;
        if (error.userInfo) {
            msg = [error.userInfo objectForKey:@"data"];
        }
        if ([msg length] == 0) {
            msg = @"获取退款信息失败";
        }
        [[iToast makeText:msg] show];
    }];
}

#pragma mark OrderRefundViewDelegate

- (void)orderRefundView:(OrderRefundView *)view didChangedRefundCountToValue:(NSUInteger)count {
    [self.viewModel.refundModel setRefundCount:count];
    [self.refundView reloadData];
}

- (void)didClickedReasonButtonOnOrderRefundView:(OrderRefundView *)view {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请选择退款原因" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak OrderRefundViewController *weakSelf = self;
    for (OrderRefundReasonItem *item in self.viewModel.refundModel.refundReasons) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:item.reasonName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.viewModel.refundModel.selectedReasonItem = item;
            [weakSelf.refundView reloadData];
        }];
        [controller addAction:action];
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didClickedSubmitButtonOnOrderRefundView:(OrderRefundView *)view {
    if (![self isValidParams]) {
        return;
    }
    __weak OrderRefundViewController *weakSelf = self;
    [weakSelf.viewModel createOrderRefundWithSucceed:^(NSDictionary *data) {
        [[iToast makeText:@"退款申请提交成功"] show];
        if (self.delegate && [self.delegate respondsToSelector:@selector(orderRefundViewController:didSucceedWithRefundForOrderId:)]) {
            [self.delegate orderRefundViewController:self didSucceedWithRefundForOrderId:self.orderId];
        }
        [weakSelf goBackController:nil];
        NSDictionary *trackParam = [NSDictionary dictionaryWithObjectsAndKeys:self.orderId, @"id", @"true", @"result", nil];
        [MTA trackCustomKeyValueEvent:@"event_result_refund_apply" props:trackParam];
    } failure:^(NSError *error) {
        NSString *msg = nil;
        if (error.userInfo) {
            msg = [error.userInfo objectForKey:@"data"];
        }
        if ([msg length] == 0) {
            msg = @"退款申请提交失败";
        }
        [[iToast makeText:msg] show];
        NSDictionary *trackParam = [NSDictionary dictionaryWithObjectsAndKeys:self.orderId, @"id", @"false", @"result", nil];
        [MTA trackCustomKeyValueEvent:@"event_result_refund_apply" props:trackParam];
    }];
}

#pragma mark Private methods

- (BOOL)isValidParams {
    if (!self.viewModel.refundModel.selectedReasonItem) {
        [[iToast makeText:@"请选择退款原因"] show];
        return NO;
    }
    if ([self.viewModel.refundModel.refundDescription length] < 10) {
        [[iToast makeText:@"请输入最少10个字的原因描述"] show];
        return NO;
    }
    return YES;
}

#pragma mark Super methods

- (void)keyboardWillShow:(NSNotification *)notification {
    [super keyboardWillShow:notification];
    [self.scrollBGView setContentSize:CGSizeMake(0, self.view.frame.size.height + self.keyboardHeight)];
}

- (void)keyboardWillDisappear:(NSNotification *)notification {
    [super keyboardWillDisappear:notification];
    [self.scrollBGView setContentSize:CGSizeMake(0, self.view.frame.size.height - self.keyboardHeight)];
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
