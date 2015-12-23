//
//  OrderDetailView.m
//  KidsTC
//
//  Created by 钱烨 on 7/9/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "OrderDetailView.h"
#import "FiveStarsView.h"
#import "RichPriceView.h"
#import "InsuranceView.h"
#import "OrderDetailConsumptionCodeCell.h"
#import "OrderDetailModel.h"

#define LeftButtonWith (150)

static NSString *const kCellIdentifier = @"kCellIdentifier";
static NSString *const kConsumptionCodeCellIdentifier = @"kConsumptionCodeCellIdentifier";


@interface OrderDetailView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *orderDetailCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *serviceDetailCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *InsuranceCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *settlementCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *orderDetailHeaderCell;

@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCreateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderItemCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalAmountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *serviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet RichPriceView *servicePriceView;
@property (weak, nonatomic) IBOutlet UILabel *buyCountLabel;
@property (weak, nonatomic) IBOutlet InsuranceView *InsuranceView;

@property (nonatomic, strong) UIView *noticeView;
@property (nonatomic, strong) UILabel *noticeLabel;

@property (nonatomic, strong) UINib *cellNib;
@property (nonatomic, strong) UINib *consumptionCodeCellNib;

@property (nonatomic, strong) OrderDetailModel *detailModel;
//settlement
@property (weak, nonatomic) IBOutlet RichPriceView *productTotalPriceView;
@property (weak, nonatomic) IBOutlet UILabel *promotionDescriptionLabel;
@property (weak, nonatomic) IBOutlet RichPriceView *promotionPriceView;
@property (weak, nonatomic) IBOutlet RichPriceView *scorePriceView;
@property (weak, nonatomic) IBOutlet RichPriceView *totalPriceView;

//button view
@property (weak, nonatomic) IBOutlet UIView *buttonBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBGHeight;
@property (weak, nonatomic) IBOutlet UIView *leftButtonBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftButtonWidth;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIView *rightButtonBGView;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

- (void)resetButtonView;
- (IBAction)didClickedLeftButton:(id)sender;
- (IBAction)didClickedRightButton:(id)sender;

@end

@implementation OrderDetailView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        OrderDetailView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[AUITheme theme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [self.noticeView setBackgroundColor:[UIColor clearColor]];
    self.noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.noticeView.frame.size.width - 20, 20)];
    [self.noticeLabel setBackgroundColor:[UIColor clearColor]];
    [self.noticeLabel setFont:[UIFont systemFontOfSize:11]];
    [self.noticeLabel setTextColor:[UIColor orangeColor]];
    [self.noticeView addSubview:self.noticeLabel];
    
    //price views
    [self.InsuranceView setFontSize:13];
    
    [self.servicePriceView setContentColor:[AUITheme theme].buttonBGColor_Normal];
    [self.servicePriceView setFont:[UIFont systemFontOfSize:15]];
    [self.servicePriceView sizeToFitParameters];
    
    [self.productTotalPriceView setContentColor:[AUITheme theme].globalThemeColor];
    [self.productTotalPriceView setFont:[UIFont systemFontOfSize:13]];
    [self.promotionPriceView setContentColor:[AUITheme theme].globalThemeColor];
    [self.promotionPriceView setFont:[UIFont systemFontOfSize:13]];
    [self.scorePriceView setContentColor:[AUITheme theme].globalThemeColor];
    [self.scorePriceView setFont:[UIFont systemFontOfSize:13]];
    [self.totalPriceView setContentColor:[AUITheme theme].globalThemeColor];
    [self.totalPriceView setFont:[UIFont systemFontOfSize:13]];
    
    if (!self.consumptionCodeCellNib) {
        self.consumptionCodeCellNib = [UINib nibWithNibName:NSStringFromClass([OrderDetailConsumptionCodeCell class]) bundle:nil];
        [self.tableView registerNib:self.consumptionCodeCellNib forCellReuseIdentifier:kConsumptionCodeCellIdentifier];
    }
    
    [self.leftButton setBackgroundColor:RGBA(239, 239, 239, 1) forState:UIControlStateNormal];
    [self.leftButton setBackgroundColor:RGBA(200, 200, 200, 1) forState:UIControlStateHighlighted];
    [self.leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [self.rightButton setBackgroundColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.rightButton setBackgroundColor:[AUITheme theme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    [self.rightButton setBackgroundColor:[AUITheme theme].buttonBGColor_Disable forState:UIControlStateDisabled];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonBGView setHidden:YES];
    self.buttonBGHeight.constant = 0;
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUInteger number = 0;
    if (self.detailModel) {
        number = 4;
    }
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if (self.detailModel) {
        switch (section) {
            case 0:
            {
                number = 2;
            }
                break;
            case 1:
            {
                number = 1;
            }
                break;
            case 2:
            {
                number = 2;
            }
                break;
            default:
                break;
        }
    }
    return number;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                [self.serviceImageView setImageWithURL:self.detailModel.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
                [self.serviceNameLabel setText:self.detailModel.orderName];
                [self.servicePriceView setPrice:self.detailModel.servicePrice];
                NSString *countString = @"";
                if (self.detailModel.serviceCount > 1) {
                    countString = [NSString stringWithFormat:@"x%lu", (unsigned long)self.detailModel.serviceCount];
                }
                [self.buyCountLabel setText:countString];
                cell = self.serviceDetailCell;
            } else {
                [self.InsuranceView setSupportedInsurance:self.detailModel.supportedInsurances];
                cell = self.InsuranceCell;
            }
        }
            break;
        case 1:{
            [self.productTotalPriceView setPrice:self.detailModel.originalAmount];
            
            [self.promotionDescriptionLabel setText:@""];
            [self.promotionPriceView setPrice:self.detailModel.discountAmount];
            
            CGFloat scorePrice = self.detailModel.usedPointNumber * ScoreCoefficient;
            [self.scorePriceView setPrice:scorePrice];
            
            [self.totalPriceView setPrice:self.detailModel.price];
            
            [self.settlementCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
            cell = self.settlementCell;
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                cell = self.orderDetailHeaderCell;
            } else {
                [self.orderIdLabel setText:self.detailModel.orderId];
                [self.orderStatusLabel setText:self.detailModel.orderDetailDescription];
                [self.orderPhoneLabel setText:self.detailModel.phone];
                [self.orderCreateTimeLabel setText:self.detailModel.orderDate];
                [self.orderItemCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.detailModel.serviceCount]];
                [self.orderTotalAmountLabel setText:[NSString stringWithFormat:@"%g", self.detailModel.price]];
                cell = self.orderDetailCell;
            }
        }
            break;
        default:
            break;
    }
    [cell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                height = self.serviceDetailCell.frame.size.height;
            } else {
                height = self.InsuranceCell.frame.size.height;
            }
        }
            break;
        case 1:
        {
            height = self.settlementCell.frame.size.height;
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                height = self.orderDetailHeaderCell.frame.size.height;
            } else {
                height = self.orderDetailCell.frame.size.height;
            }
        }
            break;
        default:
            break;
    }
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    if (section > 0) {
        height = 2.5;
    }
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section != 0) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderDetailView:executeActionWithTag:)]) {
        [self.delegate orderDetailView:self executeActionWithTag:OrderDetailActionTagGotoService];
    }
}

#pragma mark Private methods

- (void)resetButtonView {
    if (self.detailModel) {
        self.buttonBGHeight.constant = 50;
        [self.buttonBGView setHidden:NO];
        switch (self.detailModel.status) {
            case OrderStatusWaitingPayment:
            {
                [self.leftButtonBGView setHidden:NO];
                [self.leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
                self.leftButtonWidth.constant = LeftButtonWith;
                
                [self.rightButtonBGView setHidden:NO];
                [self.rightButton setTitle:@"立即支付" forState:UIControlStateNormal];
            }
                break;
            case OrderStatusHasPayed:
            {
                if ([self.detailModel canRefund]) {
                    [self.leftButtonBGView setHidden:NO];
                    [self.leftButton setTitle:@"申请退款" forState:UIControlStateNormal];
                    self.leftButtonWidth.constant = LeftButtonWith;
                } else {
                    [self.leftButtonBGView setHidden:YES];
                    self.leftButtonWidth.constant = 0;
                }
                
                [self.rightButtonBGView setHidden:NO];
                [self.rightButton setTitle:@"获取消费码" forState:UIControlStateNormal];
            }
                break;
            case OrderStatusPartialUsed:
            {
                if ([self.detailModel canRefund]) {
                    [self.leftButtonBGView setHidden:NO];
                    [self.leftButton setTitle:@"申请退款" forState:UIControlStateNormal];
                    self.leftButtonWidth.constant = LeftButtonWith;
                } else {
                    [self.leftButtonBGView setHidden:YES];
                    self.leftButtonWidth.constant = 0;
                }
                
                [self.rightButtonBGView setHidden:NO];
                [self.rightButton setTitle:@"获取消费码" forState:UIControlStateNormal];
            }
                break;
            case OrderStatusAllUsed:
            {
                [self.leftButtonBGView setHidden:YES];
                self.leftButtonWidth.constant = 0;
                
                [self.rightButtonBGView setHidden:NO];
                [self.rightButton setTitle:@"发表评价" forState:UIControlStateNormal];
            }
                break;
            case OrderStatusHasCanceled:
            {
                [self.buttonBGView setHidden:YES];
                self.buttonBGHeight.constant = 0;
            }
                break;
            case OrderStatusRefunding:
            {
                [self.buttonBGView setHidden:YES];
                self.buttonBGHeight.constant = 0;
            }
                break;
            case OrderStatusRefundSucceed:
            {
                [self.buttonBGView setHidden:YES];
                self.buttonBGHeight.constant = 0;
            }
                break;
            case OrderStatusRefundFailed:
            {
                [self.buttonBGView setHidden:YES];
                self.buttonBGHeight.constant = 0;
            }
                break;
            case OrderStatusHasComment:
            {
                [self.buttonBGView setHidden:YES];
                self.buttonBGHeight.constant = 0;
            }
                break;
            case OrderStatusHasOverTime:
            {
                [self.buttonBGView setHidden:YES];
                self.buttonBGHeight.constant = 0;
            }
            default:
                break;
        }
        if ([self.detailModel canRefund]) {
            [self.leftButtonBGView setHidden:NO];
            [self.leftButton setTitle:@"申请退款" forState:UIControlStateNormal];
            self.leftButtonWidth.constant = LeftButtonWith;
        }
    } else {
        self.buttonBGHeight.constant = 0;
        [self.buttonBGView setHidden:YES];
    }
}

- (IBAction)didClickedLeftButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderDetailView:executeActionWithTag:)]) {
        if (self.detailModel.status == OrderStatusWaitingPayment) {
            [self.delegate orderDetailView:self executeActionWithTag:OrderDetailActionTagCancel];
        } else if ([self.detailModel canRefund]) {
            [self.delegate orderDetailView:self executeActionWithTag:OrderDetailActionTagRefund];
        }
    }
}

- (IBAction)didClickedRightButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderDetailView:executeActionWithTag:)]) {
        switch (self.detailModel.status) {
            case OrderStatusWaitingPayment:
            {
                [self.delegate orderDetailView:self executeActionWithTag:OrderDetailActionTagPay];
            }
                break;
            case OrderStatusHasPayed:
            case OrderStatusPartialUsed:
            {
                [self.delegate orderDetailView:self executeActionWithTag:OrderDetailActionTagGetCode];
            }
                break;
            case OrderStatusAllUsed:
            {
                [self.delegate orderDetailView:self executeActionWithTag:OrderDetailActionTagComment];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark Public Methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(orderDetailModelForOrderDetailView:)]) {
        self.detailModel = [self.dataSource orderDetailModelForOrderDetailView:self];
        if ([self.detailModel canContactCS]) {
            self.tableView.tableFooterView = self.noticeView;
            [self.noticeLabel setText:@"注：如果您对退款有疑问，可以点击右上角联系客服"];
        } else if (self.detailModel.status == OrderStatusWaitingPayment) {
            self.tableView.tableFooterView = self.noticeView;
            [self.noticeLabel setText:self.detailModel.orderPaymentDes];
        } else {
            self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
        }
    }
    [self.tableView reloadData];
    [self resetButtonView];
    if (!self.detailModel) {
        self.tableView.backgroundView = [[KTCEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.frame.size.height) image:[UIImage imageNamed:@""] description:@"啥都木有啊···"];
    } else {
        self.tableView.backgroundView = nil;
    }
}

- (void)setGetCodeButtonEnabled:(BOOL)enabled {
    [self.rightButton setEnabled:enabled];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
