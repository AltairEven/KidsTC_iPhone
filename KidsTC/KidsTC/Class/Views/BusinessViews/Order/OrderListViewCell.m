//
//  OrderListViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "OrderListViewCell.h"

@interface OrderListViewCell ()
@property (weak, nonatomic) IBOutlet UIView *headerBGView;
@property (weak, nonatomic) IBOutlet UIView *infoBGView;
@property (weak, nonatomic) IBOutlet UIView *buttonBGView;

@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet RichPriceView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *payTypeDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIView *headerGap;
@property (weak, nonatomic) IBOutlet UIView *gapView;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

- (IBAction)didClickedRightButton:(id)sender;

@end

@implementation OrderListViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self.headerBGView setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalCellBGColor];
    [self.infoBGView setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalCellBGColor];
    [self.buttonBGView setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalCellBGColor];
    
    [self.rightButton setBackgroundColor:[[KTCThemeManager manager] currentTheme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.rightButton setBackgroundColor:[[KTCThemeManager manager] currentTheme].buttonBGColor_Disable forState:UIControlStateDisabled];
    
    //price view
    [self.priceView setContentColor:[UIColor darkGrayColor]];
    [self.priceView setUnitFont:[UIFont systemFontOfSize:15] priceFont:[UIFont systemFontOfSize:15]];
    [self.priceView setPrice:69.9];
    [self.priceView sizeToFitParameters];
    
    [GConfig resetLineView:self.gapView withLayoutAttribute:NSLayoutAttributeHeight];
    [GConfig resetLineView:self.headerGap withLayoutAttribute:NSLayoutAttributeHeight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configWithOrderListModel:(OrderListModel *)model atIndexPath:(NSIndexPath *)indexPath {
    if (model) {
        [self.orderImageView setImageWithURL:model.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
        [self.orderIdLabel setText:model.orderId];
        [self.orderStatusLabel setText:model.statusDescription];
        [self.orderNameLabel setText:model.orderName];
        [self.priceView setPrice:model.price];
        if ([model.pamentType.name length] > 0) {
            [self.payTypeDescriptionLabel setText:[NSString stringWithFormat:@"(%@)", model.pamentType.name]];
        }
        [self.orderDateLabel setText:model.orderDate];
        self.orderStatus = model.status;
        self.indexPath = indexPath;
        
        switch (model.status) {
            case OrderStatusWaitingPayment:
            {
                [self.rightButton setHidden:NO];
                [self.rightButton setTitle:@"付款" forState:UIControlStateNormal];
            }
                break;
            case OrderStatusAllUsed:
            {
                [self.rightButton setHidden:NO];
                [self.rightButton setTitle:@"评价" forState:UIControlStateNormal];
            }
                break;
            default:
            {
                [self.rightButton setHidden:YES];
            }
                break;
        }
    }
}

- (IBAction)didClickedRightButton:(id)sender {
    
    switch (self.orderStatus) {
        case OrderStatusWaitingPayment:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedPayButtonOnOrderListViewCell:)]) {
                [self.delegate didClickedPayButtonOnOrderListViewCell:self];
            }
        }
            break;
        case OrderStatusHasPayed:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedReturnButtonOnOrderListViewCell:)]) {
                [self.delegate didClickedReturnButtonOnOrderListViewCell:self];
            }
        }
            break;
        case OrderStatusAllUsed:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedCommentButtonOnOrderListViewCell:)]) {
                [self.delegate didClickedCommentButtonOnOrderListViewCell:self];
            }
        }
            break;
        default:
            break;
    }
}

@end
