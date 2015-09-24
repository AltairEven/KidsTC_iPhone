//
//  SettlementBottomView.m
//  KidsTC
//
//  Created by 钱烨 on 7/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "SettlementBottomView.h"
#import "RichPriceView.h"

@interface SettlementBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet RichPriceView *priceView;

- (IBAction)didClickedButton:(id)sender;

@end

@implementation SettlementBottomView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        SettlementBottomView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    [self.priceView setContentColor:COLOR_GLOBAL_NORMAL];
    [self.priceView.unitLabel setFont:[UIFont systemFontOfSize:15]];
    [self.priceView.priceLabel setFont:[UIFont systemFontOfSize:25]];
    
    [self.confirmButton setBackgroundColor:COLOR_GLOBAL_NORMAL forState:UIControlStateNormal];
    [self.confirmButton setBackgroundColor:COLOR_GLOBAL_HIGHLIGHT forState:UIControlStateHighlighted];
}

- (void)setPrice:(CGFloat)price {
    _price = price;
    [self.priceView setPrice:price];
}

- (void)setSubmitEnable:(BOOL)enabled {
    [self.confirmButton setEnabled:enabled];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)didClickedButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedConfirmButtonOnSettlementBottomView:)]) {
        [self.delegate didClickedConfirmButtonOnSettlementBottomView:self];
    }
}

@end
