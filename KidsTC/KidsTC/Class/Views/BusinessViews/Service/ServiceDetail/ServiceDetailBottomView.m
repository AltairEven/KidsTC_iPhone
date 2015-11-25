//
//  ServiceDetailBottomView.m
//  KidsTC
//
//  Created by 钱烨 on 7/16/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceDetailBottomView.h"

@interface ServiceDetailBottomView ()

- (IBAction)didClickedButton:(id)sender;

@end

@implementation ServiceDetailBottomView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        ServiceDetailBottomView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    [self.buyButton setTitle:@"已售完" forState:UIControlStateDisabled];
    [self.buyButton setTitle:@"立即购买" forState:UIControlStateDisabled];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)didClickedButton:(id)sender {
    if (self.delegate) {
        UIButton *button = (UIButton *)sender;
        switch (button.tag) {
            case 0:
            {
                if ([self.delegate respondsToSelector:@selector(didClickedFavourateButtonOnServiceDetailBottomView:)]) {
                    [self.delegate didClickedFavourateButtonOnServiceDetailBottomView:self];
                }
            }
                break;
            case 1:
            {
                if ([self.delegate respondsToSelector:@selector(didClickedCustomerServiceButtonOnServiceDetailBottomView:)]) {
                    [self.delegate didClickedCustomerServiceButtonOnServiceDetailBottomView:self];
                }
            }
                break;
            case 2:
            {
                if ([self.delegate respondsToSelector:@selector(didClickedBuyButtonOnServiceDetailBottomView:)]) {
                    [self.delegate didClickedBuyButtonOnServiceDetailBottomView:self];
                }
            }
                break;
            default:
                break;
        }
    }
}

- (void)setFavourite:(BOOL)isFavourite {
    if (isFavourite) {
        [self.favourateButton setImage:[UIImage imageNamed:@"favourate_h"] forState:UIControlStateNormal];
    } else {
        [self.favourateButton setImage:[UIImage imageNamed:@"favourate_n"] forState:UIControlStateNormal];
    }
}

@end
