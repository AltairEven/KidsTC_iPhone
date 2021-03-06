//
//  SettlementView.m
//  KidsTC
//
//  Created by 钱烨 on 7/23/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "SettlementView.h"
#import "RichPriceView.h"
#import "SettlementPayTypeCell.h"
#import "NSAttributedString+Attributes.h"

typedef enum {
    SettlementViewSectionProduct,
    SettlementViewSectionUserPromotion,
    SettlementViewSectionPayment,
    SettlementViewSectionSettlement
}SettlementViewSection;

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface SettlementView () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *orderCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *couponCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *scoreCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *settlementCell;

//order
@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (weak, nonatomic) IBOutlet RichPriceView *orderPriceView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
//coupon
@property (weak, nonatomic) IBOutlet UILabel *couponDescriptionLabel;
//score
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;
@property (weak, nonatomic) IBOutlet UITextField *scoreField;
//settlement
@property (weak, nonatomic) IBOutlet RichPriceView *productTotalPriceView;
@property (weak, nonatomic) IBOutlet UILabel *promotionDescriptionLabel;
@property (weak, nonatomic) IBOutlet RichPriceView *promotionPriceView;
@property (weak, nonatomic) IBOutlet RichPriceView *scorePriceView;

@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) SettlementModel *model;

- (void)setCell:(UITableViewCell *)cell enabled:(BOOL)enabled;

@end

@implementation SettlementView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        SettlementView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([SettlementPayTypeCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    [self.orderPriceView setContentColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Normal];
    [self.orderPriceView setUnitFont:[UIFont systemFontOfSize:16]];
    [self.orderPriceView setPriceFont:[UIFont systemFontOfSize:20]];
    
    [self.productTotalPriceView setContentColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Normal];
    [self.productTotalPriceView setUnitFont:[UIFont systemFontOfSize:13] priceFont:[UIFont systemFontOfSize:13]];
    [self.promotionPriceView setContentColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Normal];
    [self.promotionPriceView setUnitFont:[UIFont systemFontOfSize:13] priceFont:[UIFont systemFontOfSize:13]];
    [self.scorePriceView setContentColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Normal];
    [self.scorePriceView setUnitFont:[UIFont systemFontOfSize:13] priceFont:[UIFont systemFontOfSize:13]];
    
    self.scoreField.delegate = self;
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SettlementViewSectionSettlement + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    switch (section) {
        case SettlementViewSectionProduct:
        {
            number = 1;
        }
            break;
        case SettlementViewSectionUserPromotion:
        {
            number = 2;
        }
            break;
        case SettlementViewSectionPayment:
        {
            number = [self.model.supportedPaymentTypes count];
        }
            break;
        case SettlementViewSectionSettlement:
        {
            number = 1;
        }
            break;
        default:
            break;
    }
    return number;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SettlementViewSectionProduct:
        {
            [self.orderImageView setImageWithURL:self.model.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
            [self.orderNameLabel setText:self.model.serviceName];
            [self.orderPriceView setPrice:self.model.price];
            [self.countLabel setText:[NSString stringWithFormat:@"x%lu", (unsigned long)self.model.count]];
            [self.orderCell.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
            return self.orderCell;
        }
            break;
        case SettlementViewSectionUserPromotion:
        {
            if (indexPath.row == 0) {
                if (self.model.usedCoupon) {
                    [self.couponDescriptionLabel setTextColor:[UIColor orangeColor]];
                    [self.couponDescriptionLabel setText:self.model.usedCoupon.couponTitle];
                } else {
                    [self.couponDescriptionLabel setTextColor:[UIColor darkGrayColor]];
                    NSString *canUseCountString = [NSString stringWithFormat:@"%lu张可使用", (unsigned long)[self.model.usableCoupons count]];
                    [self.couponDescriptionLabel setText:canUseCountString];
                }
                [self setCell:self.couponCell enabled:self.model.needPay];
                return self.couponCell;
            } else {
                NSString *scoreText = [NSString stringWithFormat:@"%lu", (unsigned long)self.model.canUseScore];
                NSString *text = [NSString stringWithFormat:@"共有%@积分可使用", scoreText];
                if (!self.model.needPay) {
                    text = @"没有可使用的积分";
                }
                NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
                [attrText addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2,[scoreText length])];
                [self.totalScoreLabel setAttributedText:attrText];
                
                if (self.model.usedScore > 0) {
                    [self.scoreField setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.model.usedScore]];
                } else {
                    [self.scoreField setText:@""];
                }
                [self setCell:self.scoreCell enabled:self.model.needPay];
                return self.scoreCell;
            }
        }
            break;
        case SettlementViewSectionPayment:
        {
            SettlementPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"SettlementPayTypeCell" owner:nil options:nil] objectAtIndex:0];
            }
            PaymentTypeModel *paymentModel = [self.model.supportedPaymentTypes objectAtIndex:indexPath.row];
            [cell setLogo:paymentModel.logo];
            [cell setPaymentName:paymentModel.name];
            if (self.model.needPay && self.model.totalPrice > 0) {
                [self setCell:cell enabled:YES];
            } else {
                [self setCell:cell enabled:NO];
            }
            return cell;
        }
            break;
        case SettlementViewSectionSettlement:
        {
            CGFloat totalPrice = self.model.price * self.model.count;
            [self.productTotalPriceView setPrice:totalPrice];
            
            [self.promotionDescriptionLabel setText:self.model.promotionModel.promotionDescription];
            CGFloat promotionPrice = self.model.promotionModel.cutAmount;
            if (self.model.usedCoupon) {
                promotionPrice = self.model.usedCoupon.discount;
                [self.promotionDescriptionLabel setText:@""];
            }
            [self.promotionPriceView setPrice:promotionPrice];
            
            CGFloat scorePrice = self.model.usedScore * ScoreCoefficient;
            [self.scorePriceView setPrice:scorePrice];
            [self.settlementCell.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
            return self.settlementCell;
        }
            break;
        default:
            break;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (indexPath.section) {
        case SettlementViewSectionProduct:
        {
            height = self.orderCell.frame.size.height;
        }
            break;
        case SettlementViewSectionUserPromotion:
        {
            if (indexPath.row == 0) {
                height = self.couponCell.frame.size.height;
            } else {
                height = self.scoreCell.frame.size.height;
            }
        }
            break;
        case SettlementViewSectionPayment:
        {
            height = [SettlementPayTypeCell cellHeight];
        }
            break;
        case SettlementViewSectionSettlement:
        {
            height = self.settlementCell.frame.size.height;
        }
            break;
        default:
            break;
    }
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    switch (section) {
        case SettlementViewSectionProduct:
        {
            height = 44;
        }
            break;
        case SettlementViewSectionUserPromotion:
        {
            height = 15;
        }
            break;
        case SettlementViewSectionPayment:
        {
            height = 44;
        }
            break;
        case SettlementViewSectionSettlement:
        {
            height = 0.01;
        }
            break;
        default:
            break;
    }
    return height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = nil;
    switch (section) {
        case SettlementViewSectionProduct:
        {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
            [view setBackgroundColor:[UIColor whiteColor]];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 24)];
            [titleLabel setFont:[UIFont systemFontOfSize:15]];
            [titleLabel setTextColor:[UIColor darkGrayColor]];
            [titleLabel setText:self.model.storeName];
            [view addSubview:titleLabel];
        }
            break;
        case SettlementViewSectionUserPromotion:
        {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 15)];
            [titleLabel setFont:[UIFont systemFontOfSize:13]];
            [titleLabel setTextColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Normal];
            [titleLabel setText:@"提示：商品促销优惠与优惠券不可共用"];
            [view addSubview:titleLabel];
        }
            break;
        case SettlementViewSectionPayment:
        {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 24)];
            [titleLabel setFont:[UIFont systemFontOfSize:15]];
            [titleLabel setTextColor:[UIColor lightGrayColor]];
            [titleLabel setText:@"选择支付方式"];
            [view addSubview:titleLabel];
            if (self.model.needPay && self.model.totalPrice > 0) {
                [view setBackgroundColor:[UIColor whiteColor]];
            } else {
                [view setBackgroundColor:RGBA(250, 250, 250, 1)];
            }
        }
            break;
        case SettlementViewSectionSettlement:
        {
        }
            break;
        default:
            break;
    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.scoreField resignFirstResponder];
    switch (indexPath.section) {
        case SettlementViewSectionProduct:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedServiceOnSettlementView:)]) {
                [self.delegate didClickedServiceOnSettlementView:self];
            }
        }
            break;
        case SettlementViewSectionUserPromotion:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            if (indexPath.row == 0) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedCouponOnSettlementView:)]) {
                    [self.delegate didClickedCouponOnSettlementView:self];
                }
            }
        }
            break;
        case SettlementViewSectionPayment:
        {
            NSArray *selectedIndexPaths = [tableView indexPathsForSelectedRows];
            for (NSIndexPath *idxPath in selectedIndexPaths) {
                if (idxPath.section != SettlementViewSectionPayment) {
                    continue;
                }
                if (idxPath.row != indexPath.row) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(settlementView:didSelectedPaymentAtIndex:)]) {
                        [self.delegate settlementView:self didSelectedPaymentAtIndex:indexPath.row];
                    }
                    [tableView deselectRowAtIndexPath:idxPath animated:YES];
                }
            }
        }
            break;
        case SettlementViewSectionSettlement:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SettlementViewSectionPayment) {
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self endEditing:YES];
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedScoreEditOnSettlementView:)]) {
        [self.delegate didClickedScoreEditOnSettlementView:self];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.model.usedScore = 0;
    NSString *scoreText = [NSString stringWithFormat:@"%lu", (unsigned long)self.model.canUseScore];
    NSString *text = [NSString stringWithFormat:@"共有%@积分可使用", scoreText];
    if (!self.model.needPay) {
        text = @"没有可使用的积分";
    }
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
    [attrText addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2,[scoreText length])];
    [self.totalScoreLabel setAttributedText:attrText];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSUInteger score = [textField.text integerValue];
    if (self.delegate && [self.delegate respondsToSelector:@selector(settlementView:didEndEditWithScore:)]) {
        [self.delegate settlementView:self didEndEditWithScore:score];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *finalString = [NSString stringWithFormat:@"%@%@", textField.text, string];
    NSInteger score = [finalString integerValue];
    if (score < 0) {
        [textField setText:@"0"];
        return NO;
    } else if (score > self.model.canUseScore) {
        [textField setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.model.canUseScore]];
        return NO;
    } else if (score == 0) {
        return NO;
    }
    return YES;
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(settlementModelForSettlementView:)]) {
        self.model = [self.dataSource settlementModelForSettlementView:self];
    }
    [self.tableView reloadData];
    NSUInteger index = 0;
    for (NSUInteger arrayIndex = 0; arrayIndex < [self.model.supportedPaymentTypes count]; arrayIndex ++) {
        PaymentTypeModel *typeModel = [self.model.supportedPaymentTypes objectAtIndex:arrayIndex];
        if (typeModel.type == self.model.currentPaymentType.type) {
            index = arrayIndex;
        }
    }
    if (self.model.needPay) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:SettlementViewSectionPayment] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    if (!self.model) {
        self.tableView.backgroundView = [[KTCEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.frame.size.height) image:[UIImage imageNamed:@""] description:@"啥都木有啊···"];
    } else {
        self.tableView.backgroundView = nil;
    }
}

- (void)setCell:(UITableViewCell *)cell enabled:(BOOL)enabled {
    [cell setUserInteractionEnabled:enabled];
    if (enabled) {
        [cell.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    } else {
        [cell.contentView setBackgroundColor:RGBA(250, 250, 250, 1)];
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
