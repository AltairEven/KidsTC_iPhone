//
//  OrderDetailButtonCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/27/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "OrderDetailButtonCell.h"

@interface OrderDetailButtonCell ()

@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

- (IBAction)didClickedLeftButton:(id)sender;
- (IBAction)didClickedRightButton:(id)sender;

@end

@implementation OrderDetailButtonCell

- (void)awakeFromNib {
    // Initialization code
    self.cancelButton.layer.borderWidth = BORDER_WIDTH;
    self.cancelButton.layer.borderColor = RGBA(255, 125, 125, 1).CGColor;
    [self.cancelButton.layer setMasksToBounds:YES];
    
    [self.cancelButton setBackgroundColor:RGBA(239, 239, 239, 1) forState:UIControlStateNormal];
    [self.cancelButton setBackgroundColor:RGBA(200, 200, 200, 1) forState:UIControlStateHighlighted];
    [self.rightButton setBackgroundColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.rightButton setBackgroundColor:[AUITheme theme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    [self.rightButton setBackgroundColor:[AUITheme theme].buttonBGColor_Disable forState:UIControlStateDisabled];
    
    [self.rightButton setHidden:YES];
    [self.cancelButton setHidden:YES];
    [self.descriptionLabel setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStatus:(OrderStatus)status {
    _status = status;
    switch (status) {
        case OrderStatusWaitingPayment:
        {
            [self.rightButton setHidden:NO];
            [self.rightButton setTitle:@"付款" forState:UIControlStateNormal];
            [self.cancelButton setHidden:NO];
            [self.descriptionLabel setHidden:YES];
        }
            break;
        case OrderStatusHasPayed:
        {
            [self.rightButton setHidden:NO];
            [self.rightButton setTitle:@"退款" forState:UIControlStateNormal];
            [self.cancelButton setHidden:YES];
            [self.descriptionLabel setHidden:NO];
            [self.descriptionLabel setText:@"付款成功，快去使用吧!"];
            [self.rightButton setEnabled:self.supportRefund];
        }
            break;
        case OrderStatusAllUsed:
        {
            [self.rightButton setHidden:NO];
            [self.rightButton setTitle:@"评价" forState:UIControlStateNormal];
            [self.cancelButton setHidden:YES];
            [self.descriptionLabel setHidden:NO];
            [self.descriptionLabel setText:@"评价后有惊喜哦!"];
        }
            break;
        default:
        {
            [self.rightButton setHidden:YES];
            [self.cancelButton setHidden:YES];
            [self.descriptionLabel setHidden:YES];
        }
            break;
    }
}

- (void)setSupportRefund:(BOOL)supportRefund {
    _supportRefund = supportRefund;
    if (self.status == OrderStatusHasPayed) {
        [self.rightButton setEnabled:supportRefund];
    }
}

+ (CGFloat)cellHeight {
    return 44;
}

+ (BOOL)willShowWithOrderStatus:(OrderStatus)status {
    if (status == OrderStatusWaitingPayment || status == OrderStatusHasPayed || status == OrderStatusAllUsed) {
        return YES;
    }
    return NO;
}

- (IBAction)didClickedLeftButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedCancelButtonOnOrderDetailButtonCell:)]) {
        [self.delegate didClickedCancelButtonOnOrderDetailButtonCell:self];
    }
}

- (IBAction)didClickedRightButton:(id)sender {
    if (self.delegate) {
        switch (self.status) {
            case OrderStatusWaitingPayment:
            {
                if ([self.delegate respondsToSelector:@selector(didClickedPayButtonOnOrderDetailButtonCell:)]) {
                    [self.delegate didClickedPayButtonOnOrderDetailButtonCell:self];
                }
            }
                break;
            case OrderStatusHasPayed:
            {
                if ([self.delegate respondsToSelector:@selector(didClickedReturnButtonOnOrderDetailButtonCell:)]) {
                    [self.delegate didClickedReturnButtonOnOrderDetailButtonCell:self];
                }
            }
                break;
            case OrderStatusAllUsed:
            {
                if ([self.delegate respondsToSelector:@selector(didClickedCommentButtonOnOrderDetailButtonCell:)]) {
                    [self.delegate didClickedCommentButtonOnOrderDetailButtonCell:self];
                }
            }
                break;
            default:
                break;
        }
    }
}

@end
