//
//  CashierViewController.m
//  KidsTC
//
//  Created by Altair on 1/19/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "CashierViewController.h"
#import "RichPriceView.h"
#import "PaymentTypeModel.h"
#import "KTCPaymentService.h"

@interface CashierViewController ()

@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet RichPriceView *priceView;
@property (weak, nonatomic) IBOutlet UIView *gapView;
@property (weak, nonatomic) IBOutlet UIButton *alipayButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;

@property (nonatomic, strong) HttpRequestClient *loadCashierRequest;

@property (nonatomic, strong) HttpRequestClient *changePayTypeRequest;

@property (nonatomic, copy) NSString *orderIdentifier;

@property (nonatomic, assign) CGFloat amount;

@property (nonatomic, strong) NSArray<PaymentTypeModel *> *supportedPaymentTypeModel;

@property (nonatomic, strong) KTCPaymentInfo *currentPaymentInfo;

- (void)buildSubviews;

- (void)loadCashierInfo;

- (void)loadCashierInfoSucceed:(NSDictionary *)data;

- (void)changePaymentTypeSucceed:(NSDictionary *)data;

- (IBAction)didClickedAlipayButton:(id)sender;
- (IBAction)didClickedWechatButton:(id)sender;

- (void)changePaymentChannelWithType:(KTCPaymentType)type;

- (void)startPayment;

@end

@implementation CashierViewController

- (instancetype)initWithOrderIdentifier:(NSString *)orderId {
    self = [super initWithNibName:@"CashierViewController" bundle:nil];
    if (self) {
        self.orderIdentifier = orderId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"选择支付";
    _pageIdentifier = @"pv_order_pay";
    // Do any additional setup after loading the view from its nib.
    [self buildSubviews];
    [self loadCashierInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[GAlertLoadingView sharedAlertLoadingView] hide];
}

- (void)buildSubviews {
    [self.orderIdLabel setText:self.orderIdentifier];
    
    [self.priceView setContentColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    [self.priceView setUnitFont:[UIFont systemFontOfSize:15]];
    [self.priceView setPriceFont:[UIFont systemFontOfSize:15]];
    
    [GConfig resetLineView:self.gapView withLayoutAttribute:NSLayoutAttributeHeight];
    
    self.alipayButton.layer.borderColor = RGBA(240, 240, 240, 1).CGColor;
    self.alipayButton.layer.borderWidth = BORDER_WIDTH;
    self.alipayButton.layer.cornerRadius = 20;
    self.alipayButton.layer.masksToBounds = YES;
    
    self.wechatButton.layer.borderColor = RGBA(240, 240, 240, 1).CGColor;
    self.wechatButton.layer.borderWidth = BORDER_WIDTH;
    self.wechatButton.layer.cornerRadius = 20;
    self.wechatButton.layer.masksToBounds = YES;
}

- (void)loadCashierInfo {
    [self.alipayButton setEnabled:NO];
    [self.alipayButton setAlpha:0.3];
    [self.wechatButton setEnabled:NO];
    [self.wechatButton setAlpha:0.3];
    
    if (!self.loadCashierRequest) {
        self.loadCashierRequest = [HttpRequestClient clientWithUrlAliasName:@"ORDER_GET_PAY_CHANNEL"];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObject:self.orderIdentifier forKey:@"orderId"];
    __weak CashierViewController *weakSelf = self;
    [[GAlertLoadingView sharedAlertLoadingView] show];
    [weakSelf.loadCashierRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadCashierInfoSucceed:responseData];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    } failure:^(HttpRequestClient *client, NSError *error) {
        NSString *errMsg = @"";
        if (error.userInfo) {
            errMsg = [error.userInfo objectForKey:@"data"];
        }
        if ([errMsg length] == 0) {
            errMsg = @"获取支付方式失败，请稍后再试";
        }
        [[iToast makeText:errMsg] show];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    }];
}

- (void)loadCashierInfoSucceed:(NSDictionary *)data {
    NSDictionary *cashierInfo = [data objectForKey:@"data"];
    if ([cashierInfo isKindOfClass:[NSDictionary class]]) {
        //支持的支付方式
        NSDictionary *payChannel = [cashierInfo objectForKey:@"payChannel"];
        if ([payChannel isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSString *name in [payChannel allKeys]) {
                if ([name isEqualToString:@"ali"]) {
                    PaymentTypeModel *model = [[PaymentTypeModel alloc] initWithPaymentName:@"支付宝" paymenttype:PaymentTypeAlipay logoImage:[UIImage imageNamed:@"logo_ali"]];
                    [tempArray addObject:model];
                    continue;
                }
                if ([name isEqualToString:@"WeChat"]) {
                    PaymentTypeModel *model = [[PaymentTypeModel alloc] initWithPaymentName:@"微信" paymenttype:PaymentTypeWechat logoImage:[UIImage imageNamed:@"logo_wechat"]];
                    [tempArray addObject:model];
                    continue;
                }
                if ([name isEqualToString:@"99bill"]) {
                    PaymentTypeModel *model = [[PaymentTypeModel alloc] initWithPaymentName:@"快钱" paymenttype:PaymentType99Bill logoImage:[UIImage imageNamed:@"logo_99bill"]];
                    [tempArray addObject:model];
                    continue;
                }
            }
            self.supportedPaymentTypeModel = [NSArray arrayWithArray:tempArray];
        }
        //订单信息
        NSDictionary *orderInfo = [cashierInfo objectForKey:@"order"];
        if ([orderInfo isKindOfClass:[NSDictionary class]]) {
            self.amount = [[orderInfo objectForKey:@"payMoney"] floatValue];
            NSDictionary *payInfo = [orderInfo objectForKey:@"payInfo"];
            self.currentPaymentInfo = [KTCPaymentInfo instanceWithRawData:payInfo];
        }
    }

    [self.priceView setPrice:self.amount];
    for (PaymentTypeModel *typeModel in self.supportedPaymentTypeModel) {
        if (typeModel.type == PaymentTypeAlipay) {
            [self.alipayButton setEnabled:YES];
            [self.alipayButton setAlpha:1];
            continue;
        }
        if (typeModel.type == PaymentTypeWechat) {
            [self.wechatButton setEnabled:YES];
            [self.wechatButton setAlpha:1];
            continue;
        }
    }
}

- (IBAction)didClickedAlipayButton:(id)sender {
    if (self.currentPaymentInfo.paymentType == KTCPaymentTypeAlipay) {
        [self startPayment];
    } else {
        [self changePaymentChannelWithType:KTCPaymentTypeAlipay];
    }
}

- (IBAction)didClickedWechatButton:(id)sender {
    if (self.currentPaymentInfo.paymentType == KTCPaymentTypeWechat) {
        [self startPayment];
    } else {
        [self changePaymentChannelWithType:KTCPaymentTypeWechat];
    }
}

- (void)changePaymentChannelWithType:(KTCPaymentType)type {
    if (!self.changePayTypeRequest) {
        self.changePayTypeRequest = [HttpRequestClient clientWithUrlAliasName:@"ORDER_CHANGE_PAY_CHANNEL"];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.orderIdentifier, @"orderId", [NSNumber numberWithInteger:type], @"payType", nil];
    
    __weak CashierViewController *weakSelf = self;
    [[GAlertLoadingView sharedAlertLoadingView] show];
    [weakSelf.changePayTypeRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf changePaymentTypeSucceed:responseData];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    } failure:^(HttpRequestClient *client, NSError *error) {
        NSString *errMsg = @"";
        if (error.userInfo) {
            errMsg = [error.userInfo objectForKey:@"data"];
        }
        if ([errMsg length] == 0) {
            errMsg = @"获取支付信息失败，请重新尝试";
        }
        [[iToast makeText:errMsg] show];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    }];
}

- (void)changePaymentTypeSucceed:(NSDictionary *)data {
    KTCPaymentInfo *info = [KTCPaymentInfo instanceWithRawData:[data objectForKey:@"data"]];
    if (info && info.paymentType != KTCPaymentTypeNone) {
        self.currentPaymentInfo = info;
        [self startPayment];
    }
}

- (void)startPayment {
    [KTCPaymentService startPaymentWithInfo:self.currentPaymentInfo succeed:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(needRefreshStatusForOrderWithIdentifier:)]) {
            [self.delegate needRefreshStatusForOrderWithIdentifier:self.orderIdentifier];
        }
        NSDictionary *trackParam = [NSDictionary dictionaryWithObjectsAndKeys:self.orderIdentifier, @"id", @"true", @"result", nil];
        [MTA trackCustomKeyValueEvent:@"event_result_pay_result" props:trackParam];
        [self goBackController:nil];
    } failure:^(NSError *error) {
        NSString *errMsg = @"支付失败";
        NSString *text = [[error userInfo] objectForKey:kErrMsgKey];
        if ([text isKindOfClass:[NSString class]] && [text length] > 0) {
            errMsg = text;
        }
        [[iToast makeText:errMsg] show];
        NSDictionary *trackParam = [NSDictionary dictionaryWithObjectsAndKeys:self.orderIdentifier, @"id", @"false", @"result", nil];
        [MTA trackCustomKeyValueEvent:@"event_result_pay_result" props:trackParam];
        [self goBackController:nil];
    }];
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
