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
#import "OrderDetailButtonCell.h"
#import "InsuranceView.h"
#import "OrderDetailConsumptionCodeCell.h"


static NSString *const kCellIdentifier = @"kCellIdentifier";
static NSString *const kConsumptionCodeCellIdentifier = @"kConsumptionCodeCellIdentifier";


@interface OrderDetailView () <UITableViewDataSource, UITableViewDelegate, OrderDetailButtonCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *orderDetailCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *serviceDetailCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *InsuranceCell;
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
@property (weak, nonatomic) IBOutlet InsuranceView *InsuranceView;

@property (nonatomic, strong) UINib *cellNib;
@property (nonatomic, strong) UINib *consumptionCodeCellNib;

@property (nonatomic, strong) UIButton *getCodeButton;

@property (nonatomic, strong) OrderDetailModel *detailModel;


- (void)didClickedGetCodeButton:(id)sender;

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    self.getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.getCodeButton setFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 40)];
    [self.getCodeButton setBackgroundColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.getCodeButton setBackgroundColor:[AUITheme theme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    [self.getCodeButton setTitle:@"获取消费码" forState:UIControlStateNormal];
    [self.getCodeButton addTarget:self action:@selector(didClickedGetCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:self.getCodeButton];
    [self.getCodeButton setHidden:YES];
    
    self.tableView.tableFooterView = footerView;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //price views
    [self.servicePriceView setContentColor:[AUITheme theme].buttonBGColor_Normal];
    [self.servicePriceView setFont:[UIFont systemFontOfSize:15]];
    [self.servicePriceView sizeToFitParameters];
    
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([OrderDetailButtonCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    
    if (!self.consumptionCodeCellNib) {
        self.consumptionCodeCellNib = [UINib nibWithNibName:NSStringFromClass([OrderDetailConsumptionCodeCell class]) bundle:nil];
        [self.tableView registerNib:self.consumptionCodeCellNib forCellReuseIdentifier:kConsumptionCodeCellIdentifier];
    }
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUInteger number = 0;
    if (self.detailModel) {
        number = 3;
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
                if ([OrderDetailButtonCell willShowWithOrderStatus:self.detailModel.status]) {
                    number = 1;
                } else {
                    number = 0;
                }
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
                cell = self.serviceDetailCell;
            } else {
                [self.InsuranceView setSupportedInsurance:self.detailModel.supportedInsurances];
                cell = self.InsuranceCell;
            }
        }
            break;
        case 1:{
            cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailButtonCell" owner:nil options:nil] objectAtIndex:0];
            }
            [(OrderDetailButtonCell *)cell setStatus:self.detailModel.status];
            [(OrderDetailButtonCell *)cell setSupportRefund:[self.detailModel supportRefund]];
            ((OrderDetailButtonCell *)cell).delegate = self;
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                cell = self.orderDetailHeaderCell;
            } else {
                [self.orderIdLabel setText:self.detailModel.orderId];
                [self.orderStatusLabel setText:self.detailModel.statusDescription];
                [self.orderPhoneLabel setText:self.detailModel.phone];
                [self.orderCreateTimeLabel setText:self.detailModel.orderDate];
                [self.orderItemCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.detailModel.serviceCount]];
                [self.orderTotalAmountLabel setText:[NSString stringWithFormat:@"%g", self.detailModel.price]];
                cell = self.orderDetailCell;
            }
        }
        default:
            break;
    }
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
            height = [OrderDetailButtonCell cellHeight];
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
    if (indexPath.row != 1) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderDetailView:executeActionWithTag:)]) {
        [self.delegate orderDetailView:self executeActionWithTag:OrderDetailActionTagGotoService];
    }
}

#pragma mark OrderDetailButtonCellDelegate


- (void)didClickedPayButtonOnOrderDetailButtonCell:(OrderDetailButtonCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderDetailView:executeActionWithTag:)]) {
        [self.delegate orderDetailView:self executeActionWithTag:OrderDetailActionTagPay];
    }
}

- (void)didClickedCommentButtonOnOrderDetailButtonCell:(OrderDetailButtonCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderDetailView:executeActionWithTag:)]) {
        [self.delegate orderDetailView:self executeActionWithTag:OrderDetailActionTagComment];
    }
}

- (void)didClickedCancelButtonOnOrderDetailButtonCell:(OrderDetailButtonCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderDetailView:executeActionWithTag:)]) {
        [self.delegate orderDetailView:self executeActionWithTag:OrderDetailActionTagCancel];
    }}

- (void)didClickedReturnButtonOnOrderDetailButtonCell:(OrderDetailButtonCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderDetailView:executeActionWithTag:)]) {
        [self.delegate orderDetailView:self executeActionWithTag:OrderDetailActionTagReturn];
    }
}

#pragma mark Private methods

- (void)didClickedGetCodeButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderDetailView:executeActionWithTag:)]) {
        [self.delegate orderDetailView:self executeActionWithTag:OrderDetailActionTagGetCode];
    }
}

#pragma mark Public Methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(orderDetailModelForOrderDetailView:)]) {
        self.detailModel = [self.dataSource orderDetailModelForOrderDetailView:self];
        [self.tableView reloadData];
        [self.getCodeButton setHidden:[self.detailModel canGetCode]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
