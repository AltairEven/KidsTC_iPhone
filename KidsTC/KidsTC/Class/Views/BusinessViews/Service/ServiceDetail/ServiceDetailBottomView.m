//
//  ServiceDetailBottomView.m
//  KidsTC
//
//  Created by 钱烨 on 7/16/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceDetailBottomView.h"

#define StandardButtonWidth (60)

@interface ServiceDetailBottomView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneButtonWidth;

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
    [self setCustomerServiceButtonHidden:YES];
    [self setPhoneButtonHidden:YES];
    
    [self.buyButton setTitle:@"已售完" forState:UIControlStateDisabled];
    [self.buyButton setTitle:@"立即购买" forState:UIControlStateDisabled];
    [self.buyButton setBackgroundColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.buyButton setBackgroundColor:[AUITheme theme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    [self.buyButton setBackgroundColor:[AUITheme theme].buttonBGColor_Disable forState:UIControlStateDisabled];
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
                //在线客服
                if ([self.delegate respondsToSelector:@selector(didClickedCustomerServiceButtonOnServiceDetailBottomView:)]) {
                    [self.delegate didClickedCustomerServiceButtonOnServiceDetailBottomView:self];
                }
            }
                break;
            case 1:
            {
                //电话
                if ([self.delegate respondsToSelector:@selector(didClickedPhoneButtonOnServiceDetailBottomView:)]) {
                    [self.delegate didClickedPhoneButtonOnServiceDetailBottomView:self];
                }
            }
                break;
            case 2:
            {
                //收藏
                if ([self.delegate respondsToSelector:@selector(didClickedFavourateButtonOnServiceDetailBottomView:)]) {
                    [self.delegate didClickedFavourateButtonOnServiceDetailBottomView:self];
                }
            }
                break;
            case 3:
            {
                //购买
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

- (void)setCustomerServiceButtonHidden:(BOOL)hidden {
    [self.csButton setHidden:hidden];
    if (hidden) {
        self.csButtonWidth.constant = 0;
    } else {
        self.csButtonWidth.constant = StandardButtonWidth;
    }
}

- (void)setPhoneButtonHidden:(BOOL)hidden {
    [self.phoneButton setHidden:hidden];
    if (hidden) {
        self.phoneButtonWidth.constant = 0;
    } else {
        self.phoneButtonWidth.constant = StandardButtonWidth;
    }
}

@end
